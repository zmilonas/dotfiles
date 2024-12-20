-- NeoVim Config for Zachary, uses lazy.nvim, inspired by kickstart, crafted by hand
-- @zmilonas
-- keywords: lsp, telescope, neotree, lazy, nvim
-- support for: TypeScript, Lua, Python, Groovy, Jenkinsfile, PHP, Dockerfile

--@type table
vim = vim

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
vim.opt.directory = vim.fn.expand("$HOME/.local/share/nvim/swap")

vim.g.mapleader = " "

require("lazy").setup({

  -- git related
  "tpope/vim-fugitive",
  "tpope/vim-rhubarb",

  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        current_line_blame = true,
        current_line_blame_opts = {
          delay = 200,
        },
      })
    end,
  },

  -- Detect tabstop and shiftwidth automatically
  "tpope/vim-sleuth",

  {
    -- LSP Configuration & Plugins
    "neovim/nvim-lspconfig",
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { "williamboman/mason.nvim", config = true },
      "williamboman/mason-lspconfig.nvim",

      -- Useful status updates for LSP
      { "j-hui/fidget.nvim", opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      "folke/neodev.nvim",
    },
  },

  {
    -- Theme inspired by Atom
    "navarasu/onedark.nvim",
    priority = 1000,
    lazy = false,
    config = function()
      require("onedark").setup({
        style = "dark",
      })
      require("onedark").load()
    end,
  },

  { "folke/which-key.nvim", opts = {} },

  { "folke/neoconf.nvim", cmd = "Neoconf" },

  {
    "rcarriga/nvim-notify",
    config = function()
      require("notify").setup({
        stages = "fade",
        timeout = 5000,
        render = "default",
        max_width = 80,
        top_down = false,
      })

      vim.notify = require("notify")
    end,
    keys = {
      -- Optional: Clear notifications with Esc in normal mode
      {
        "<Esc>",
        function()
          require("notify").dismiss()
        end,
        mode = "n",
      },
    },
  },

  {
    "ahmedkhalf/project.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "rmagatti/auto-session",
      "rcarriga/nvim-notify",
      "nvim-neo-tree/neo-tree.nvim",
    },
    config = function()
      require("project_nvim").setup({
        detection_methods = { "pattern", "lsp" },
        -- Patterns used to detect project root
        patterns = {
          ".git", -- Git repository
          "composer.json", -- PHP/Laravel projects
          "package.json", -- Node.js projects
          "Makefile", -- Make projects
          "requirements.txt", -- Python projects
          "pyproject.toml", -- Python projects
          "setup.py", -- Python projects
        },
        show_hidden = false,
        ignore_lsp = {},
        exclude_dirs = { "~/.cargo/*", "node_modules/*" },
        manual_mode = false,
      })

      require("telescope").load_extension("projects")

      vim.keymap.set("n", "<leader>P", function()
        local actions = require("telescope.actions")
        local action_state = require("telescope.actions.state")

        require("telescope").extensions.projects.projects({
          attach_mappings = function(prompt_bufnr, map)
            map("i", "<CR>", function()
              local selection = action_state.get_selected_entry()
              actions.close(prompt_bufnr)

              if selection and selection.value then
                vim.cmd("SessionSave")
                vim.notify("Switching to " .. selection.value, vim.log.levels.INFO)
                vim.cmd("cd " .. vim.fn.fnameescape(selection.value))
                vim.cmd("silent! %bdelete")
                vim.cmd("SessionRestore")
                vim.defer_fn(function()
                  require("neo-tree.command").execute({ action = "show", dir = vim.loop.cwd() })
                end, 200)
              end
            end)
            return true
          end,
        })
      end, { desc = "Switch Project" })
    end,
  },

  {
    "nvim-tree/nvim-web-devicons",
    lazy = false,
    config = function()
      require("nvim-web-devicons").setup({
        strict = true,
      })
    end,
  },

  {
    "akinsho/bufferline.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    version = "*",
    config = function()
      require("bufferline").setup({
        options = {
          close_icon = "",
          buffer_close_icon = "",
          separator_style = "slant",
          numbers = "ordinal",
          show_buffer_close_icons = true,
          show_close_icon = true,
          always_show_bufferline = true,
          diagnostics = "nvim_lsp",
        },
      })
      vim.keymap.set("n", "<leader>x", ":bdelete<CR>", { desc = "Close buffer" })
    end,
  },

  {
    "rmagatti/auto-session",
    config = function()
      require("auto-session").setup({
        log_level = "error",
        auto_session_enabled = true,
        auto_save_enabled = true,
        auto_restore_enabled = true,
        auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions/",
        auto_session_suppress_dirs = { "~/", "~/Downloads", "/", "~/dev" },
        pre_save_cmds = {
          function()
            require("neo-tree.command").execute({ action = "close" })
          end,
        },
        post_restore_cmds = {
          function()
            require("neo-tree.command").execute({ action = "show", dir = vim.loop.cwd() })
          end,
        },
      })
    end,
  },

  {
    -- Add indentation guides even on blank lines
    "lukas-reineke/indent-blankline.nvim",
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = "ibl",
    opts = {},
  },

  -- Fuzzy Finder (files, lsp, etc)
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- Fuzzy Finder Algorithm which requires local dependencies to be built.
      -- Only load if `make` is available. Make sure you have the system
      -- requirements installed.
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
    },
  },

  {
    -- Highlight, edit, and navigate code
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "php",
        "html",
        "javascript",
        "python",
      },
      highlight = {
        enable = true,
      },
    },
  },

  -- Laravel Blade templates
  {
    "jwalton512/vim-blade",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    ft = "blade",
  },

  "folke/neodev.nvim",

  "MunifTanjim/nui.nvim",

  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>l",
        function()
          require("conform").format({ async = false, lsp_fallback = true })
        end,
        mode = "",
        desc = "Format file",
      },
    },
    opts = {
      formatters = {
        stylua = {
          -- Stylua specific configuration for smaller indents
          prepend_args = {
            "--indent-type",
            "Spaces",
            "--indent-width",
            "2",
            "--column-width",
            "120",
          },
        },
      },
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "black" },
        javascript = { { "prettierd", "prettier" } },
      },
    },
  },

  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",

  {
    -- Autocompletion
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ["<Down>"] = cmp.mapping.select_next_item(),
          ["<Up>"] = cmp.mapping.select_prev_item(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp", max_item_count = 20 },
          { name = "luasnip", max_item_count = 5 },
          { name = "buffer", max_item_count = 5, keyword_length = 5 },
          { name = "path" },
        }),
        sorting = {
          comparators = {
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.kind,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        },
      })
    end,
  },

  {
    "github/copilot.vim",
    config = function()
      vim.g.copilot_no_tab_map = true
      vim.keymap.set("i", "<C-l>", 'copilot#Accept("<CR>")', {
        expr = true,
        replace_keycodes = false,
      })

      -- Optional: disable copilot for certain filetypes
      vim.g.copilot_filetypes = {
        ["*"] = true,
        ["markdown"] = true,
        ["help"] = false,
      }
    end,
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },

    keys = {
      {
        "<leader>e",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
        end,
        desc = "Explorer NeoTree (cwd)",
      },
      {
        "<leader>g",
        function()
          require("neo-tree.command").execute({ source = "git_status", toggle = true })
        end,
        desc = "Git explorer",
      },
      {
        "<leader>b",
        function()
          require("neo-tree.command").execute({ source = "buffers", toggle = true })
        end,
        desc = "Buffer explorer",
      },
    },

    deactivate = function()
      vim.cmd([[Neotree close]])
    end,
    init = function()
      if vim.fn.argc(-1) == 1 then
        local stat = vim.loop.fs_stat(vim.fn.argv(0))
        if stat and stat.type == "directory" then
          require("neo-tree")
        end
      end
    end,

    opts = {
      close_if_last_window = false,
      popup_border_style = "rounded",
      enable_git_status = true,
      sync_root_with_cwd = true,
      respect_buf_cwd = true,
      update_focused_file = {
        enable = true,
        update_root = true,
      },
      sources = { "filesystem", "buffers", "git_status", "document_symbols" },
      open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
      event_handlers = {
        {
          event = "file_opened",
          handler = function()
            require("neo-tree.command").execute({ action = "close" })
          end,
        },
      },

      filesystem = {
        bind_to_cwd = false,
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        window = {
          mappings = {
            ["Y"] = function(state)
              -- NeoTree is based on [NuiTree](https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/tree)
              -- The node is based on [NuiNode](https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/tree#nuitreenode)
              local node = state.tree:get_node()
              local filepath = node:get_id()
              local filename = node.name
              local modify = vim.fn.fnamemodify

              local results = {
                filepath,
                modify(filepath, ":."),
                modify(filepath, ":~"),
                filename,
                modify(filename, ":r"),
                modify(filename, ":e"),
              }

              local messages = {
                "Choose to copy to clipboard:",
                "1. Absolute path: " .. results[1],
                "2. Path relative to CWD: " .. results[2],
                "3. Path relative to HOME: " .. results[3],
                "4. Filename: " .. results[4],
                "5. Filename without extension: " .. results[5],
                "6. Extension of the filename: " .. results[6],
              }
              vim.api.nvim_echo({ { table.concat(messages, "\n"), "Normal" } }, true, {})
              local i = vim.fn.getchar()

              if i >= 49 and i <= 54 then
                local result = results[i - 48]
                print(result)
                vim.fn.setreg("*", result)
              else
                print("Invalid choice: " .. string.char(i))
              end
            end,
          },
        },
      },
      window = {
        mappings = {
          ["<space>"] = "none",
          ["Y"] = function(state)
            local node = state.tree:get_node()
            local path = node:get_id()
            vim.fn.setreg("+", path, "c")
          end,
        },
      },
      default_component_configs = {
        indent = {
          with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
          expander_collapsed = "",
          expander_expanded = "",
          expander_highlight = "NeoTreeExpander",
        },
      },
    },

    config = function(_, opts)
      local events = require("neo-tree.events")
      opts.event_handlers = opts.event_handlers or {}
      require("neo-tree").setup(opts)
      vim.api.nvim_create_autocmd("TermClose", {
        pattern = "*lazygit",
        callback = function()
          if package.loaded["neo-tree.sources.git_status"] then
            require("neo-tree.sources.git_status").refresh()
          end
        end,
      })
    end,
  },
})

