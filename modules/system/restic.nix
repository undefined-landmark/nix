{
  lib,
  config,
  inputs,
  ...
}: let
  cfg = config.custom-modules.restic;
in {
  imports = [
    inputs.my-secrets.private-vars
    ./sops.nix
  ];

  options.custom-modules.restic = {
    enable = lib.mkEnableOption "Restic backup service";
  };

  config = lib.mkIf cfg.enable {
    custom-modules.sops.enable = true;
    sops.secrets.restic-east_env = {};

    my-secrets.set-private.enable = true;

    services.restic.backups = {
      east = {
        createWrapper = true;
        inhibitsSleep = true;
        environmentFile = config.sops.secrets.restic-east_env.path;

        paths = config.my-secrets.private.vars.restic-east_paths;
        # timerConfig = {
        #   OnCalendar = "daily";
        #   Persistent = true;
        # };

        runCheck = true;
        checkOpts = ["--with-cache" "--read-data-subset=1G"];
      };
    };
  };
}