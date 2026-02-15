{
  description = "Portable package for scripts in this directory";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
          commonDeps = with pkgs; [
            bash
            coreutils
          ];

          scriptDeps = {
            "amdgpu-reset.sh" = with pkgs; [ sudo ];
            "app-scope.sh" = with pkgs; [ systemd ];
            "battery-info.sh" = with pkgs; [ upower ];
            "battery-threshold.sh" = with pkgs; [
              gnugrep
              sudo
            ];
            "brightness-ddcci.sh" = with pkgs; [ findutils ];
            "brightness.sh" = with pkgs; [ sudo ];
            "colortest.sh" = [ ];
            "diff-oneside.sh" = with pkgs; [ diffutils ];
            "git-sparse-clone.sh" = with pkgs; [ git ];
            "ip-external.sh" = with pkgs; [ dnsutils ];
            "mutter-reset-displays.sh" = with pkgs; [ systemd ];
            "niri-session.sh" = with pkgs; [
              gawk
              gnome-keyring
              niri
              procps
              swayidle
              swaylock
              systemd
            ];
            "nvexec.sh" = [ ];
            "pkg.mod.sh" = [ ];
            "swap-flush.sh" = with pkgs; [
              sudo
              util-linux
            ];
            "sway-session.sh" = with pkgs; [
              gawk
              gnome-keyring
              procps
              sway
              swayidle
              swaylock
              systemd
            ];
            "sys-update.sh" = with pkgs; [
              curl
              dmidecode
              flatpak
              fwupd
              gnugrep
              htmlq
              nix
              "nvidia-settings"
              pup
              sudo
            ];
            "tmux-ssh.sh" = with pkgs; [
              openssh
              tmux
            ];
            "to-lower.sh" = [ ];
            "vnc-start-scraping.sh" = with pkgs; [ tigervnc ];
            "world-clock.sh" = [ ];
          };

          scriptPaths = pkgs.lib.mapAttrs (_: deps: pkgs.lib.makeBinPath (commonDeps ++ deps)) scriptDeps;
          defaultPath = pkgs.lib.makeBinPath commonDeps;
          wrapperCase =
            pkgs.lib.concatStringsSep "\n"
              (pkgs.lib.mapAttrsToList (name: path: ''
                "${name}") depPath='${path}' ;;
              '') scriptPaths);
        in
        {
          default = pkgs.stdenvNoCC.mkDerivation {
            pname = "dotfiles-bin";
            version = "0.1.0";
            src = ./.;

            nativeBuildInputs = [ pkgs.makeWrapper ];

            dontConfigure = true;
            dontBuild = true;

            installPhase = ''
              runHook preInstall

              mkdir -p "$out/bin"
              cp -a "$src"/*.sh "$out/bin/"
              chmod +x "$out/bin"/*.sh

              for script in "$out"/bin/*.sh; do
                name="$(basename "$script")"
                depPath='${defaultPath}'
                case "$name" in
                  ${wrapperCase}
                esac
                wrapProgram "$script" --prefix PATH : "$depPath"
              done

              runHook postInstall
            '';

            meta = {
              description = "Portable wrappers for personal scripts";
              platforms = pkgs.lib.platforms.linux;
            };
          };
        }
      );
    };
}
