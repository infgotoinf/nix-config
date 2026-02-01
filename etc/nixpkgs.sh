#!/usr/bin/env bash

case "$(basename "$SHELL")" in
bash | zsh | sh)
    # Keep the current shell
    ;;
*)
    # In case the system uses a non-POSIX shell, like fish or nushell,
    # we want to ensure run also our forked processes in a bash environment.
    SHELL="bash"
    ;;
esac

# === Change keybinds or add more here ===

declare -a INDEXES=(
    "nixpkgs ctrl-n"
    "home-manager ctrl-h"

    # you can add any indexes combination here,
    # like `nixpkgs,nixos`

    "all ctrl-a"
)

OPEN_SOURCE_KEY="ctrl-s"
OPEN_HOMEPAGE_KEY="ctrl-o"
PRINT_PREVIEW_KEY="ctrl-p"

OPENER="xdg-open"

if [[ "$(uname)" == 'Darwin' ]]; then
    OPEN_SOURCE_KEY="alt-s"
    OPEN_HOMEPAGE_KEY="alt-o"
    PRINT_PREVIEW_KEY="alt-p"

    OPENER="open"
fi

# ========================================

# for debug / development
CMD="${NIX_SEARCH_TV:-nix-search-tv}"

# bind_index binds the given $key to the given $index
bind_index() {
    local key="$1"
    local index="$2"

    local prompt=""
    local indexes_flag=""
    if [[ -n "$index" && "$index" != "all" ]]; then
        indexes_flag="--indexes $index"
        prompt=$index
    fi

    local preview="$CMD preview $indexes_flag"
    local print="$CMD print $indexes_flag"

    echo "$key:change-prompt($prompt> )+change-preview($preview {})+reload($print)"
}

STATE_FILE="/tmp/nix-search-tv-fzf"

# save_state saves the currently displayed index
# to the $STATE_FILE. This file serves as an external script state
# for communication between "print" and "preview" commands
save_state() {
    local index="$1"

    local indexes_flag=""
    if [[ -n "$index" && "$index" != "all" ]]; then
        indexes_flag="--indexes $index"
    fi

    echo "execute(echo $indexes_flag > $STATE_FILE)"
}

HEADER="$OPEN_HOMEPAGE_KEY - open homepage
$OPEN_SOURCE_KEY - open source
$PRINT_PREVIEW_KEY - print preview
"

FZF_BINDS=""
for e in "${INDEXES[@]}"; do
    index=$(echo "$e" | awk '{ print $1 }')
    keybind=$(echo "$e" | awk '{ print $2 }')

    fzf_bind=$(bind_index "$keybind" "$index")
    fzf_save_state=$(save_state "$index")
    FZF_BINDS="$FZF_BINDS --bind '$fzf_bind+$fzf_save_state'"

    newline=$'\n'
    HEADER="$HEADER$keybind - $index$newline"
done

# reset the state
echo "" >/tmp/nix-search-tv-fzf

# shellcheck disable=SC2016
PREVIEW_WINDOW='
    if [[ ${FZF_COLS:-$COLUMNS} -lt 130 ]]; then
        echo "+change-preview-window(wrap,up)"
    else
        echo "+change-preview-window(wrap)"
    fi
'

eval "$CMD print | fzf \
    --preview '$CMD preview \$(cat $STATE_FILE) {}' \
    --bind '$OPEN_SOURCE_KEY:execute($CMD source \$(cat $STATE_FILE) {} | xargs $OPENER)' \
    --bind '$OPEN_HOMEPAGE_KEY:execute($CMD homepage \$(cat $STATE_FILE) {} | xargs $OPENER)' \
    --bind $'$PRINT_PREVIEW_KEY:become($CMD preview \$(cat $STATE_FILE) {})' \
    --layout reverse \
    --scheme history \
    --bind 'resize,start:transform:$PREVIEW_WINDOW' \
    --header '$HEADER' \
    --header-first \
    --header-border \
    --header-label \"Help\" \
    $FZF_BINDS
"
