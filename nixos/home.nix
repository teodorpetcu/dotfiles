{config, pkgs, ... }:

{
  home.stateVersion = "26.05";

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;

    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;

    size = 24;
  };

  services.gammastep = {
    enable = true;
    latitude = 44.0;
    longitude = 26.0;
    temperature = {
      day = 6500;
      night = 2700;
    };
  };

  services.swaync.enable = true;

  programs.element-desktop.enable = true;
}
