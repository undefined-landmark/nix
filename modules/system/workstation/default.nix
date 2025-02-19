{lib, ...}: {
  imports = [
    ./x11.nix
    ./audio.nix
    ./nvidia.nix
    ./stylix.nix
    ./printing.nix
    ./samba-mount.nix
    ./virt-manager.nix
  ];

  options.custom-modules.desktop-environment = {
    enable = lib.mkEnableOption "Desktop environment";
  };
}
