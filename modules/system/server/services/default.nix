{...}: {
  imports = [
    ./qbittorrent
    ./arr.nix
    ./samba.nix
    ./traefik.nix
    ./jellyfin.nix
    ./traefikDynamic.nix
  ];
}
