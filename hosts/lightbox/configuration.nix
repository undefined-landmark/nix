{inputs, ...}: {
  imports = [
    inputs.home-manager.nixosModules.default
    inputs.disko.nixosModules.disko
    ./hardware-configuration.nix
    ./disko-config.nix
    ../../modules/system
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  zramSwap.enable = true;

  networking.hostName = "lightbox"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  
  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users = {
      "bas" = import ./home.nix;
    };
  };

  services.tlp.enable = true;

  custom-modules = {
      enable = true;
      x11.enable = true;
      sops.enable = true;
      audio.enable = true;
      stylix.enable = true;
      general.enable = true;
      wg-quick.enable = true;
      samba-mount.enable = true;
  };
}
