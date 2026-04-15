{ 
  config, 
  pkgs, 
  lib, 
  ... 
}:

{
  home.packages = with pkgs; [
    # General
    alacritty # terminal emulator
    neovim # A text editor based on Vim
    # obsidian # A note-taking and knowledge management application
    # spotify # A digital music service that gives you access to millions of songs
    # vlc # A video player
    # Comms
    # slack # A collaboration hub
    # zoom-us # A video conferencing tool
    # discord # A VoIP and instant messaging social platform
    # Networking
    tcpdump # A powerful command-line packet analyzer
    wireshark # packet analyzer
    iperf3 # A tool for active measurements of the maximum achievable bandwidth
    # Compression
    xz # xz compression
    unzip # unzip
    p7zip # 7z compression
    zip # zip/unzip
    # Programming
    python3 # Python 3, latest stable version
    # Utilities
    feh # image viewer
    jq # JSON processor
    fastfetch # system information tool
    ripgrep # recursively searches directories for a regex pattern
    yq-go # yaml processor https://github.com/mikefarah/yq
    eza # A modern replacement for 'ls'
    fzf # A command-line fuzzy finder
    mtr # A network diagnostic tool
    tree # A recursive directory listing command
    dnsutils  # `dig` + `nslookup`
    ldns # replacement of `dig`, it provide the command `drill`
    aria2 # A lightweight multi-protocol & multi-source command-line download utility
    socat # replacement of openbsd-netcat
    nmap # A utility for network discovery and security auditing
    ipcalc  # it is a calculator for the IPv4/v6 addresses
    gnupg # GNU Privacy Guard
    glow # markdown previewer in terminal
    btop  # replacement of htop/nmon
    iotop # io monitoring
    iftop # network monitoring
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files
    sysstat # system performance monitoring
    lm_sensors # for `sensors` command
    ethtool # for `ethtool` command
    pciutils # lspci
    usbutils # lsusb
    nemo # A file manager for the Cinnamon desktop environment
    ranger # A console file manager with VI key bindings
    nnn # terminal file manager
    cdrtools # for creating ISO images (mkisofs)
    podman-tui # tui for podman
  ];
}