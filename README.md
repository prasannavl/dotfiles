# dotpkg

My portable `dot-packages`.

Zero-conf, zero-dep with a simple bash script that focuses on cognitive simplicity
and natural workflows while allowing maximum flexibility for each pkg to be modular
and set its own rules of how to link, install and cleanup.

I've used various dot patterns out there in the last 2 decade from stow (longest)
to ansible (next) to fancy managers like chez_moi, dotter or nix all the way with
home-manager (love nix for flakes and pkg management). However, I've never enjoyed
the complexity as it grows just to keep my config and DRY on my essentials.
This is an attempt to simplify and make life sane.

**Note:** I tend to work as close to defaults as possible and minimal configuration
in most cases, except for some essential foundations or esoteric things that I use
often (e.g., my tmux prefix is `Alt+E`: so it's one-hand accessible, doesn't conflict
and doesn't stress my finger muscles for doing this all day).

Read the `pkg.mod.sh` file in each pkg for a quick idea on conventions.

## Guide

### Zero conf

- Create a dir to repr new package (eg: bash)
- Add your files
- Run `./pkg.sh sync bash` to link them to your home dir
- That's it. See [bash](./bash) for a real example.

```
bash/
├── .bashrc
├── .profile
└── .bashrc.d/
    ├── aliases.sh
    └── functions.sh
```

### Light conf

- Create a dir to repr new package (eg: nvim)
- Add your files
- Create `pkg.mod.sh` inside the dir for config
- Override the `vars` function and set `LINKS` array var to take control of want to link.

```bash
vars() {
    LINKS=(.config/nvim)
}
```

- Run `./pkg.sh sync nvim` to link them to your home dir.
- See [nvim](./nvim/pkg.mod.sh) for a real example.

```
nvim/
├── .config/nvim/<files>
└── pkg.mod.sh
```

### Light-ish conf

- Create a dir to repr new package (eg: tmux)
- Add your files
- Create `pkg.mod.sh` inside the dir for config
- Override the `vars` function and set `LINKS` array var to set tmux conf only.
- Override `post_link` to setup tpm plugin manager and install plugins.
- Override `pre_unlink` to cleanup tpm dir.
- Be a good citizen and add full conf cleanup to `clean_conf`

```bash
vars() {
    TMUX_PLUGIN_DIR="$HOME/.tmux/plugins"
    TMUX_TPM_DIR="$TMUX_PLUGIN_DIR/tpm"
    LINKS=(
        .tmux.conf
        )
}

post_link() {
  rm -rf "$TMUX_TPM_DIR"
  git clone https://github.com/tmux-plugins/tpm "$TMUX_TPM_DIR"
  $TMUX_TPM_DIR/bin/install_plugins
}

pre_unlink() {
  rm -rf "$TMUX_TPM_DIR"
}

clean_conf() {
  rm -rf "$TMUX_PLUGIN_DIR"
}
```

- Run `./pkg.sh sync tmux` to see it in action - your tmux conf linked
  and plugins installed - you're all set.
- See [tmux](./tmux/pkg.mod.sh) for a real example.


```
tmux/
├── .tmux.conf
└── pkg.mod.sh
```

### Medium conf

- The above tmux is nice. But what if you want to install tmux itself alongside the config as one unit?
- You can! Use the same steps above. Just override `install`, `uninstall` commands.


```bash
vars() {
    TMUX_PLUGIN_DIR="$HOME/.tmux/plugins"
    TMUX_TPM_DIR="$TMUX_PLUGIN_DIR/tpm"
    LINKS=(
        .tmux.conf
        )
}

post_link() {
  rm -rf "$TMUX_TPM_DIR"
  git clone https://github.com/tmux-plugins/tpm "$TMUX_TPM_DIR"
  $TMUX_TPM_DIR/bin/install_plugins
}

pre_unlink() {
  rm -rf "$TMUX_TPM_DIR"
}

clean_conf() {
  rm -rf "$TMUX_PLUGIN_DIR"
}

check_install() {
    command -v tmux > /dev/null
}

install() {
  sudo apt install tmux
}

uninstall() {
  sudo apt purge tmux --autoremove
}
```

- Run `./pkg.sh sync tmux` to link and setup tpm. tmux will be installed if needed,
  your tmux conf linked and plugins installed. Now you're really set.
- This is handy so you don't need to worry about disconnect between your conf
  and what's actually installed - if conf is there, so is your runtime - in one go.
- See [tmux](./tmux/pkg.mod.sh) for a real example.

### Alt conf

- This is nice. The first dot repo you get into any machine, but can I use this to install
  and setup tools base tools like deno or rust that need DRY but isn't the distro repo?
- Yep! Just override `install`, `uninstall` and leave `LINKS` to default of `()`.

#### Deno

```bash

```bash
vars() {
    BASH_COMPLETIONS_DIR=$HOME/.bashrc.d/completions
}

check_install() {
    command -v deno > /dev/null
}

install() {
    curl -fsSL https://deno.land/x/install/install.sh | sh
    after_install
}

after_install() {
    deno completions bash > "$BASH_COMPLETIONS_DIR/deno"
}

uninstall() {
    rm -f "$BASH_COMPLETIONS_DIR/deno"
    rm -rf "$HOME/.deno"
}
```

- Run `./pkg.sh sync deno` and you're all set.
- See [deno](./deno/pkg.mod.sh) for a real example.

#### Rust

Here's another for Rust toolchain with rustup:

```bash
vars() {
    BASH_COMPLETIONS_DIR=$HOME/.bashrc.d/completions
    COMPLETION_BINS=(
        rustup
        cargo
    )
}

check_install() {
    command -v rustup > /dev/null
}

install() {
    # for all options:
    # curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --help
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path -y
    after_install
}

after_install() {
    for bin in "${COMPLETION_BINS[@]}"; do
        rustup completions bash $bin > "$BASH_COMPLETIONS_DIR/$bin"
    done

    rustup component add rust-analyzer
    rustup target add wasm32-unknown-unknown
    rustup toolchain add nightly
}

uninstall() {
    # remove completions
    for bin in "${COMPLETION_BINS[@]}"; do
        rm -f "$BASH_COMPLETIONS_DIR/$bin"
    done

    rustup self uninstall -y
    rm -rf "$HOME/.rustup"
}

purge() {
    rm -rf "$HOME/.cargo"
}
```

- Run `./pkg.sh sync rust` and you're all set.
- See [rust](./rust/pkg.mod.sh) for a real example.

## Under the hood

The entire working is probably best explained by reading the tiny `./pkg.sh` file.
If you don't have time, these lines are the key logic - that's it.

```bash
    local x
    for x in "${pkgs[@]}"; do
        echo "=== $x ==="
        pushd "./$x" >/dev/null
        (
            # Note that we run all of these in a subshell giving it's mod file the
            # ability to override anything from this file and start fresh again.
            source "./$pkg_mod_file" 2>/dev/null || true
            run_cmd "$cmd"
        )
        popd >/dev/null
    done
```

- Everything else is just sane default impls, safe link guards and intuitive lifecycle.
- Most of the script is comments and help text. The actual logic is minimal convention
  plumbing - you can use this for anything without having to learn a new tool
  or language or configuration.
- The key trick is using subshells for each pkg to make bash behave like a
  it has nice default impls in pkg.sh while allowing you to override everything and
  keeping surface area small and intuitive.

### Process

- Create a new pkg dir in the root (e.g., tmux), with whichever files (.tmux.conf).
- For optional additional config, create `pkg.mod.sh` file inside the pkg dir
  - See lifecycle section below on flow.
  - The name of this file is configurable (`PKG_MOD_SH`)
- Run with `./pkg.sh <command> <package1> [<package2> ...]` to execute commands for
  specific packages.
- You can specify multiple packages to operate on in a single command.

### Lifecycle

- The main `pkg.sh` file does the following:
  - For each specified package:
    - Sources `pkg.mod.sh` file if available
    - Runs `vars` so you can override them all.
    - Runs the specified command (e.g., `sync`, `link`, `install`, `clean` etc.)
  - Default impl for all of the commands exist in `pkg.sh`
    - Default impl for `vars`:
      - `LINKS=()` (nothing will get linked)
    - Default impl of `link|unlink`
      - Call `pre_link | pre_unlink` if exists
      - For each file in `LINKS` var, link them inside `TARGET` dir
      - Call `post_link | post_unlink` if exists
      - This allows your package to flexibly choose whichever model:
      - Just add `LINKS` in `vars` to autolink and use `pre_` and `post_`
          hooks for additional work
        - Or override `link` and `unlink` completely and choose your own mechanism
          entirely.
  - This allows you to have a simple and consistent way to manage your dotfiles
    while allowing each package to override all of the impl if default convention
    isn't enough.

### Misc

- `install|uninstall`:
  - This extends the capability to also use a package manager to
    install what's needed before deploying the config, so everything is contained in
    one set. Allows you to simply deploy whole packages or nothing on different hosts.
  - **Please note that this is not meant to be yet another manager for your distro**.
    It's just handy to have this so you can use any source you want. What if your
    preferred way to get nvim is from source or `linuxbrew` or if you're like me and
    prefer to install latest version from `nix` than your operating system.
  - **Can this be made platform agnostic?** Right now it all uses apt since
    Debian is what I use and haven't bothered to put in the effort to add `APT_PKGS`
    and `DNF_PKGS` or `BREW_PKGS`. But should be trivial to extend default `install`
    impl to support this the same way `link` hooks use a default impl and offer
    `after` and `before` hooks for flexibility.
- **Host specific config:** It's just a simple script that takes pkgs as input. Create
  new files with as many sets as needed. See (`xset` dir for example)
- **Templating**: I prefer my dot file management to be simple, so it is agnostic
  of how to template. Use the above pre/post install hooks to use any templating
  engine for each pkg as desired. Low cognitive overhead and flexible to allow
  different templating based on a pkg's need than dump one on you.


### Usage

```
usage: <command> <package1> [<package2> ...]
env:
  TARGET: (target to install to, defaults to HOME env)
  PKG_MOD_SH: (the mod sh file to use for each module)
  FORCE_RELINK: (force relink without requiring unlink or fail for safety)
commands:
  sync: brings everything up to date: check_install [install], [re]link
  install: install the package
  check_install: check if package requires installation
  uninstall: uninstall the package
  link: link the package, can fail if links already exist
  relink: force re-link the package
  unlink: unlink the package
  clean_conf: clean the package configuration
  clean: unlink, clean_conf and cleans other files
  purge: uninstall, clean and purge other files
```

Example: `./pkg.sh sync bash tmux rust deno` will make sure all these pkgs
are installed, configured and ready to go!
