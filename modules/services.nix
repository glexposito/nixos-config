{ ... }:

{
  services.xserver.xkb.layout = "us";
  services.printing.enable = true;
  services.fstrim.enable = true;

  services.scx = {
    enable = true;
    scheduler = "scx_lavd";
  };

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
}
