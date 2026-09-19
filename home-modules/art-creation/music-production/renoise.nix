{ pkgs, lib, ... }:
{
  home.file.".config/Renoise/V${pkgs.renoise.version}/Themes/Gruvbox_Dark_Hard.xrnc" = {
    source = "${./renoise-settings}/Gruvbox_Dark_Hard.xrnc";
  };

  home.activation.renoise_setup = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p ~/.config/Renoise/V${pkgs.renoise.version}
    chmod -R u+rw ~/.config/Renoise/V${pkgs.renoise.version}
    cp ${./renoise-settings}/Config.xml ~/.config/Renoise/V${pkgs.renoise.version}/
    cp ${./renoise-settings}/KeyBindings.xml ~/.config/Renoise/V${pkgs.renoise.version}/
    cp ${./renoise-settings}/TemplateSong.xrns ~/.config/Renoise/V${pkgs.renoise.version}/
  '';

  home.packages = with pkgs; [
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
  ];
}
