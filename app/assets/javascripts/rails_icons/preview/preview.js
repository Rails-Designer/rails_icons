class RailsIconPreview extends HTMLElement {
  connectedCallback() {
    this.#render()
  }

  get searchData() {
    return {
      id: this.#name,
      name: this.#name,
      tags: this.getAttribute('tags') || ''
    }
  }

  #render() {
    this.innerHTML = `
      <section>
        <div class='svg'>${this.#svgIcon}</div>
        <p title='${this.#name}'>${this.#name}</p>

        <div class='actions'>
          <button data-action='copy-name'>Copy name</button>

          <button data-action='copy-helper'>Copy helper</button>
        </div>
      </section>
    `

    this.querySelector('[data-action="copy-name"]').onclick = () => this.#copyName()
    this.querySelector('[data-action="copy-helper"]').onclick = () => this.#copyHelper()
  }

  #copyName() {
    navigator.clipboard.writeText(this.#name)
  }

  #copyHelper() {
    const parts = [`icon('${this.#name}'`]

    if (this.#library !== this.#defaultLibrary) {
      parts.push(`library: :${this.#library}`)
    }

    if (this.#variant && this.#variant !== this.#defaultVariant) {
      parts.push(`variant: :${this.#variant}`)
    }

    const helper = parts.length > 1 ? `${parts[0]}, ${parts.slice(1).join(', ')})` : `${parts[0]})`
    navigator.clipboard.writeText(helper)
  }

  get #name() {
    return this.getAttribute('name')
  }

  get #library() {
    return this.getAttribute('library')
  }

  get #variant() {
    return this.getAttribute('variant')
  }

  get #defaultLibrary() {
    return this.getAttribute('default-library')
  }

  get #defaultVariant() {
    return this.getAttribute('default-variant')
  }

  get #svgIcon() {
    return this.innerHTML
  }
}

customElements.define('rails-icon-preview', RailsIconPreview)


class IconSearch {
  constructor() {
    this.searchInput = document.querySelector('input[type="search"]')
    this.resultCount = document.querySelector('.result-count')
    this.icons = Array.from(document.querySelectorAll('rails-icon-preview'))
    this.totalCount = this.icons.length

    this.miniSearch = new MiniSearch({
      fields: ['name', 'tags'],
      storeFields: ['id'],
      searchOptions: {
        fuzzy: false,
        prefix: false
      }
    })

    this.#indexIcons()
  }

  getIconList() {
    return document.querySelector('ul.icons')
  }

  getVisibleIcons() {
    return this.icons.filter(icon => icon.closest('li').style.display !== 'none')
  }

  #indexIcons() {
    const documents = this.icons.map(icon => icon.searchData)

    this.miniSearch.addAll(documents)
  }

  filterIcons(query) {
    if (!query) {
      this.icons.forEach(icon => {
        icon.closest('li').style.display = ''
      })

      this.#updateResultCount(this.totalCount)
      this.#showNoResults(false)

      return
    }

    const results = this.miniSearch.search(query)
    const resultIds = new Set(results.map(result => result.id))
    let visibleCount = 0

    this.icons.forEach(icon => {
      const listItem = icon.closest('li')

      if (resultIds.has(icon.searchData.id)) {
        listItem.style.display = ''

        visibleCount++
      } else {
        listItem.style.display = 'none'
      }
    })

    this.#updateResultCount(visibleCount)
    this.#showNoResults(visibleCount === 0, query)
  }

  #updateResultCount(count) {
    if (this.resultCount) {
      this.resultCount.textContent = count === this.totalCount
        ? ''
        : `${count} of ${this.totalCount} icons`
    }
  }

  #showNoResults(show, query = '') {
    const noResults = document.querySelector('.no-results')
    const iconsList = document.querySelector('ul.icons')

    if (show) {
      noResults.removeAttribute('hidden')
      noResults.querySelector('.query').textContent = query

      iconsList.setAttribute('hidden', 'hidden')
    } else {
      noResults.setAttribute('hidden', 'hidden')

      iconsList.removeAttribute('hidden')
    }
  }
}


class UrlSync {
  constructor({ onSearch }) {
    this.onSearch = onSearch

    this.#loadFromUrl()
  }

  #loadFromUrl() {
    const params = new URLSearchParams(window.location.search)
    const query = params.get('q')

    if (query) {
      this.onSearch?.(query)
    }
  }

  updateUrl(query) {
    const url = new URL(window.location)

    if (query) {
      url.searchParams.set('q', query)
    } else {
      url.searchParams.delete('q')
    }

    history.replaceState(null, '', url)
  }
}


