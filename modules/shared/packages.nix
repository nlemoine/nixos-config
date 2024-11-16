{ pkgs, ... }:

with pkgs; [
  # General packages for development and system management
  # bash-completion
  # bat
  openssh
  sqlite
  wget
  zip
  # # vim
  git
  jq
  wget
  curl
  rsync
  tree
  zsh
  go
  brotli
  subversion
  direnv
  # mosh
  unzip
  ripgrep
  zoxide
  fzf
  atuin
  # du-dust
  # eza
  starship
  gh

  # # Cloud-related tools and SDKs
  # docker
  # docker-compose

  ffmpeg
  jpegoptim
  pngquant

  # # Node.js development tools
  nodePackages.npm # globally install npm
  nodePackages.prettier
  # nodePackages.prettier
  nodejs
  yarn-berry
  mailpit
  act
  mkcert
  redis
  symfony-cli
  # wp-cli
  # Python packages
  python3
  # python39Packages.virtualenv # globally install virtualenv

  php82Packages.composer
  php82Extensions.imagick
  php82Extensions.igbinary
  php82Extensions.redis
  php82Extensions.spx
  php82Extensions.pcov
  (php82.buildEnv {
    extensions = ({ enabled, all }: enabled ++ (with all; [
      redis
      imagick
      igbinary
      pcov
      spx
    ]));
    extraConfig = ''
      memory_limit = 256M

      spx.http_enabled=1
      spx.http_key="dev"
      spx.http_ip_whitelist="127.0.0.1,::1"
    '';
  })
]
