import assert from "node:assert/strict"
import { cpSync, mkdirSync, mkdtempSync, writeFileSync } from "node:fs"
import { tmpdir } from "node:os"
import { dirname as directoryName, join } from "node:path"
import { test } from "node:test"
import { fileURLToPath, pathToFileURL } from "node:url"

const TEST_DIRECTORY = directoryName(fileURLToPath(import.meta.url))
const RULE_TEMPLATE_PATH = join(TEST_DIRECTORY, "../../lib/generators/rails_icons/templates/rails-icons.mjs")

class StringNode {
  constructor(value) {
    this.unescaped = { encoding: "utf-8", validEncoding: true, value }
  }
}

class SymbolNode {
  constructor(value) {
    this.unescaped = { value }
  }
}

class LocalVariableReadNode {
  constructor(name) {
    this.name = name
  }
}

class SplatNode {
  constructor(expression) {
    this.expression = expression
  }
}

class CallNode {
  constructor(name, argumentNodes) {
    this.name = name
    this.receiver = null
    this.arguments_ = { arguments_: argumentNodes }
  }
}

class KeywordHashNode {
  constructor(elements) {
    this.elements = elements
  }
}

class AssocNode {
  constructor(optionName, optionValue) {
    this.key = optionName
    this.value = optionValue
  }
}

class ERBContentNode {
  constructor(prismNode, openingTag = "<%=") {
    this.prismNode = prismNode
    this.tag_opening = { value: openingTag }
    this.content = { value: " icon " }
    this.location = {
      start: { line: 1, column: 0 },
      end: { line: 1, column: 10 }
    }
  }
}

function document(...nodes) {
  return { body: nodes }
}

function iconCall(iconName, options = {}) {
  const argumentNodes = [
    iconName instanceof StringNode || iconName instanceof LocalVariableReadNode
      ? iconName
      : new StringNode(iconName)
  ]

  const optionElements = Object.entries(options).map(([optionName, optionValue]) => {
    const optionNode = typeof optionValue === "string" ? new StringNode(optionValue) : optionValue

    return new AssocNode(new SymbolNode(optionName), optionNode)
  })

  if (optionElements.length > 0) argumentNodes.push(new KeywordHashNode(optionElements))

  return new CallNode("icon", argumentNodes)
}

const ICON_MANIFEST = {
  version: 1,
  default_library: "heroicons",
  default_variant: "outline",
  libraries: {
    animated: {
      default_variant: null,
      variants: {
        default: { names: ["bouncing-dots", "faded-spinner"] }
      }
    },
    heroicons: {
      default_variant: "outline",
      variants: {
        outline: { path: "icons/heroicons/outline" },
        solid: { path: "icons/heroicons/solid" }
      }
    },
    mixed: {
      default_variant: null,
      variants: {
        solid: { path: "icons/mixed/solid" }
      }
    }
  }
}

async function loadRule() {
  const projectRoot = mkdtempSync(join(tmpdir(), "rails-icons-rule-"))
  const ruleDirectory = join(projectRoot, ".herb", "rules")

  mkdirSync(ruleDirectory, { recursive: true })
  cpSync(RULE_TEMPLATE_PATH, join(ruleDirectory, "rails-icons.mjs"))
  writeFileSync(join(projectRoot, ".herb", "icons.json"), `${JSON.stringify(ICON_MANIFEST, null, 2)}\n`)

  mkdirSync(join(projectRoot, "icons", "heroicons", "outline"), { recursive: true })
  mkdirSync(join(projectRoot, "icons", "heroicons", "solid"), { recursive: true })
  mkdirSync(join(projectRoot, "icons", "mixed", "solid"), { recursive: true })

  for (const iconName of ["check", "search"]) {
    writeFileSync(join(projectRoot, "icons", "heroicons", "outline", `${iconName}.svg`), "<svg/>")
  }

  for (const iconName of ["check", "heart"]) {
    writeFileSync(join(projectRoot, "icons", "heroicons", "solid", `${iconName}.svg`), "<svg/>")
  }

  writeFileSync(join(projectRoot, "icons", "mixed", "solid", "only.svg"), "<svg/>")

  const ruleModule = await import(pathToFileURL(join(ruleDirectory, "rails-icons.mjs")).href)

  return new ruleModule.default()
}

test("accepts a known icon in the default library and variant", async () => {
  const rule = await loadRule()
  const offenses = rule.check({ value: document(new ERBContentNode(iconCall("check"))) })

  assert.deepEqual(offenses, [])
})

