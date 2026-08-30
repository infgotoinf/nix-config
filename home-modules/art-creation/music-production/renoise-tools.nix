{ pkgs, lib, ... }:
let
  tools = [
    # Shows note & FX info
    (pkgs.fetchurl {
      url = "https://www.renoise.com/uploads/tools/mg-note-fx-inspector/mg.notefx.inspector_v1.2_api6.xrnx";
      hash = "sha256-ihODoD2adTkbBFSiIfu8osKJVQ/J2H97JzKUJkIaAVo=";
    })

    # Convert note numbers
    (pkgs.fetchurl {
      url = "https://www.renoise.com/uploads/tools/convert-instrument-number/ledger.scripts.ConvertInstrumentNumber_v1.12_api6.xrnx";
      hash = "sha256-uJ3WmguUltLuPu2dJbyz9kbaXnxT/1dsrmgEztdkND0=";
    })

    # Get plugin params for automation
    (pkgs.fetchurl {
      url = "https://www.renoise.com/uploads/tools/getpluginparams/com.vvoois.Getdeviceparams_v1.31_api4.xrnx";
      hash = "sha256-uSdAgtvCcT7X2KyGE+j5t03rKKn5XZvENDcVLXD2gus=";
    })

    # Change values via shortcuts
    (pkgs.fetchurl {
      url = "https://www.renoise.com/uploads/tools/value-stepper/com.unlessgames.value_stepper_v0.6_api6.2.xrnx";
      hash = "sha256-uf7Z9D80YrRoWtH/kl53M+eHI2GzF45H3W0zMKqwbTI=";
    })

    # Command palette
    (pkgs.fetchurl {
      url = "https://www.renoise.com/uploads/tools/command-palette/com.unlessgames.command_palette_v2.7_api6.2.xrnx";
      hash = "sha256-w5vNcY110HMVjnLYDabOBNO4/HK5UTY41L+qtli++MQ=";
    })

    # Start recording on note input
    (pkgs.fetchurl {
      url = "https://www.renoise.com/uploads/tools/start-recording-on-note-input/com.ulneiz.StartRecordingOnNoteInput_v1.0_api6.xrnx";
      hash = "sha256-8c9r4CmUc9M3kd97j9+Y0QJUcDgftnSliL7vQDh+UN4=";
    })

    # Nudge notes
    (pkgs.fetchurl {
      url = "https://www.renoise.com/uploads/tools/hypernudge/com.halebop.HyperNudge_v1.0_api6.2.xrnx";
      hash = "sha256-1EXxV4/n3nGG8hdblNHJ62eTLmMSH644ya8mGcbPd5Q=";
    })

    # Time tracker for projects
    (pkgs.fetchurl {
      url = "https://www.renoise.com/uploads/tools/session-time-tracker/com.dlt.SessionTimeTracker_v1.4_api6.xrnx";
      hash = "sha256-LCw001bgtAEdz0juF3Xvm8Pc1UFcqQ7CJxjGX9O2kfk=";
    })

    # Sync modulation DSPs
    (pkgs.fetchurl {
      url = "https://www.renoise.com/uploads/tools/synchronize-modulation-dsps/AS.Beatslaughter.SyncModDSPs_v1.4_api5.xrnx";
      hash = "sha256-9ZZ5FG/07uDS8qOF84pNfechStBLLyYKgO9Xm4fS698=";
    })

    # Shows automated sliders
    (pkgs.fetchurl {
      url = "https://www.renoise.com/uploads/tools/show-automated-sliders-in-the-mixer/AS.Beatslaughter.MixerShowAutomatedSliders_v1.4_api5.xrnx";
      hash = "sha256-hoSR/rd6Ei/yY9v0WOrhY6/OIzXd64/6MbQmXcrjITc=";
    })
  ];

  # renoise_tools_dir_full = "~/${renoise_tools_dir}";

  # cp_commands = builtins.concatStringsSep "\n" (map (tool: "cp ${tool} ${renoise_tools_dir_full}") tools);

  # in lib.hm.dag.entryAfter ["writeBoundary"] ''
  #   mkdir -p ~/.config/Renoise/V${pkgs.renoise.version}/Scripts/Tools
  #   cp -rn ${../../etc/renoise}/. ~/.config/Renoise/V${pkgs.renoise.version}/Scripts/Tools/
  #   chmod -R u+rw ~/.config/Renoise/V${pkgs.renoise.version}/Scripts/Tools/
  # '';
  # in lib.hm.dag.entryAfter ["writeBoundary"] ''
  #   mkdir -p ${renoise_tools_dir_full}
  #   ${cp_commands}
  #   chmod -R u+rw ${renoise_tools_dir_full}
  #   cd ${renoise_tools_dir_full}
  #   ${pkgs.file-rename}/bin/rename 's/_v.*\.xrnx$/.xrnx.zip/' *.xrnx
  #   ${pkgs.dtrx}/bin/dtrx -o *.zip
  #   rm *.zip
  # '';

  cp_commands = builtins.concatStringsSep "\n" (map (tool: "cp ${tool} $out") tools);

  renoise_tools = pkgs.stdenvNoCC.mkDerivation {
    pname = "renoise-tools";
    version = pkgs.renoise.version;

    dontUnpack = true;
    dontBuild = true;

    installPhase = ''
      mkdir -p $out
      ${cp_commands}
      cd $out
      ${pkgs.file-rename}/bin/rename 's/^.+-//' *.xrnx
      ${pkgs.file-rename}/bin/rename 's/_v.*\.xrnx$/.xrnx.zip/' *.xrnx
      ${pkgs.dtrx}/bin/dtrx -o *.zip
      rm *.zip
    '';
  };
in {
  # home.file."~/.config/Renoise/V${pkgs.renoise.version}/Scripts/Tools" = {
  #   source = renoise_tools;
  #   force = true;
  # };

  home.activation.renoise_tools = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p ~/.config/Renoise/V${pkgs.renoise.version}/Scripts/Tools
    cp -r ${renoise_tools}/* ~/.config/Renoise/V${pkgs.renoise.version}/Scripts/Tools/
    chmod -R u+rw ~/.config/Renoise/V${pkgs.renoise.version}/Scripts/Tools/
  '';
}
