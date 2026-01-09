{ config, lib, pkgs, modulesPath, ... }:

let
  toml = builtins.fromTOML(builtins.readFile /vault/settings.toml);
  username = toml.system.username;
  platform = toml.system.platform;
in {
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  # PLATFORM
  nixpkgs.hostPlatform = lib.mkDefault platform;

  # HARDWARE
  hardware.enableRedistributableFirmware = true;
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.graphics = {
    enable = true;
    enable32Bit = true; 
    extraPackages = with pkgs; [
        intel-media-driver   
    ];
  };

  # HARDWARE SERVICE
  services.thermald.enable = true;
  services.fstrim.enable = true; 

  # RAM OPTIMISATION
  zramSwap.enable = true;
  zramSwap.memoryPercent = 50;
  zramSwap.algorithm = "zstd";

  # BOOT
  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ "i915" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.tmp.useTmpfs = true;
  boot.tmp.tmpfsSize = "20G";
  boot.nixStoreMountOpts = [ "ro" "noatime" "nodev" "nosuid" ];
  
  boot.loader.timeout = 0;
  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false;
  boot.kernelParams = [
    "quiet"
    "splash"
    "rd.systemd.show_status=false"
    "udev.log_level=3"
    "nobgrt"
    "fbcon=nodefer"
  ];

  boot.plymouth = {
    enable = true;
    theme = "colorful_loop";
    themePackages = [
      (pkgs.adi1090x-plymouth-themes.override {
        selected_themes = [ "colorful_loop" ];
      })
    ];
  };

  # KERNEL
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # FILE SYSTEM
  fileSystems."/" = {
    device = "tmpfs";
    fsType = "tmpfs";
    options = [ "mode=755" "size=8G" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/BOOT";
    fsType = "vfat";
    options = [ "fmask=0022" "dmask=0022" ];
  };
  
  fileSystems."/kanso" = {
    device = "/dev/disk/by-label/vault";
    fsType = "btrfs";
    options = [ "subvol=@kanso" "compress=zstd:1" "noatime" ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-label/vault";
    fsType = "btrfs";
    options = [ "subvol=@nix" "compress=zstd:1" "noatime" ];
    neededForBoot = true;
  };
  
  fileSystems."/vault" = {
    device = "/dev/disk/by-label/vault";
    fsType = "btrfs";
    options = [ "subvol=@vault" "compress=zstd:1" "noatime" ];
    neededForBoot = true;
  };
  
  fileSystems."/persist" = {
    device = "/dev/disk/by-label/vault";
    fsType = "btrfs";
    options = [ "subvol=@persist" "compress=zstd:1" "noatime" ];
    neededForBoot = true;
  };

  # PERSISTENCE
  environment.persistence."/persist" = {
    hideMounts = true;
    
    directories = [
      "/var/lib/iwd"
      "/var/lib/nixos"
      "/var/log"
    ];

    files = [
      "/etc/machine-id"
    ];

    users.${username} = {
      directories = [
        "Desktop"
      ];
    };
  };
}
