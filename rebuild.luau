--!strict
--- Configures and rebuilds luau-lsp in Debug mode against a local luau path, using -j8.
const process = require("@std/process")
const vars = require("@std/env/vars")
const fs = require("@std/fs")
const str = require("@std/str")
const terminal = require("@std/terminal")
const cursor = require("@std/terminal/cursor")

const LUAU_PATH = vars.get("LUWU_TEST_PATH") or error("missing LUWU_TEST_PATH env variable")

const DISPLAY_PATH = str.replace(LUAU_PATH, fs.path.home(), "~")
print(`using luau directory: {DISPLAY_PATH}`)

const configure = process.run {
    program = "cmake",
    args = {
        "-B", "build",
        "-DCMAKE_BUILD_TYPE=Debug",
        "-DLSP_LUAU_PATH=" .. LUAU_PATH,
    },
    stdio = "Inherit",
}
if not configure.ok then
    error("cmake configure failed")
end

const build = process.spawn({
    program = "cmake",
    args = { "--build", "build", "--target", "Luau.LanguageServer.CLI", "-j8" },
}) :: process.PipedChild

for line in build.stdout:lines() do
    terminal.execute(cursor.column(0), terminal.clear("CurrentLine"), terminal.write(line))
end
terminal.execute(cursor.column(0), terminal.clear("CurrentLine"))
print()

const build_errors = build.stderr:read(nil, 0.0)
if build_errors and build_errors ~= "" then
    print(build_errors)
    error("cmake build failed")
end

print("Rebuilt luwu lsp binary from test directory! Please reload your current editor")
