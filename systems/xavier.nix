{
  system = "aarch64-linux";
  module = {...}: {
  systemd.services.NetworkManager.enable = true;

  environment.etc."NetworkManager/system-connections/eth0.nmconnection" = {
    text = ''
      [connection]
      id=eth0
      type=ethernet
      interface-name=eth0
      autoconnect=true

      [ipv4]
      method=manual
      address1=192.168.144.5/24
      never-default=true
      dns-priority=-1

      [ipv4-route1]
      dest=192.168.144.0/24
      next-hop=192.168.144.25
      on-link=true

      [ipv6]
      method=ignore
    '';
    mode = "0600";
  };

    /*
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
  */
  };
}
