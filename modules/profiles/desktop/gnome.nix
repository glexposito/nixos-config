{ lib, config, ... }:
let
  hm = config.homeManager;
in
{
  options.nixos.gnome = lib.mkOption {
    type = lib.types.deferredModule;
    description = "GNOME desktop.";
  };
  options.homeManager.gnome = lib.mkOption {
    type = lib.types.deferredModule;
    description = "Home side of GNOME: extensions and keybinds.";
  };

  config.nixos.gnome =
    { pkgs, ... }:
    {
      home-manager.sharedModules = [ hm.gnome ];

      services.desktopManager.gnome.enable = true;

      environment.systemPackages = with pkgs; [
        gnome-tweaks
        dconf-editor
      ];
    };

  config.homeManager.gnome =
    { pkgs, ... }:
    {
      programs.gnome-shell = {
        enable = true;
        extensions = [
          { package = pkgs.gnomeExtensions.appindicator; }
          { package = pkgs.gnomeExtensions.logo-menu; }
        ];
      };

      dconf.settings."org/gnome/shell/extensions/Logo-menu" = {
        menu-button-icon-image = 23;
      };

      xdg.configFile."xdg-terminals.list".text = "kitty.desktop\n";

      dconf.settings."org/gnome/desktop/wm/keybindings" = {
        close = [ "<Super>q" ];
      };

      dconf.settings."org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/"
        ];
      };

      dconf.settings."org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        name = "Kitty";
        command = "kitty";
        binding = "<Super>Return";
      };

      dconf.settings."org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
        name = "Zed";
        command = "zeditor";
        binding = "<Super>z";
      };

      dconf.settings."org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
        name = "Browser";
        command = "firefox";
        binding = "<Super>b";
      };

      dconf.settings."org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
        name = "Files";
        command = "nautilus";
        binding = "<Super>e";
      };

      dconf.settings."org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4" = {
        name = "Yazi";
        command = "kitty --start-as maximized --override font_size=18 -- yazi";
        binding = "<Super>y";
      };
    };
}