vim.api.nvim_create_user_command("Format", function(args)
  local range = nil
  if args.count ~= -1 then
    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
    range = {
      start = { args.line1, 0 },
      ["end"] = { args.line2, end_line:len() },
    }
  end
  require("conform").format({ async = true, lsp_fallback = true, range = range })
end, { range = true })

-- Make line numbers default
vim.wo.number = true
vim.o.mouse = "a"

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = "yes"

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

vim.o.termguicolors = true

local capabilities = require("cmp_nvim_lsp").default_capabilities()
require("mason-lspconfig").setup_handlers({
  -- auto setup of lsp servers
  function(server_name)
    require("lspconfig")[server_name].setup({
      capabilities = capabilities,
    })
  end,
})
require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls",
    "ts_ls",
    "eslint",
    "pyright",
    "intelephense",
    "docker_compose_language_service",
    "groovyls",
    "dockerls",
    "jsonls",
    "html",
  },
  automatic_installation = true,
})

local lspconfig = require("lspconfig")

lspconfig.groovyls.setup({
  filetypes = { "groovy", "jenkinsfile" },
  root_dir = lspconfig.util.root_pattern(".git", "*.gradle", "Jenkinsfile"),
})

-- Ensure Jenkinsfiles are recognized as Groovy files
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = { "Jenkinsfile", "*.Jenkinsfile", "*.jenkinsfile" },
  callback = function()
    vim.bo.filetype = "groovy"
  end,
})

