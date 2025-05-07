{
  system = "aarch64-linux";
  module = {...}: {
    environment.etc."systemd/network/eth0.network".text = ''
      [Match]
      Name=eth0

      [Network]
      Address=192.168.144.5/24
      Gateway=192.168.144.25
      DHCP=no
      # Disable default route from this gateway:
      DefaultRouteOnDevice=no
      # OR prevent adding routes entirely (can be redundant):
      [Route]
      Destination=192.168.144.0/24
      Gateway=192.168.144.25
    '';

    environment.etc."systemd/network/wlan0.network".text = ''
      [Match]
      Name=wlan0

      [Network]
      DHCP=yes

      [DHCPv4]
      UseRoutes=true
      RouteMetric=100
    '';
  };
}
