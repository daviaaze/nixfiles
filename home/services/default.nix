_: {
  services = {
    mpris-proxy.enable = true;

    # Add other service configurations here
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
    };
  };
}