-- TELESCOPE Config
require("telescope").setup({
  defaults = {
    -- Default configuration for all pickers
    file_ignore_patterns = {
      "node_modules/",
      ".git/",
      "target/",
      "build/",
      "dist/",
      "vendor/",
      "%.lock",
    },
    mappings = {
      i = {
        ["<C-u>"] = false,
        ["<C-d>"] = false,
      },
    },
  },
  pickers = {
    find_files = {
      -- This is the JetBrains behavior - showing hidden files but respecting gitignore
      hidden = true,
      respect_gitignore = true,
      no_ignore = false,
    },
  },
})

-- ZACHARY KEYMAPS!!!

vim.keymap.set("n", "<leader>a", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })

local telescope = require("telescope.builtin")
vim.keymap.set("n", "<leader>o", telescope.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>f", telescope.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>?", telescope.oldfiles, { desc = "[?] Find recently opened files" })
vim.keymap.set("n", "<leader><space>", telescope.buffers, { desc = "[ ] Find existing buffers" })
vim.keymap.set("n", "<leader>/", function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  telescope.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
    winblend = 10,
    previewer = false,
  }))
end, { desc = "[/] Fuzzily search in current buffer" })

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    -- JetBrains-like keybindings
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = ev.buf, desc = "Go to declaration" })
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = ev.buf, desc = "Go to definition" })
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = ev.buf, desc = "Hover documentation" })
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = ev.buf, desc = "Go to implementation" })
    vim.keymap.set("n", "<leader>R", vim.lsp.buf.rename, { buffer = ev.buf, desc = "Rename symbol" })
    vim.keymap.set({ "n", "v" }, "<space>C", vim.lsp.buf.code_action, { buffer = ev.buf, desc = "Code action" })
    vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = ev.buf, desc = "Go to references" })
  end,
})

vim.api.nvim_create_autocmd("QuitPre", {
  callback = function()
    require("neo-tree.command").execute({ action = "close" })
  end,
})
