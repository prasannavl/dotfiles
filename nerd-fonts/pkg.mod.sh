vars() {
    FONTS=(
        FiraCode
        FiraMono
        Hack
        JetBrainsMono
        Noto
        RobotoMono
        SourceCodePro
    )
    FONTS_DIR="$HOME/.local/share/fonts"
    # this is where the install.sh script installs to.
    NERF_FONTS_DIR="$FONTS_DIR/NerdFonts"
}

check_install() {
    [[ -d "$NERF_FONTS_DIR" ]]
}

install() {
    local fonts_dir="$FONTS_DIR"
    if [[ ! -d "$fonts_dir" ]]; then
        mkdir -p "$fonts_dir"
    fi

    tmp_dir=$(mktemp -d)
    clone_dir="$tmp_dir/nerd-fonts"

    git clone --filter=blob:none --sparse https://github.com/ryanoasis/nerd-fonts "$clone_dir"
    pushd "$clone_dir" >/dev/null

    for font in "${FONTS[@]}"; do
        git sparse-checkout add "patched-fonts/$font"
        ./install.sh "$font"
    done

    popd >/dev/null
    rm -rf "$tmp_dir"
}

uninstall() {
    rm -rf "$NERF_FONTS_DIR"
}
