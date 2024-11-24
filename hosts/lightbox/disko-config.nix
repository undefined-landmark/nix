{
  disko.devices = {
    disk = {
      root = {
	device = "/dev/nvme0n1";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            root = {
              size = "100%";
              content = {
                type = "luks";
		name = "crypted";
		settings.allowDiscards = true;
		content = {
		  type = "filesystem";
		  format = "ext4";
		  mountpoint = "/";
		};
              };
            };
          };
        };
      };
    };
  };
}
