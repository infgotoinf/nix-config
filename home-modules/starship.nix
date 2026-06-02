{
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      # add_newline = true;
      command_timeout = 500;
      scan_timeout = 50;
      format = let
        color = "red";
        host_user_path = "$hostname[@](${color})$username[:](${color})$directory";
        git_stuff = "$git_branch$git_commit$git_status";
      in ''
        $status$cmd_duration$shlvl[\[](${color})${host_user_path}[\]](${color})$jobs${git_stuff}$all
        $character'';

      status = {
        format   = "[\\($status\\)]($style) ";
        style    = "red";
        disabled = false;
      };
      cmd_duration = {
        format   = "[$duration]($style) ";
        style    = "yellow";
        min_time = 5000;
      };
      shlvl = {
        format    = "[lvl$shlvl]($style) ";
        style     = "blue";
        threshold = 2;
        disabled  = false;
      };
      hostname = {
        format   = "[$hostname]($style)";
        style    = "yellow";
        ssh_only = false;
      };
      username = {
        format      = "[$user]($style)";
        style_user  = "purple";
        style_root  = "red";
        show_always = true;
      };
      directory = {
        format                 = "[$path]($style)[$read_only]($read_only_style)";
        repo_root_format       = "[$before_root_path]($before_repo_root_style)[$repo_root$path]($repo_root_style)[$read_only]($read_only_style)";
        read_only              = " r";
        style                  = "cyan";
        repo_root_style        = "blue";
        before_repo_root_style = "cyan";
        read_only_style        = "red";
        truncate_to_repo       = true;
        truncation_length      = 4;
      };
      jobs = {
        format           = " [j$number]($style)";
        style            = "magenta";
        number_threshold = 1;
      };
      git_branch = {
        format            = " [\\($branch(:remote_branch)]($style)";
        style             = "yellow";
        truncation_symbol = "..";
        only_attached     = true;
      };
      git_commit = {
        format = "[\\($hash$tag]($style)";
        style  = "yellow";
      };
      git_state.disabled = true;
      git_status = {
        format = "[( $all_status)\\)]($style)";
        style  = "yellow";

        # I've been using it for too long
        # https://github.com/agkozak/agkozak-zsh-prompt/blob/master/README.md#git-branch-and-status
        conflicted  = "=";
        diverged    = "⇡\${ahead_count}⇣\${behind_count}";
        ahead       = "⇡\${count}";
        behind      = "⇣\${count}";
        staged      = "+";
        modified    = "!";
        untracked	  = "?";
        renamed     = ">";
        deleted     = "x";
        stashed     = "\\$";
      };
      character = {
        success_symbol            = "%";
        error_symbol              = "%";
        vimcmd_symbol             = "%";
        vimcmd_replace_one_symbol = "%";
        vimcmd_replace_symbol     = "%";
        vimcmd_visual_symbol      = "%";
      };

      python = {
        format = " [\\($virtualenv\\)]($style)";
        style  = "green";
      };
      nix_shell = {
        format     = " [nix]($style)";
        style      = "blue";
        impure_msg = "";
        pure_msg   = "";
      };
      container = {
        format = " [$name]($style)";
        style  = "magenta";
      };
      fill.disabled = true;
      c.disabled = true;
      cmake.disabled = true;
      lua.disabled = true;
      meson.disabled = true;
      perl.disabled = true;
      ruby.disabled = true;
      rust.disabled = true;
      zig.disabled = true;
      line_break.disabled = true;
      aws.disabled = true;
      battery.disabled = true;
      buf.disabled = true;
      bun.disabled = true;
      cobol.disabled = true;
      conda.disabled = true;
      crystal.disabled = true;
      daml.disabled = true;
      dart.disabled = true;
      deno.disabled = true;
      docker_context.disabled = true;
      dotnet.disabled = true;
      elixir.disabled = true;
      elm.disabled = true;
      env_var.disabled = true;
      erlang.disabled = true;
      fennel.disabled = true;
      fortran.disabled = true;
      fossil_branch.disabled = true;
      gcloud.disabled = true;
      gleam.disabled = true;
      golang.disabled = true;
      guix_shell.disabled = true;
      gradle.disabled = true;
      haskell.disabled = true;
      haxe.disabled = true;
      helm.disabled = true;
      java.disabled = true;
      julia.disabled = true;
      kotlin.disabled = true;
      maven.disabled = true;
      memory_usage.disabled = true;
      mojo.disabled = true;
      nats.disabled = true;
      netns.disabled = true;
      nim.disabled = true;
      nodejs.disabled = true;
      ocaml.disabled = true;
      odin.disabled = true;
      opa.disabled = true;
      openstack.disabled = true;
      php.disabled = true;
      pixi.disabled = true;
      pulumi.disabled = true;
      purescript.disabled = true;
      quarto.disabled = true;
      rlang.disabled = true;
      raku.disabled = true;
      red.disabled = true;
      scala.disabled = true;
      singularity.disabled = true;
      solidity.disabled = true;
      spack.disabled = true;
      swift.disabled = true;
      terraform.disabled = true;
      typst.disabled = true;
      vagrant.disabled = true;
      vlang.disabled = true;
      vcs.disabled = true;
      vcsh.disabled = true;
      xmake.disabled = true;
      claude_model.disabled = true;
      claude_context.disabled = true;
      claude_cost.disabled = true;
    };
  };
}
