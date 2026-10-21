import {
  readFileSync,
  readdirSync as readDirectorySync,
  statSync as readFileStatusSync
} from "node:fs"
import { dirname as directoryName, join } from "node:path"
import { fileURLToPath } from "node:url"

const RULE_NAME = "rails-icons"
const RULE_DIRECTORY = directoryName(fileURLToPath(import.meta.url))
const PROJECT_ROOT = join(RULE_DIRECTORY, "..", "..")
const MANIFEST_PATH = join(RULE_DIRECTORY, "..", "icons.json")

const directoryCache = new Map()
let manifestCache = null

function loadManifest() {
  let modifiedTime

  try {
    modifiedTime = readFileStatusSync(MANIFEST_PATH).mtimeMs
  } catch {
    return null
  }

  if (manifestCache && manifestCache.modifiedTime === modifiedTime) {
    return manifestCache.manifest
  }

  try {
    const manifest = JSON.parse(readFileSync(MANIFEST_PATH, "utf8"))

    manifestCache = { modifiedTime, manifest }

    return manifest
  } catch {
    return null
  }
}

function readIconDirectory(relativePath) {
  const absolutePath = join(PROJECT_ROOT, relativePath)
  let modifiedTime

  try {
    modifiedTime = readFileStatusSync(absolutePath).mtimeMs
  } catch {
    return null
  }

  const cachedDirectory = directoryCache.get(absolutePath)

  if (cachedDirectory && cachedDirectory.modifiedTime === modifiedTime) {
    return cachedDirectory.iconNames
  }

  try {
    const iconNames = readDirectorySync(absolutePath, { withFileTypes: true })
      .filter((directoryEntry) => directoryEntry.isFile() && directoryEntry.name.endsWith(".svg"))
      .map((directoryEntry) => directoryEntry.name.slice(0, -4))
      .sort()

    directoryCache.set(absolutePath, { modifiedTime, iconNames })

    return iconNames
  } catch {
    return null
  }
}

function resolveVariant(manifest, libraryDetails, requestedVariant) {
  const variants = libraryDetails.variants ?? {}

  if (requestedVariant) {
    return { name: requestedVariant, explicit: true }
  }

  if (libraryDetails.default_variant && variants[libraryDetails.default_variant]) {
    return { name: libraryDetails.default_variant, explicit: false }
  }

  if (manifest.default_variant && variants[manifest.default_variant]) {
    return { name: manifest.default_variant, explicit: false }
  }

  if (variants.default) {
    return { name: "default", explicit: false }
  }

  return { name: null, explicit: false }
}

function iconNamesFor(libraryDetails, variant) {
  const variantDetails = libraryDetails.variants?.[variant]
  if (!variantDetails) return null

  if (Array.isArray(variantDetails.names)) return variantDetails.names
  if (!variantDetails.path) return null

  return readIconDirectory(variantDetails.path)
}

function literalValue(node) {
  if (!node) return null

  const nodeType = node.constructor?.name

  if (nodeType === "StringNode" || nodeType === "SymbolNode") {
    if (typeof node.unescaped === "string") return node.unescaped
    if (typeof node.unescaped?.value === "string") return node.unescaped.value
    if (typeof node.content === "string") return node.content
    if (typeof node.value === "string") return node.value
  }

  return null
}

function argumentNodesFor(call) {
  const callArguments = call.arguments_
  if (!callArguments) return []
  if (Array.isArray(callArguments)) return callArguments

  return Array.isArray(callArguments.arguments_) ? callArguments.arguments_ : []
}

function optionsFrom(argumentNodes) {
  const options = {}
  const dynamicOptions = new Set()
  let hasSpreadArguments = false

  for (const argumentNode of argumentNodes.slice(1)) {
    const nodeType = argumentNode?.constructor?.name

    if (nodeType === "SplatNode" || nodeType === "ForwardingArgumentsNode") {
      hasSpreadArguments = true
      continue
    }

    if (nodeType !== "KeywordHashNode" && nodeType !== "HashNode") continue

    for (const element of argumentNode.elements ?? []) {
      if (element?.constructor?.name !== "AssocNode") {
        hasSpreadArguments = true
        continue
      }

      const optionName = literalValue(element.key)

      if (!optionName) {
        hasSpreadArguments = true
        continue
      }

      if (element.value?.constructor?.name === "NilNode") {
        options[optionName] = null
        continue
      }

      const optionValue = literalValue(element.value)

      if (optionValue === null) {
        dynamicOptions.add(optionName)
      } else {
        options[optionName] = optionValue
      }
    }
  }

  return { options, dynamicOptions, hasSpreadArguments }
}

function findIconCalls(prismNode) {
  const iconCalls = []
  const visitedNodes = new Set()

  function visit(node) {
    if (!node || typeof node !== "object") return
    if (visitedNodes.has(node)) return

    visitedNodes.add(node)

    if (node.constructor?.name === "CallNode" && node.name === "icon" && !node.receiver) {
      iconCalls.push(node)
    }

    for (const propertyName of Object.keys(node)) {
      if (propertyName === "location" || propertyName.endsWith("Loc")) continue

      const childNode = node[propertyName]

      if (Array.isArray(childNode)) {
        childNode.forEach(visit)
      } else if (childNode && typeof childNode === "object") {
        visit(childNode)
      }
    }
  }

  visit(prismNode)

  return iconCalls
}

