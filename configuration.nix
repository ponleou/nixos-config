# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
#      "${builtins.fetchGit { url = "https://github.com/NixOS/nixos-hardware.git"; }}/apple/t2"
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.loader.efi.canTouchEfiVariables = true;

  # Apple Wifi and Bluetooth Firmware declarative setup
  hardware.firmware = [
    (pkgs.stdenvNoCC.mkDerivation (final: {
      name = "brcm-firmware";
      src = ./firmware/brcm;
      installPhase = ''
        mkdir -p $out/lib/firmware/brcm
        cp ${final.src}/* "$out/lib/firmware/brcm"
      '';
    }))
  ];

  # */ remove the incorrect comment color syntax

  networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  
  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
  
  # Use both networkmanager and wpa
  # networking.networkmanager.unmanaged = [
  #   "*" "except:type:wwan" "except:type:gsm"
  # ];

  # Set your time zone.
  time.timeZone = "Australia/Sydney";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_AU.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_AU.UTF-8";
    LC_IDENTIFICATION = "en_AU.UTF-8";
    LC_MEASUREMENT = "en_AU.UTF-8";
    LC_MONETARY = "en_AU.UTF-8";
    LC_NAME = "en_AU.UTF-8";
    LC_NUMERIC = "en_AU.UTF-8";
    LC_PAPER = "en_AU.UTF-8";
    LC_TELEPHONE = "en_AU.UTF-8";
    LC_TIME = "en_AU.UTF-8";
  };  

  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Configure keymap in X11
  services.xserver.xkb.layout = "au";
  services.xserver.xkb.options = "";

  # Define a user account. Don't forget to set a password with 'passwd'
  users.users.ponleou = {
    isNormalUser = true;
    description = "Keo Ponleou Sok";
    extraGroups = ["networkmanager" "wheel" "video" "render" "input"];
    packages = with pkgs; [];
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;
  
  # Enable nix flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
 
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    kitty
    firefox
    git
    clinfo
    telegram-desktop
    discord
    whatsapp-for-linux
    neofetch
    power-profiles-daemon
    libnotify
    hyprshot
    swww
    networkmanagerapplet
    bash
    xdg-dbus-proxy
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
    xdg-utils
    bun
    gnome-shell
    nautilus
    xfce.thunar
    hyprpicker
    gnomeExtensions.launcher
    libdbusmenu-gtk3
    ags
    gnome-bluetooth
    pavucontrol
    wl-clipboard
    wayshot
    swappy
    brightnessctl
    xarchiver
    zip
    lm_sensors
    dart-sass
    sass
    fd
    wpgtk
    nwg-look
    qdirstat
    tela-icon-theme
    matugen
    gnome-tweaks 
    zlib
    gccgo14
    gcc
    clang
    nvc
    cmake
    upower
    gvfs    
    plymouth

    (writeScriptBin "nixos-switch" (builtins.readFile ./nixos-switch.sh))
    (writeScriptBin "nixos-edit" (builtins.readFile ./nixos-edit.sh))
    (writeScriptBin "nixos-edit flake" (builtins.readFile ./nixos-flake-edit.sh))

    (python3.withPackages(ps: with ps; [ 
      numpy
      wheel 
      pip
      meson
      ninja
    ]))
 ];

 
  # dbusMenuGtk3 for Aylur's ags dotfiles
  nixpkgs.overlays = [
    (final: prev:
    {
      ags = prev.ags.overrideAttrs (old: {
        buildInputs = old.buildInputs ++ [ pkgs.libdbusmenu-gtk3 ];
      });
    })
  ];
  
  # fonts
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    roboto
    roboto-slab
    roboto-serif
  ];

  # Upower to show battery in AGS
  services.upower.enable = true;

  # for wpgtk, wallpaper colorscheme
  programs.dconf.enable = true;

  boot.plymouth.enable = true;
 
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  #  system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = lib.mkForce "24.11"; # Did you read the comment?

  # Personal

  #boot.kernelPackages = pkgs.linuxPackages_latest;

  # Enable hyprland as stated in hyprland's manual
  programs.hyprland.enable = true;
  programs.hyprland.xwayland.enable = true;

  # PPD
  services.power-profiles-daemon.enable = true;

  # copied from github to try material you dotfiles
  # programs.bun.enable = true;
  # services.udiskie.enable = true;
  # services.cliphist.enable = true;
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];

  # Oh my zsh (not working)
  programs.zsh.ohMyZsh = {
    enable = true;
    plugins = ["git" "python" "man"];
    theme = "agnoster";
  };
  
  # Bluetooth
  hardware.bluetooth.enable = true;

  # Auto upgrades
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;

  # Hardware acceleration
  hardware.graphics.enable = true;
  hardware.graphics.extraPackages = with pkgs; [
    intel-compute-runtime
    intel-media-driver
  ];

  # Enable swap
  swapDevices = [{
    device = "/swapfile";
    size = 16 * 1024; # 16gb
  }];
  
  # Enable zram swap
  zramSwap.enable = true;

  # Environment variables
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
}


