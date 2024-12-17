{ pkgs, ... }: {
  services.acpi.enable = true;

  boot.initrd.services.udev.rules = ''
    ACTION=="add", SUBSYSTEM=="leds", KERNEL=="platform::micmute" ATTR{trigger}="audio-micmute"
  '';

  boot.extraModulePackages = [ (pkgs.callPackage ../../packages/ideapad-laptop-tb.nix { }) ];
  boot.blacklistedKernelModules = [ "ideapad-laptop" ];

  services.thinkfan = {
    enable = false;
    fprintd = {
      enable = true;
      package = pkgs.fprintd-tod;
      tod = {
        driver = pkgs.libfprint-2-tod1-elan;
        enable = true;
      };
    };
  };
}
