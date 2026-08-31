{ pkgs, ... }:
{
  # I tried to create a package for GVST, tho I failed, cause GVST download link has some
  # sort of bot detection, so if you try to download it via curl you'll get just an HTML page
  # That sucks :(
  home.file.".vst" = {
    source = builtins.toPath "${./vst}";
    recursive = true;
  };

  home.packages = with pkgs; [
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
  ];
}
