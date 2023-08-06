return {
  -- Configure AstroNvim updates
  updater = {
    remote = "origin", -- remote to use
    channel = "stable", -- "stable" or "nightly"
    version = "latest", -- "latest", tag name, or regex search like "v1.*" to only do updates before v2 (STABLE ONLY)
    branch = "nightly", -- branch name (NIGHTLY ONLY)
    commit = nil, -- commit hash (NIGHTLY ONLY)
    pin_plugins = nil, -- nil, true, false (nil will pin plugins on stable only)
    skip_prompts = false, -- skip prompts about breaking changes
    show_changelog = true, -- show the changelog after performing an update
    auto_quit = false, -- automatically quit the current session after a successful update
    remotes = { -- easily add new remotes to track
      --   ["remote_name"] = "https://remote_url.come/repo.git", -- full remote url
      --   ["remote2"] = "github_user/repo", -- GitHub user/repo shortcut,
      --   ["remote3"] = "github_user", -- GitHub user assume AstroNvim fork
    },
  },

  -- Set colorscheme to use
  colorscheme =  "onelight",

  -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
  diagnostics = {
    virtual_text = true,
    underline = true,
  },

 
   -- Configure require("lazy").setup() options
  lazy = {
    defaults = { lazy = true },
    performance = {
      rtp = {
        -- customize default disabled vim plugins
        disabled_plugins = { "tohtml", "gzip", "matchit", "zipPlugin", "netrwPlugin", "tarPlugin" },
      },
    },
  },
  plugins = {
      { 
        "hrsh7th/nvim-cmp",
        opts = function(_, opts)
          local cmp = require "cmp"
          local kind_mapper = require "cmp.types".lsp.CompletionItemKind
          local lspkind_comparator = function(conf)
            local lsp_types = require('cmp.types').lsp
            return function(entry1, entry2)
              if entry1.source.name ~= 'nvim_lsp' then
                if entry2.source.name == 'nvim_lsp' then
                  return false
                else
                  return nil
                end
              end
              local kind1 = lsp_types.CompletionItemKind[entry1:get_kind()]
              local kind2 = lsp_types.CompletionItemKind[entry2:get_kind()]

              local priority1 = conf.kind_priority[kind1] or 0
              local priority2 = conf.kind_priority[kind2] or 0
              if priority1 == priority2 then
                return nil
              end
              return priority2 < priority1
            end
          end

          local label_comparator = function(entry1, entry2)
            return entry1.completion_item.label < entry2.completion_item.label
          end
      cmp.setup({
          snippet = {
		        expand = function(args)
			        require("luasnip").lsp_expand(args.body)
		        end,
	        },
          sorting = {
            comparators = {
            lspkind_comparator({
                      kind_priority = {
                        Field = 11,
                        Property = 11,
                        Constant = 10,
                        Enum = 10,
                        EnumMember = 10,
                        Event = 10,
                        Function = 10,
                        Method = 10,
                        Operator = 10,
                        Reference = 10,
                        Struct = 10,
                        Variable = 9,
                        File = 8,
                        Folder = 8,
                        Class = 5,
                        Color = 5,
                        Module = 5,
                        Keyword = 2,
                        Constructor = 1,
                        Interface = 1,
                        Snippet = 0,
                        Text = 1,
                        TypeParameter = 1,
                        Unit = 1,
                        Value = 1,
                      },
                    }),
              label_comparator,
              cmp.config.compare.offset,
              cmp.config.compare.exact,-- copied from cmp-under, but I don't think I need the plugin for this.
              -- I might add some more of my own.
              function(entry1, entry2)
                local _, entry1_under = entry1.completion_item.label:find "^_+"
                local _, entry2_under = entry2.completion_item.label:find "^_+"
                entry1_under = entry1_under or 0
                entry2_under = entry2_under or 0
                if entry1_under > entry2_under then
                  return false
                elseif entry1_under < entry2_under then
                  return true
                end
              end,

              cmp.config.compare.kind,
              cmp.config.compare.sort_text,
              cmp.config.compare.length,
              cmp.config.compare.order,
            },
          },

     })
        -- return the new table to be used
        return opts
      end,
    },
  },
  -- This function is run last and is a good place to configuring
  -- augroups/autocommands and custom filetypes also this just pure lua so
  -- anything that doesn't fit in the normal config locations above can go here
  polish = function()
    -- Set up custom filetypes
    -- vim.filetype.add {
    --   extension = {
    --     foo = "fooscript",
    --   },
    --   filename = {
    --     ["Foofile"] = "fooscript",
    --   },
    --   pattern = {
    --     ["~/%.config/foo/.*"] = "fooscript",
    --   },
    -- }
  end,
}
