typeset -U path cdpath fpath manpath
for profile in ${(z)NIX_PROFILES}; do
  fpath+=($profile/share/zsh/site-functions $profile/share/zsh/$ZSH_VERSION/functions $profile/share/zsh/vendor-completions)
done

HELPDIR="/nix/store/vcrjkcll3rnr95xjql8rz57gjlhh2267-zsh-5.9/share/zsh/$ZSH_VERSION/help"

autoload -U compinit && compinit
source /nix/store/81s1mpv0x9r9p18xsp68h2083aipkmvq-zsh-autosuggestions-0.7.1/share/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_STRATEGY=(history)


# History options should be set in .zshrc and after oh-my-zsh sourcing.
# See https://github.com/nix-community/home-manager/issues/177.
HISTSIZE="10000"
SAVEHIST="10000"

HISTFILE="$HOME/.zsh_history"
mkdir -p "$(dirname "$HISTFILE")"

setopt HIST_FCNTL_LOCK
unsetopt APPEND_HISTORY
setopt HIST_IGNORE_DUPS
unsetopt HIST_IGNORE_ALL_DUPS
unsetopt HIST_SAVE_NO_DUPS
unsetopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
unsetopt HIST_EXPIRE_DUPS_FIRST
setopt SHARE_HISTORY
unsetopt EXTENDED_HISTORY


      export PATH=$PATH:~/tools
      if uwsm check may-start && uwsm select; then
	exec systemd-cat -t uwsm_start uwsm start default
      fi

      if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
        tmux attach-session -t main || tmux new-session -s main
      fi

      zellij_tab_name_update() {
        if [[ -n $ZELLIJ ]]; then
          local current_dir=$PWD
          if [[ $current_dir == $HOME ]]; then
              current_dir="~"
          else
              current_dir=${current_dir##*/}
          fi
          command nohup zellij action rename-tab $current_dir >/dev/null 2>&1
        fi
      }


      #if [[ -z "$ZELLIJ" ]]; then
      #  zellij attach -c main

       # if [[ "$ZELLIJ_AUTO_EXIT" == "true" ]]; then
       #   exit
       # fi
      #fi

      #zellij_tab_name_update
      #chpwd_functions+=(zellij_tab_name_update)
      # This command let's me execute arbitrary binaries downloaded through channels such as mason.
      export NIX_LD=$(nix eval --impure --raw --expr 'let pkgs = import <nixpkgs> {}; NIX_LD = pkgs.lib.fileContents "/nix/store/0fsnicvfpf55nkza12cjnad0w84d6ba7-gcc-wrapper-14.2.1.20250322/nix-support/dynamic-linker"; in NIX_LD')

function yy() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

source "/nix/store/n929iz30pfkz4gimy39b47sqjqiakhkx-wezterm-0-unstable-2025-05-18/etc/profile.d/wezterm.sh"

if [[ $TERM != "dumb" ]]; then
  eval "$(/nix/store/sa6y5dghbdj04i4dwz7lxglfk1iafdci-starship-1.23.0/bin/starship init zsh)"
fi

if test -n "$KITTY_INSTALLATION_DIR"; then
  export KITTY_SHELL_INTEGRATION="no-rc"
  autoload -Uz -- "$KITTY_INSTALLATION_DIR"/shell-integration/zsh/kitty-integration
  kitty-integration
  unfunction kitty-integration
fi

eval "$(/nix/store/wr9gi46jzk63wff2d0y4m3ngqnraq4p6-direnv-2.36.0/bin/direnv hook zsh)"

source <(/nix/store/l2g8685v04kwi6cf1c9qj55w48rdjwrx-carapace-1.3.1/bin/carapace _carapace zsh)

if [[ $options[zle] = on ]]; then
  eval "$(/nix/store/qsa2qgx5bah8wj270gz27wdbi3z8qlg7-atuin-18.6.1/bin/atuin init zsh )"
fi

alias -- build-ferrismx='QMK_HOME=~/vial-qmk qmk compile -kb ferris/sweep -km mxferris_linvert_blok -e CONVERT_TO=blok'
alias -- build-lily58='QMK_HOME=~/vial-qmk qmk compile -kb lily58/rev1 -km brian -e CONVERT_TO=rp2040_ce'
alias -- croc-rebuild='nixos-rebuild switch -s --flake .#loki --target-host root@loki.otter-rigel.ts.net  --verbose'
alias -- dashboard-rebuild='nixos-rebuild switch -s --flake .#tyr --target-host root@dashboard.otter-rigel.ts.net  --verbose'
alias -- flash-ferrismx='QMK_HOME=~/vial-qmk qmk flash -kb ferris/sweep -km mxferris_linvert_blok -e CONVERT_TO=blok'
alias -- flash-lily58='QMK_HOME=~/vial-qmk qmk flash -kb lily58/rev1 -km brian -e CONVERT_TO=rp2040_ce'
alias -- ga='git add'
alias -- gba='git branch -a'
alias -- gc='git commit -v'
alias -- gcb='git checkout -b'
alias -- gcmsg='git commit -m'
alias -- gco='git checkout'
alias -- gl='git pull'
alias -- gp='git push'
alias -- gst='git status'
alias -- nixgc='sudo nix-store --gc'
alias -- nixgcd='sudo nix-collect-garbage -d'
alias -- nixswitch='sudo nixos-rebuild switch --verbose --upgrade --flake /home/brian/nixconfig'
alias -- nixupdate='(cd /home/brian/nixconfig && nix flake update) && sudo nixos-rebuild switch --verbose --upgrade --flake /home/brian/nixconfig'
alias -- proxy-rebuild='nixos-rebuild switch -s --flake .#yggdrasil --target-host root@proxy.otter-rigel.ts.net --verbose'
alias -- setup-qmk='qmk setup bjsemrad/qmk_firmware -H ~/qmk_firmwarel'
alias -- setup-vial='qmk setup bjsemrad/vial-qmk -H ~/vial-qmk -b vial'
alias -- sshchannels='ssh channels@channels.otter-rigel.ts.net'
alias -- sshcroc='ssh worm@loki.otter-rigel.ts.net'
alias -- sshdash='ssh dash@dashboard.otter-rigel.ts.net'
alias -- sshminecraft='ssh mine@10.0.10.11'
alias -- sshprox='ssh root@proxmox.otter-rigel.ts.net'
alias -- sshproxy='ssh nginx@proxy.otter-rigel.ts.net'
alias -- sshtruenas='ssh root@10.0.10.13'
alias -- tailreceive='sudo tailscale file get .'
source /nix/store/rjrc4zzpjn9viahdjikggpqa6436jnwq-zsh-syntax-highlighting-0.8.0/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
ZSH_HIGHLIGHT_HIGHLIGHTERS+=()



eval "$(/nix/store/9f7y6h4yij2x0x6v35a7yjm5qyvvrjjs-zoxide-0.9.7/bin/zoxide init zsh --cmd cd --hook prompt)"