function isERBContentNode(node) {
  if (node?.constructor?.name === "ERBContentNode") return true

  return Boolean(node?.tag_opening && node?.content && node?.prismNode !== undefined)
}

function isOutputNode(node) {
  return String(node?.tag_opening?.value ?? "").startsWith("<%=")
}

function walkNodes(root, visit) {
  const visitedNodes = new Set()

  function walk(node) {
    if (!node || typeof node !== "object") return
    if (visitedNodes.has(node)) return

    visitedNodes.add(node)
    visit(node)

    if (Array.isArray(node.children)) node.children.forEach(walk)
    if (Array.isArray(node.body)) node.body.forEach(walk)
  }

  walk(root)
}

function editDistance(leftValue, rightValue) {
  let previousRow = Array.from({ length: rightValue.length + 1 }, (_, index) => index)

  for (let leftIndex = 1; leftIndex <= leftValue.length; leftIndex++) {
    const currentRow = [leftIndex]

    for (let rightIndex = 1; rightIndex <= rightValue.length; rightIndex++) {
      currentRow[rightIndex] = Math.min(
        previousRow[rightIndex] + 1,
        currentRow[rightIndex - 1] + 1,
        previousRow[rightIndex - 1] + (leftValue[leftIndex - 1] === rightValue[rightIndex - 1] ? 0 : 1)
      )
    }

    previousRow = currentRow
  }

  return previousRow[rightValue.length]
}

function suggestionsFor(iconName, iconNames) {
  const lowercaseName = iconName.toLowerCase()
  const distanceThreshold = Math.max(2, Math.floor(iconName.length / 3))

  return iconNames
    .filter((candidateName) => candidateName !== iconName)
    .filter((candidateName) => Math.abs(candidateName.length - iconName.length) <= distanceThreshold)
    .map((candidateName) => [candidateName, editDistance(lowercaseName, candidateName.toLowerCase())])
    .filter(([, distance]) => distance <= distanceThreshold)
    .sort((left, right) => left[1] - right[1] || left[0].localeCompare(right[0]))
    .slice(0, 3)
    .map(([candidateName]) => candidateName)
}

function includeSuggestions(message, suggestions) {
  if (suggestions.length === 0) return message

  return `${message} Did you mean ${suggestions.map((suggestion) => `"${suggestion}"`).join(", ")}?`
}

export default class RailsIconsRule {
  static ruleName = "rails-icons"

  get ruleName() {
    return RailsIconsRule.ruleName
  }

  get defaultConfig() {
    return {
      enabled: true,
      severity: "warning"
    }
  }

  get parserOptions() {
    return {
      prism_nodes: true
    }
  }

  check(parseResult) {
    const manifest = loadManifest()
    if (!manifest || !parseResult?.value) return []

    const offenses = []

    walkNodes(parseResult.value, (node) => {
      if (!isERBContentNode(node) || !isOutputNode(node) || !node.prismNode) return

      for (const call of findIconCalls(node.prismNode)) {
        const argumentNodes = argumentNodesFor(call)
        const iconName = literalValue(argumentNodes[0])
        if (!iconName) continue

        const { options, dynamicOptions, hasSpreadArguments } = optionsFrom(argumentNodes)
        if (hasSpreadArguments) continue
        if (dynamicOptions.has("library") || dynamicOptions.has("from") || dynamicOptions.has("variant")) continue

        const library = options.from || options.library || manifest.default_library
        if (!library) continue

        const libraryDetails = manifest.libraries?.[library]
        if (!libraryDetails) continue

        if (!node.location) continue

        const variant = resolveVariant(manifest, libraryDetails, options.variant)

        if (variant.explicit && !libraryDetails.variants?.[variant.name]) {
          const availableVariants = Object.keys(libraryDetails.variants ?? {}).sort()
          const availableText = availableVariants.length > 0
            ? ` Available variants: ${availableVariants.join(", ")}.`
            : ""

          offenses.push({
            rule: RULE_NAME,
            code: RULE_NAME,
            source: "Herb Linter",
            message: `Unknown variant "${variant.name}" for ${library}.${availableText}`,
            location: node.location
          })

          continue
        }

        if (!variant.name) continue

        const iconNames = iconNamesFor(libraryDetails, variant.name)
        if (!iconNames) continue
        if (iconNames.includes(iconName)) continue

        const message = includeSuggestions(
          `Unknown icon "${iconName}" in ${library}/${variant.name}.`,
          suggestionsFor(iconName, iconNames)
        )

        offenses.push({
          rule: RULE_NAME,
          code: RULE_NAME,
          source: "Herb Linter",
          message,
          location: node.location
        })
      }
    })

    return offenses
  }
}