test("rejects an unknown icon and suggests alternatives", async () => {
  const rule = await loadRule()
  const offenses = rule.check({ value: document(new ERBContentNode(iconCall("chek"))) })

  assert.equal(offenses.length, 1)
  assert.match(offenses[0].message, /Unknown icon "chek" in heroicons\/outline/)
  assert.match(offenses[0].message, /"check"/)
  assert.equal(offenses[0].rule, "rails-icons")
})

test("reports every occurrence of the same unknown icon", async () => {
  const rule = await loadRule()
  const firstCall = new ERBContentNode(iconCall("chek"))
  const secondCall = new ERBContentNode(iconCall("chek"))
  const offenses = rule.check({ value: document(firstCall, secondCall) })

  assert.equal(offenses.length, 2)
})

test("reports an unknown explicit variant", async () => {
  const rule = await loadRule()
  const offenses = rule.check({
    value: document(new ERBContentNode(iconCall("heart", { variant: "mini" })))
  })

  assert.equal(offenses.length, 1)
  assert.match(offenses[0].message, /Unknown variant "mini" for heroicons/)
  assert.match(offenses[0].message, /outline, solid/)
})

test("accepts string library and from values", async () => {
  const rule = await loadRule()
  const withFrom = rule.check({
    value: document(new ERBContentNode(iconCall("heart", {
      from: "heroicons",
      variant: "solid"
    })))
  })
  const withLibrary = rule.check({
    value: document(new ERBContentNode(iconCall("heart", {
      library: "heroicons",
      variant: "solid"
    })))
  })

  assert.deepEqual(withFrom, [])
  assert.deepEqual(withLibrary, [])
})

test("skips libraries without a known default variant", async () => {
  const rule = await loadRule()
  const withoutDefault = rule.check({
    value: document(new ERBContentNode(iconCall("missing", { library: "mixed" })))
  })
  const withExplicitVariant = rule.check({
    value: document(new ERBContentNode(iconCall("only", {
      library: "mixed",
      variant: "solid"
    })))
  })

  assert.deepEqual(withoutDefault, [])
  assert.deepEqual(withExplicitVariant, [])
})

test("resolves the from alias, the library option, and the variant", async () => {
  const rule = await loadRule()
  const knownOffenses = rule.check({
    value: document(new ERBContentNode(iconCall("heart", {
      from: new SymbolNode("heroicons"),
      variant: "solid"
    })))
  })
  const unknownOffenses = rule.check({
    value: document(new ERBContentNode(iconCall("heart", {
      library: new SymbolNode("heroicons")
    })))
  })

  assert.deepEqual(knownOffenses, [])
  assert.equal(unknownOffenses.length, 1)
  assert.match(unknownOffenses[0].message, /heroicons\/outline/)
})

test("validates animated icon names", async () => {
  const rule = await loadRule()
  const knownOffenses = rule.check({
    value: document(new ERBContentNode(iconCall("faded-spinner", {
      library: new SymbolNode("animated")
    })))
  })
  const unknownOffenses = rule.check({
    value: document(new ERBContentNode(iconCall("faded", {
      library: new SymbolNode("animated")
    })))
  })

  assert.deepEqual(knownOffenses, [])
  assert.equal(unknownOffenses.length, 1)
  assert.match(unknownOffenses[0].message, /animated\/default/)
})

test("skips dynamic names, unknown libraries, and silent tags", async () => {
  const rule = await loadRule()
  const dynamicName = new ERBContentNode(iconCall(new LocalVariableReadNode("name")))
  const unknownLibrary = new ERBContentNode(iconCall("check", { library: "missing" }))
  const silentTag = new ERBContentNode(iconCall("chek"), "<%")

  assert.deepEqual(rule.check({ value: document(dynamicName, unknownLibrary, silentTag) }), [])
})

test("skips dynamic options and spread arguments", async () => {
  const rule = await loadRule()
  const dynamicLibrary = new ERBContentNode(iconCall("chek", {
    library: new LocalVariableReadNode("library")
  }))
  const dynamicVariant = new ERBContentNode(iconCall("chek", {
    variant: new LocalVariableReadNode("variant")
  }))
  const withSpreadArguments = new ERBContentNode(
    new CallNode("icon", [
      new StringNode("chek"),
      new SplatNode(new LocalVariableReadNode("options"))
    ])
  )

  assert.deepEqual(
    rule.check({ value: document(dynamicLibrary, dynamicVariant, withSpreadArguments) }),
    []
  )
})
