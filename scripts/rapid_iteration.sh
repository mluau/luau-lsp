#!/usr/bin/env bash
# TODO: replace this with a seal script :p
# Switch luau-lsp's `luau/` between two modes:
#   symlink   - luau/ is a symlink to a local luau checkout, for fast local
#               iteration (edit ~/Repositories/luau, rebuild luau-lsp, no
#               commit/push/submodule-update round-trip needed).
#   submodule - luau/ is a real git submodule checkout pointed at the fork's
#               branch on the internet, for committing a proper submodule
#               pointer update / for CI-faithful builds.
#
# Usage:
#   scripts/luau-mode.sh status
#   scripts/luau-mode.sh symlink [path-to-local-luau-checkout]
#   scripts/luau-mode.sh submodule [branch]
#
# Env overrides:
#   LUAU_DEV_PATH   - local checkout to symlink to (default: ~/Repositories/luau)
#   LUAU_FORK_URL   - submodule remote url (default: git@github.com:mluau/luau.git)
#   LUAU_FORK_BRANCH - branch to check out in submodule mode
#                      (default: generic-parameters-on-nominal-types)

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LUAU_PATH="$REPO_ROOT/luau"
LUAU_DEV_PATH="${LUAU_DEV_PATH:-$HOME/Repositories/luau}"
LUAU_FORK_URL="${LUAU_FORK_URL:-git@github.com:mluau/luau.git}"
LUAU_FORK_BRANCH_DEFAULT="${LUAU_FORK_BRANCH:-generic-parameters-on-nominal-types}"

cmd="${1:-status}"

current_mode() {
    if [ -L "$LUAU_PATH" ]; then
        echo "symlink"
    elif [ -d "$LUAU_PATH/.git" ] || [ -f "$LUAU_PATH/.git" ]; then
        echo "submodule"
    elif [ -e "$LUAU_PATH" ]; then
        echo "unknown"
    else
        echo "missing"
    fi
}

print_status() {
    local mode
    mode="$(current_mode)"
    echo "luau/ mode: $mode"
    case "$mode" in
        symlink)
            echo "  -> $(readlink "$LUAU_PATH")"
            ;;
        submodule)
            (cd "$LUAU_PATH" && echo "  branch: $(git branch --show-current 2>/dev/null || echo '(detached)')" && echo "  commit: $(git rev-parse --short HEAD)" && echo "  remote: $(git remote get-url origin 2>/dev/null || echo '?')")
            ;;
        missing)
            echo "  (luau/ does not exist -- run 'git submodule update --init luau' or '$0 symlink')"
            ;;
    esac
}

deinit_submodule_if_present() {
    if [ -d "$LUAU_PATH/.git" ] || [ -f "$LUAU_PATH/.git" ]; then
        if [ -n "$(cd "$LUAU_PATH" && git status --porcelain 2>/dev/null)" ]; then
            echo "error: luau/ submodule checkout has uncommitted changes. Commit, stash, or discard them first." >&2
            (cd "$LUAU_PATH" && git status --short)
            exit 1
        fi
        echo "De-initializing existing luau/ submodule checkout..."
        git -C "$REPO_ROOT" submodule deinit -f luau
        rm -rf "$REPO_ROOT/.git/modules/luau"
    fi
}

do_symlink() {
    local target="${1:-$LUAU_DEV_PATH}"
    target="$(cd "$target" && pwd)"

    if [ ! -d "$target/.git" ]; then
        echo "error: $target does not look like a git checkout (no .git)" >&2
        exit 1
    fi

    local mode
    mode="$(current_mode)"
    if [ "$mode" = "symlink" ] && [ "$(readlink "$LUAU_PATH")" = "$target" ]; then
        echo "Already symlinked to $target"
        return
    fi

    deinit_submodule_if_present
    [ -L "$LUAU_PATH" ] && rm "$LUAU_PATH"
    [ -e "$LUAU_PATH" ] && { echo "error: $LUAU_PATH exists and isn't a submodule or symlink; refusing to touch it" >&2; exit 1; }

    ln -s "$target" "$LUAU_PATH"
    echo "Symlinked luau/ -> $target"
    echo "Note: this is a local-only convenience. Do not commit luau/ as a symlink --"
    echo "switch back with '$0 submodule' before committing the submodule pointer."
}

do_submodule() {
    local branch="${1:-$LUAU_FORK_BRANCH_DEFAULT}"

    if [ -L "$LUAU_PATH" ]; then
        echo "Removing luau symlink..."
        rm "$LUAU_PATH"
    fi

    local configured_url
    configured_url="$(git config -f "$REPO_ROOT/.gitmodules" --get submodule.luau.url || true)"
    if [ "$configured_url" != "$LUAU_FORK_URL" ]; then
        echo "Pointing .gitmodules submodule.luau.url at $LUAU_FORK_URL (was: ${configured_url:-unset})"
        git config -f "$REPO_ROOT/.gitmodules" submodule.luau.url "$LUAU_FORK_URL"
        git submodule sync -- luau
    fi

    git submodule update --init "$LUAU_PATH"

    (
        cd "$LUAU_PATH"
        git fetch origin "$branch"
        git checkout "$branch"
        git merge --ff-only "origin/$branch"
    )

    echo "luau/ is now a real submodule checkout on branch '$branch'"
    echo "Run 'git add luau' + commit in luau-lsp to record this pointer once you're happy with it."
}

case "$cmd" in
    status)
        print_status
        ;;
    symlink)
        do_symlink "${2:-}"
        ;;
    submodule)
        do_submodule "${2:-}"
        ;;
    *)
        echo "usage: $0 {status|symlink [path]|submodule [branch]}" >&2
        exit 1
        ;;
esac
