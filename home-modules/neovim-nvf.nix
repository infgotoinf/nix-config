{ pkgs, lib, config, ... }: {
  programs.nvf = {
    enable = true;

    settings = {
      vim = {
        withRuby = false;

        theme = {
          enable = true;
          name = "gruvbox";
          style = "dark";
        };

        syntaxHighlighting = true;
	      autocomplete = {
	      blink-cmp = {
            enable = true;
	          setupOpts = {
	          };
	        };
	      };
	      undoFile.enable = true;
	      comments.comment-nvim.enable = true;
        /*
	      debugMode.enable = true;
	      debugger.nvim-dap = {
	        enable = true;
                ui.enable = true;
	      };
	      diagnostics = {
	        enable = true;
	        nvim-lint.enable = true;
	      };
        */ 

	      statusline.lualine.enable = true;
        # telescope.enable = true;
        # formatter.conform-nvim.enable = true;

        ui = {
	        colorful-menu-nvim.enable = true;
	      };

          
	      utility = {
          ccc.enable = true;
	        diffview-nvim.enable = true;
	        /*images.image-nvim = {
	          enable = true;
            setupOpts.backend = "kitty";
	        };*/
	        # oil-nvim.enable = true;
          # smart-splits.enable = true;
	        undotree.enable = true;
	        yanky-nvim = {
	          enable = true;
            setupOpts.ring.storage = "sqlite";
	        };

	        motion = {
            leap.enable = true;
	        };
	      };

	      visuals = {
          cellular-automaton.enable = true;
	        cinnamon-nvim.enable = true;
	        fidget-nvim.enable = true;
	      };


	      enableLuaLoader = true;

	      # lazy.plugins = {};
	      # globals = {};
	      # keymaps = [];
        # lsp.enable = true;
	      # treesitter.enable = true;

        
	      git = {
          enable = true;
	        git-conflict.enable = true;
	        gitsigns.enable = true;
	        hunk-nvim.enable = true;
	        neogit.enable = true;
	        vim-fugitive.enable = true;
	      };
              

          options = {
	        shiftwidth = 2;
	        tabstop = 2;
	        # updatetime = 50;
	      };


	      languages = {
	        # enableDAP = true;
	        # enableExtraDiagnostics = true;
	        # enableFormat = true;
	        enableTreesitter = true;
          # enableLSP = true;

          assembly.enable = true;
	        markdown.enable = true;
	        haskell.enable = true;
	        csharp.enable = true;
	        kotlin.enable = true;
	        python.enable = true;
	        clang.enable = true;
	        ocaml.enable = true;
	        bash.enable = true;
	        html.enable = true;
	        java.enable = true;
	        json.enable = true;
	        rust.enable = true;
	        yaml.enable = true;
	        css.enable = true;
	        lua.enable = true;
	        nim.enable = true;
	        nix.enable = true;
	        qml.enable = true;
	        zig.enable = true;
	        go.enable = true;
	        ts.enable = true;
	      };
      };
    };
    

    /*
    extraConfig = ''
      vim.g.mapleader = ' '
      vim.keymap = {
        set('v', 'J', ':m '>+1<CR>gv=gv')
	set('v', 'K', ':m '<-2<CR>gv=gv')

	set('n', 'n', 'nzzzv')
	set('n', 'N', 'Nzzzv')

        -- Paste without loosing the pasted word
	set('x', '<leader>p', '\"_dP')

	set('n', '<leader>y', '\"+y')
	set('v', '<leader>y', '\"+y')
	set('n', '<leader>Y', '\"+Y')

	set('n', '<leader>d', '\"_d')
	set('v', '<leader>d', '\"_d')

	set('i', '<C-c>', "<Esc>')

        set('n', '<leader>u', vim.cmd.UndotreeToggle)
        set('n', '<leader>Tab', vim.cmd.UndotreeFocus)
      }

      vim.opt = {
        tabstop = 4
	softtabstop = 4
	shiftwidth = 4
	expandtab = true

	smartindent = true
      }

      vim.api = {
        nvim_create_autocmd('FileType', {
          pattern = { 'lua', 'nix', 'make', 'html' },
          callback = function()
            vim.opt_local = {
              tabstop = 2
              softtabstop = 2
              shiftwidth = 2
            }
          end,
        })
	nvim_create_autocmd('FileType', {
          pattern = { 'make' }
	  callback = function()
	    vim.opt_local = {
              expandtabs = false
	      softtabstop = 0
	    }
	})
      }


      vim.opt = {
	undodir = os.getenv('HOME') .. '/.vim/undodir'

	hlsearch = false
	incsearch = true

	scrolloff = 4
	signcolumn = 'yes'
	colorcolumn = 100
	isfname:append('@-@')

	updatetime = 250
      }
    '';*/
  };
}
