--!strict
--- Configures and rebuilds luau-lsp in Debug mode against a local luau path or submodule here, using -j8.
const process = require("@std/process")
const vars = require("@std/env/vars")
const fs = require("@std/fs")
const prompt = require("@std/io/prompt")
const str = require("@std/str")
const terminal = require("@std/terminal")
const cursor = require("@std/terminal/cursor")

const generate_keywords = require("./scripts/generate_keywords")

const function display_home(path): string
    return str.replace(path, fs.path.home(), "~")
end

const SUBMODULE_PATH = fs.dir.cwd():join("luau")
const SUBMODULE_DISPLAY_PATH = display_home(SUBMODULE_PATH)

const LUWU_PATH = vars.get("LUWU_TEST_PATH") or SUBMODULE_PATH
const LUWU_DISPLAY_PATH = display_home(LUWU_PATH)

const picked = 
    if terminal.tty() then
        prompt.pick("Use test path or submodule path?", {
            `Compile Luwu from LUWU_TEST_PATH={LUWU_DISPLAY_PATH}`,
            `Compile Luwu from this submodule = {SUBMODULE_DISPLAY_PATH}`
        })
    else
        1

generate_keywords()

const args = {
    "-B", "build",
    "-DCMAKE_BUILD_TYPE=Debug",
}
if picked == 1 then -- compiles against SUBMODULE_PATH by default
    if LUWU_PATH == SUBMODULE_PATH then
        error("LUWU_TEST_PATH selected but the environment variable isn't configured. \z
        Set it to the path of your local copy of Luwu you want to build against.")
    end
    print(`using luwu directory: {LUWU_DISPLAY_PATH}`)
    table.insert(args, "-DLSP_LUAU_PATH=" .. LUWU_PATH)
end   

const configure = process.run {
    program = "cmake",
    args = args,
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
