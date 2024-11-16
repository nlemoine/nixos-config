{ config, pkgs, lib, ... }:

let name = "Nicolas Lemoine";
    user = "nico";
    email = "nico.lemoine@gmail.com"; in
{
  # Shared shell configuration
  zsh = {
    enable = true;
    autocd = false;
    # plugins = [
    #   {
    #     name = "powerlevel10k";
    #     src = pkgs.zsh-powerlevel10k;
    #     file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
    #   }
    #   {
    #     name = "powerlevel10k-config";
    #     src = lib.cleanSource ./config;
    #     file = "p10k.zsh";
    #   }
    # ];

    initExtraFirst = ''
      if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
        . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
        . /nix/var/nix/profiles/default/etc/profile.d/nix.sh
      fi

      eval "$(/usr/local/bin/brew shellenv)"

      # FZF
      [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

      # Zoxide
      eval "$(zoxide init zsh)"

      # Starship
      eval "$(starship init zsh)"

      # Aliases
      alias sf="symfony"

      autoload -Uz compinit && compinit

      # History
      export HISTSIZE=500000
      export SAVEHIST=$HISTSIZE

      # Remove superfluous blanks from each command line being added to the history
      # list
      setopt histreduceblanks
      # Remove command lines from the history list when the first character on the
      # line is a space, or when one of the expanded aliases contains a leading space
      setopt histignorespace
      # Do not enter command lines into the history list if they are duplicates of the
      # previous event.
      setopt histignorealldups

      # case-insensitive (uppercase from lowercase) completion
      eval "$(atuin init zsh)"

      # Define variables for directories
      export PATH=$HOME/.pnpm-packages/bin:$HOME/.pnpm-packages:$PATH
      export PATH=$HOME/.npm-packages/bin:$HOME/bin:$PATH
      export PATH=$HOME/.composer/vendor/bin:$PATH
      export PATH=$HOME/.local/share/bin:$PATH

      # Remove history data we don't want to see
      export HISTIGNORE="pwd:ls:cd"

      # nix shortcuts
      shell() {
          nix-shell '<nixpkgs>' -A "$1"
      }

      # Use difftastic, syntax-aware diffing
      alias diff=difft

      # Always color ls and group directories
      alias ls='ls --color=auto'
    '';
  };

  git = {
    enable = true;
    ignores = [ "*.swp" ];
    userName = name;
    userEmail = email;
    lfs = {
      enable = true;
    };
    extraConfig = {
      init.defaultBranch = "main";
      core = {
	    editor = "vim";
        autocrlf = "input";
      };
      commit.gpgsign = true;
      pull.rebase = true;
      rebase.autoStash = true;
    };
  };

  # ssh = {
  #   enable = true;
  #   includes = [
  #     (lib.mkIf pkgs.stdenv.hostPlatform.isLinux
  #       "/home/${user}/.ssh/config_external"
  #     )
  #     (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin
  #       "/Users/${user}/.ssh/config_external"
  #     )
  #   ];
  #   matchBlocks = {
  #     "github.com" = {
  #       identitiesOnly = true;
  #       identityFile = [
  #         (lib.mkIf pkgs.stdenv.hostPlatform.isLinux
  #           "/home/${user}/.ssh/id_github"
  #         )
  #         (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin
  #           "/Users/${user}/.ssh/id_github"
  #         )
  #       ];
  #     };
  #   };
  # };
}
