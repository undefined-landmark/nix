{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.custom-home-modules.pkgs-cli-workstation;
in {
  imports = [../sops.nix];

  options.custom-home-modules.pkgs-cli-workstation = {
    enable = lib.mkEnableOption "cli applications for workstation (settings)";
  };

  config = lib.mkIf cfg.enable {
    custom-home-modules.sops.enable = true;

    sops.secrets.yubikey1_priv = {};
    sops.secrets.yubikey2_priv = {};
    sops.secrets.ssh_hosts = {};
    sops.secrets.ansible_portable_vault = {};

    home.packages = [
      pkgs.ansible
      pkgs.mediainfo
      pkgs.distrobox
      pkgs.R
    ];

    programs.ssh = {
      enable = true;
      matchBlocks."192.168.*" = {
        identityFile = [
          config.sops.secrets.yubikey1_priv.path
          config.sops.secrets.yubikey2_priv.path
        ];
      };
      includes = [config.sops.secrets.ssh_hosts.path];
      extraConfig = "CanonicalizeHostname = yes";
    };

    xdg.configFile.ansible-cfg = {
      target = "../.ansible.cfg";
      text = ''
        [defaults]
        vault_password_file = ${config.sops.secrets.ansible_portable_vault.path}
      '';
    };
  };
}