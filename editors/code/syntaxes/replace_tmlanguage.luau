#!/usr/bin/env seal
--!strict
-- run with seal 0.8.0 https://github.com/seal-runtime/seal
const env = require("@std/env")
const fs = require("@std/fs")
const str = require("@std/str")

const home = fs.dir.home()
const here_path = fs.path.join(script:parent(), "Luau.tmLanguage.json")

const function find_luau_lsp_extension_dir(path: string): string?
    const extensions = fs.listdir(path, false)
    for _, ext in extensions do
        const child = assert(fs.path.child(ext))
        if str.startswith(child, "johnnymorganz.luau-lsp") then
            return ext
        end
    end
    return nil
end

const function get_tmlanguage_path()
    const extensions_dir = home:join(".vscode-oss", "extensions")
    assert(fs.path.exists(extensions_dir), "extensions dir doesn't exist")

    const luau_lsp_dir = find_luau_lsp_extension_dir(extensions_dir)
    assert(luau_lsp_dir, "can't find luau lsp dir")

    const syntaxes_dir = fs.path.join(luau_lsp_dir, "syntaxes")
    assert(fs.path.exists(syntaxes_dir), "missing syntaxes dir")

    return fs.path.join(syntaxes_dir, "Luau.tmLanguage.json")
end

const function pull_from_current_vscode()
    if env.os == "Linux" then
        const luau_tmlanguage_json_path = get_tmlanguage_path()
        if fs.path.exists(luau_tmlanguage_json_path) then
            fs.copy(luau_tmlanguage_json_path, here_path)
            print("succesfully overwrote local with vscode")
        end
    else
        error("uh os not supported yet")
    end
end

const function push_to_vscode()
    if env.os == "Linux" then
        const luau_tmlanguage_json_path = get_tmlanguage_path()
        fs.copy(here_path, luau_tmlanguage_json_path)
        print("successfully overwrite vscode with local")
    else
        error("uh os not supported yet")
    end
end


push_to_vscode()
