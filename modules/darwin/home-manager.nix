{ config, pkgs, lib, home-manager, ... }:

let
  user = "nico";
  # Define the content of your file as a derivation
  # myEmacsLauncher = pkgs.writeScript "emacs-launcher.command" ''
  #   #!/bin/sh
  #   emacsclient -c -n &
  # '';
  # sharedFiles = import ../shared/files.nix { inherit config pkgs; };
  # additionalFiles = import ./files.nix { inherit user config pkgs; };
in
{
  imports = [
   ./dock
  ];

  # It me
  users.users.${user} = {
    name = "${user}";
    home = "/Users/${user}";
    isHidden = false;
    shell = pkgs.zsh;
  };

  homebrew = {
    # This is a module from nix-darwin
    # Homebrew is *installed* via the flake input nix-homebrew
    enable = true;
    casks = pkgs.callPackage ./casks.nix {};
    brews = pkgs.callPackage ./brews.nix {};
    # onActivation.cleanup = "uninstall";

    # These app IDs are from using the mas CLI app
    # mas = mac app store
    # https://github.com/mas-cli/mas
    #
    # $ nix shell nixpkgs#mas
    # $ mas search <app name>
    #
    # masApps = {
    #   "1password" = 1333542190;
    #   "hidden-bar" = 1452453066;
    #   "wireguard" = 1451685025;
    # };
  };

  # Enable home-manager
  home-manager = {
    useGlobalPkgs = true;
    users.${user} = { pkgs, config, lib, ... }:{
      home = {
        enableNixpkgsReleaseCheck = false;
        packages = pkgs.callPackage ./packages.nix {};
        # file = lib.mkMerge [
        #   # sharedFiles
        #   # additionalFiles
        #   # { "emacs-launcher.command".source = myEmacsLauncher; }
        # ];
        stateVersion = "23.11";
      };
      programs = {} // import ../shared/home-manager.nix { inherit config pkgs lib; };

      # Marked broken Oct 20, 2022 check later to remove this
      # https://github.com/nix-community/home-manager/issues/3344
      manual.manpages.enable = false;
    };
  };

  # Fully declarative dock using the latest from Nix Store
  local.dock.enable = true;
  local.dock.entries = [
    { path = "/Applications/Firefox\ Developer\ Edition.app/"; }
    { path = "/Applications/Google\ Chrome.app/"; }
    { path = "/System/Applications/Calendar.app/"; }
    { path = "/System/Applications/Messages.app/"; }
    { path = "/Applications/WhatsApp.app/"; }
    { path = "/Applications/Beeper.app/"; }
    { path = "/Applications/Slack.app/"; }
    { path = "/Applications/Transmit.app/"; }
    { path = "/Applications/iTerm.app/"; }
    { path = "/Applications/Visual\ Studio\ Code.app/"; }
    { path = "/Applications/Sequel\ Ace.app/"; }
    { path = "/System/Applications/Photos.app/"; }
    { path = "/System/Applications/Music.app/"; }
  ];

}
