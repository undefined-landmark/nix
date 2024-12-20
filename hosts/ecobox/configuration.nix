{inputs, ...}: {
  imports = [
    inputs.home-manager.nixosModules.default
    ./hardware-configuration.nix
    ../../system/general.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  zramSwap.enable = true;

  networking.hostName = "ecobox"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users = {
      "bas" = import ./home.nix;
    };
  };
}
