{ pkgs, lib, ultrastable, ... }:

{
  home.activation = {
    renoise_script = lib.hm.dag.entryAfter ["writeBoundary"] ''
      mkdir -p ~/.config/Renoise/V${pkgs.renoise.version}/Scripts/Tools
      cp -rn ${../../etc/renoise}/. ~/.config/Renoise/V${pkgs.renoise.version}/Scripts/Tools/
      chmod -R u+rw ~/.config/Renoise/V${pkgs.renoise.version}/Scripts/Tools/
    '';
  };

  home.file.".vst" = {
    source = builtins.toPath "${../../etc/plugins/vst}";
    recursive = true;
  };

  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    ultrastable.krita
    ultrastable.krita-plugin-gmic
    # aseprite
    kdePackages.kdenlive
    blender
    # material-maker

    # reaper
    # ardour
    (pkgs.renoise.overrideAttrs (oldAttrs: {
      # We add an additional step to `postFixup` phase, that changes desktop of renoise to execute
      # Renoise through steam-run, so each time you launch Renoise through Rofi it does this.
      #
      # Steam-run launches an application providing it with common libraries. We need this to make
      # plugins in `etc/plugins/` folder work. The other way is to use `nix-ld`, but it's a global
      # programm and kinda cringe for such purpose.
      postFixup = oldAttrs.postFixup + ''
        sed -i "s|^Exec=|Exec=env GTK_USE_PORTAL=0 ${pkgs.steam-run-free}/bin/steam-run |" $out/share/applications/renoise.desktop
      '';
    }))
    audacity

    # piano-rs
    # guitarix
    # surge
    surge-xt
    # bespokesynth-with-vst2
    # distrho-ports
    # zam-plugins
    # dexed
    # helm
    # zynaddsubfx
    # synthv1
    # ultrastable.lsp-plugins
    calf
    # geonkick
    # carla
    cardinal
    rubberband
    # airwindows
    (airwindows.overrideAttrs {
      # Remove airwindows plugins you don't want
      # Use this to find plugin's descriptions https://airwindowscheatsheet.aboni.dev/
      postInstall = ''
        cd $out/lib/vst/airwindows
        rm Acceleration*.so Channel*.so Console*.so ClipOnly.so curve.so \
           Discontapeity.so Discontinuity.so Distortion.so Ditherbox.so DitherMe*.so DoublePaul.so Dubly.so DubPlate.so Dyno.so \
           ElectroHat.so Elliptical.so Energy.so EveryConsole.so \
           FinalClip.so HermeTrim.so HighGlossDither.so HighImpact.so \
           Infrasonic.so Interstage.so IronOxideClassic.so \
           kPlate*.so LeftoMono.so Loud.so LR*.so \
           MidSide.so Mojo.so Monitoring*.so MSFlipTimer.so \
           NCSeventeen.so NotJustAnotherCD.so \
           Pafnuty*.so PeaksOnly.so PowerSag*.so Precious.so Pressure*.so PurestAir.so PurestConsole*.so PurestDrive.so PurestDualPan.so PurestFade.so PurestSaturation.so PurestWarm*.so Pyewacket.so \
           Recurve.so Remap.so RightoMono.so \
           SampleDelay.so Side*.so Slew*.so SoftClock*.so Spiral.so Srsly*.so StereoFX.so StudioTan.so SubsOnly.so Surge.so Sweet*.so \
           Tape*.so Thunder.so TPDF*.so Trianglizer.so Tube*.so \
           uLaw*.so Ultrasonic*.so VerbSixes.so VoiceTrick.so \
           Wolfbot.so Y*.so
        rm *Desk*.so *Dither*.so
      '';
    })
    # vcv-rack

    pavucontrol
    # easyeffects
    # qpwgraph

    gnome-system-monitor
    gpu-screen-recorder-gtk
    # librewolf
    qbittorrent
  ];

  # programs.rtorrent = {
  #   enable = true;
  # };

  programs.obs-studio = {
    enable = true;
  };

  programs.onlyoffice = {
    enable = true;
  };
}
