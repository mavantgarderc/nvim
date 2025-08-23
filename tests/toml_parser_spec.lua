-- :lua require('plenary.test_harness').test_directory("tests/")

local toml = require("Raphael.toml_parser")

describe("toml_parser", function()
  describe("parse()", function()
    it("parses simple key-value pairs", function()
      local input = [[
foo = "bar"
num = 42
flag = true
]]
      local result = toml.parse(input)
      assert.are.same({
        root = {
          foo = "bar",
          num = 42,
          flag = true,
        }
      }, result)
    end)

    it("parses sections", function()
      local input = [[
[metadata]
name = "Test"
version = "1.0"
]]
      local result = toml.parse(input)
      assert.are.same({
        root = {},
        metadata = { name = "Test", version = "1.0" },
      }, result)
    end)

    it("parses nested keys with dot notation", function()
      local input = [[
[colors]
base.bg = "#000000"
base.fg = "#ffffff"
]]
      local result = toml.parse(input)
      assert.are.same({
        root = {},
        colors = {
          base = {
            bg = "#000000",
            fg = "#ffffff"
          }
        }
      }, result)
    end)

    it("parses arrays", function()
      local input = [[
values = [1, 2, 3, "hi", true]
]]
      local result = toml.parse(input)
      assert.are.same({
        root = {
          values = { 1, 2, 3, "hi", true },
        }
      }, result)
    end)
  end)

  describe("validate_colorscheme()", function()
    it("rejects missing sections", function()
      local ok, err = toml.validate_colorscheme({})
      assert.is_false(ok)
      assert.matches("Missing required section", err)
    end)

    it("accepts valid colorscheme", function()
      local data = {
        metadata = { name = "test" },
        colors = { red = "#ff0000" },
        highlights = {
          Normal = { fg = "red", bg = "#000000" }
        }
      }
      local ok, err = toml.validate_colorscheme(data)
      assert.is_true(ok, err)
    end)

    it("rejects invalid color reference", function()
      local data = {
        metadata = { name = "test" },
        colors = { red = "#ff0000" },
        highlights = {
          Normal = { fg = "does_not_exist" }
        }
      }
      local ok, err = toml.validate_colorscheme(data)
      assert.is_false(ok)
      assert.matches("references undefined color", err)
    end)
  end)

  describe("normalize_colorscheme()", function()
    it("fills missing metadata with defaults", function()
      local normalized = toml.normalize_colorscheme({
        metadata = {},
        colors = {},
        highlights = {}
      })
      assert.equal("untitled", normalized.metadata.name)
      assert.equal("untitled", normalized.metadata.display_name)
      assert.equal("dark", normalized.metadata.background)
      assert.equal("1.0.0", normalized.metadata.version)
    end)
  end)

  describe("export()", function()
    it("exports and re-parses equivalently", function()
      local input = {
        metadata = { name = "test" },
        colors = { red = "#ff0000" },
        highlights = {
          Normal = { fg = "red" }
        }
      }
      local text = toml.export(input)
      local parsed = toml.parse(text)
      assert.are.same(input, parsed)
    end)
  end)

  describe("generate_template()", function()
    it("generates a valid TOML template", function()
      local tpl = toml.generate_template("my_theme")
      local parsed = toml.parse(tpl)
      assert.is_truthy(parsed.metadata)
      assert.equal("my_theme", parsed.metadata.name)
    end)
  end)
end)
