# /etc/nixos/
{ config, pkgs, lib, ... }:

{
  # SSH Configuration
  services.openssh = {
    enable = true;
    settings.X11Forwarding = true;
    settings.PermitRootLogin = "yes";
    settings.PasswordAuthentication = true;
    settings.PubkeyAuthentication = true;
  };
  users.users.helpwave.openssh.authorizedKeys.keys = [
    "xxx"
  ];


  # Remote-Desktop Configuration
  services.x2goserver.enable = true;
  services.flatpak.enable = true;
  services.gnome.gnome-remote-desktop.enable = true;
  services.xrdp = {
    enable = true;
    package = pkgs.xrdp;
    port = 3389;
    defaultWindowManager = "gnome-session";
    openFirewall = true;
  };
}