class KeyboardController {
  constructor({ searchInput, iconList, iconSearch, onFilter, onClearFocus, onActivate }) {
    this.searchInput = searchInput
    this.iconList = iconList
    this.iconSearch = iconSearch

    this.onFilter = onFilter
    this.onClearFocus = onClearFocus
    this.onActivate = onActivate

    this.focusedIndex = -1

    this.#setup()
  }

  #setup() {
    this.#setupGlobalKeys()
    this.#setupSearchInputKeys()
    this.#setupIconListKeys()
  }

  #setupGlobalKeys() {
    document.addEventListener('keydown', (event) => {
      if (event.target.tagName === 'INPUT' || event.target.tagName === 'TEXTAREA') return

      if (event.key === '/') {
        event.preventDefault()

        this.searchInput?.focus()

        return
      }

      if (event.key.length === 1 && /[a-zA-Z0-9]/.test(event.key)) {
        this.searchInput?.focus()
      }
    })
  }

  #setupSearchInputKeys() {
    this.searchInput?.addEventListener('keydown', (event) => {
      switch (event.key) {
        case 'Escape':
          this.searchInput.value = ''
          this.searchInput.blur()
          this.onFilter('')
          this.#clearFocus()

          break
        case 'ArrowDown':
          event.preventDefault()

          this.#moveFocus(1)

          break
        case 'ArrowUp':
          event.preventDefault()

          this.#moveFocus(-1)

          break
        case 'Enter':
          if (this.focusedIndex >= 0) {
            this.#activateFocused()
          }

          break
      }
    })

    this.searchInput?.addEventListener('input', (event) => {
      this.#clearFocus()
    })
  }

  #setupIconListKeys() {
    this.iconList?.addEventListener('keydown', (event) => {
      switch (event.key) {
        case 'ArrowDown':
          event.preventDefault()

          this.#moveFocus(1)

          break
        case 'ArrowUp':
          event.preventDefault()

          this.#moveFocus(-1)

          break
        case 'Enter':
        case ' ':
          if (this.focusedIndex >= 0) {
            event.preventDefault()

            this.#activateFocused()
          }

          break
        case 'Escape':
          this.#clearFocus()

          this.searchInput?.focus()

          break
      }
    })
  }

  setFocusedIndex(index) {
    this.focusedIndex = index
  }

  #moveFocus(direction) {
    const icons = this.iconSearch?.getVisibleIcons() || []
    if (icons.length === 0) return

    this.focusedIndex += direction

    if (this.focusedIndex < 0) {
      this.focusedIndex = icons.length - 1
    } else if (this.focusedIndex >= icons.length) {
      this.focusedIndex = 0
    }

    this.#updateFocus(icons)
  }

  #updateFocus(icons) {
    icons.forEach((icon, index) => {
      icon.closest('li').classList.toggle('focused', index === this.focusedIndex)
    })

    if (icons[this.focusedIndex]) {
      icons[this.focusedIndex].closest('li').scrollIntoView({ block: 'nearest' })
    }
  }

  #clearFocus() {
    this.focusedIndex = -1

    const icons = this.iconSearch?.icons || []

    icons.forEach(icon => icon.closest('li').classList.remove('focused'))

    this.onClearFocus?.()
  }

  #activateFocused() {
    const icons = this.iconSearch?.getVisibleIcons() || []
    const focusedIcon = icons[this.focusedIndex]

    if (focusedIcon) {
      focusedIcon.querySelector('[data-action="copy-helper"]')?.click()
    }
  }
}


document.addEventListener('DOMContentLoaded', () => {
  const searchInput = document.querySelector('input[type="search"]')
  const iconList = document.querySelector('ul.icons')
  const iconSearch = new IconSearch()

  const urlSync = new UrlSync({
    onSearch: (query) => {
      searchInput.value = query

      iconSearch.filterIcons(query)
    }
  })

  const keyboard = new KeyboardController({
    searchInput,
    iconList,
    iconSearch,

    onFilter: (query) => {
      iconSearch.filterIcons(query)
      urlSync.updateUrl(query)
    },

    onClearFocus: () => keyboard.setFocusedIndex(-1)
  })

  searchInput?.addEventListener('input', (event) => {
    const query = event.target.value.trim()

    iconSearch.filterIcons(query)

    urlSync.updateUrl(query)
  })
})
