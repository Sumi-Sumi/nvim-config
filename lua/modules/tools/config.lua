local config = {}

function config.dressing()
    local opts = {
        input = {
            enabled = true,
        },
        select = {
            enabled = true,
            backend = "telescope",
            trim_prompt = true,
        },
    }

    require("dressing").setup(opts)
end

function config.legendary()
    local opts = {
        which_key = {
            auto_register = true,
            do_binding = false,
        },
        scratchpad = {
            view = "float",
            results_view = "float",
            keep_contents = true,
        },
        sort = {
            -- sort most recently used item to the top
            most_recent_first = true,
            -- sort user-defined items before built-in items
            user_items_first = true,
            frecency = {
                -- the directory to store the database in
                db_root = string.format("%s/legendary/", vim.fn.stdpath("data")),
                -- the maximum number of timestamps for a single item
                -- to store in the database
                max_timestamps = 10,
            },
        },
        cache_path = path,
        -- Log level, one of 'trace', 'debug', 'info', 'warn', 'error', 'fatal'
        log_level = "info",
    }

    local km = { which_key = require("modules.lazy_keymap").legendary() }

    require("legendary").setup(opts)
    require("which-key").register(km.which_key)
end

function config.neo_tree()
    local icons = {
        ui = require("modules.ui.icons").get("ui"),
        git = require("modules.ui.icons").get("git"),
    }
    local km = { neo_tree = require("modules.lazy_keymap").neo_tree() }
    local opts = {
        close_if_last_window = true,
        popup_border_style = "rounded",
        enable_git_status = true,
        enable_diagnostics = true,
        source_selector = {
            winbar = true,
            statusline = false,
        },
        default_component_configs = {
            container = {
                enable_character_fade = true,
            },
            indent = {
                indent_size = 2,
                padding = 1, -- extra padding on left hand side
                -- indent guides
                with_markers = true,
                indent_marker = "│",
                last_indent_marker = "└",
                highlight = "NeoTreeIndentMarker",
                -- expander config, needed for nesting files
                with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
                expander_collapsed = "",
                expander_expanded = "",
                expander_highlight = "NeoTreeExpander",
            },
            icon = {
                folder_closed = icons.ui.Folder,
                folder_open = icons.ui.FolderOpen,
                folder_empty = icons.ui.EmptyFolder,
            },
            modified = {
                symbol = "[+]",
                highlight = "NeoTreeModified",
            },
            name = {
                trailing_slash = false,
                use_git_status_colors = true,
                highlight = "NeoTreeFileName",
            },
            git_status = {
                symbols = {
                    -- Change type
                    added = icons.git.Add,
                    modified = icons.git.Mod_alt,
                    deleted = icons.git.Remove,
                    renamed = icons.git.Rename,
                    -- Status type
                    untracked = icons.git.Untraced,
                    ignored = icons.git.Ignore,
                    unstaged = icons.git.Unstaged,
                    staged = icons.git.Staged,
                    conflict = icons.git.Confilict,
                },
            },
        },
        window = {
            position = "left",
            width = 40,
            mapping_options = {
                noremap = true,
                nowait = true,
            },
            mappings = km.neo_tree.window,
        },
        nesting_rules = {},
        filesystem = {
            hijack_netrw_behavior = "open_default",
            filtered_items = {
                hide_dotfiles = false,
                hide_gitignored = true,
                hide_hidden = true, -- only works on Windows for hidden files/directories
                hide_by_name = {
                    ".git",
                },
                hide_by_pattern = {
                    "*.meta",
                    --"*/src/*/tsconfig.json",
                },
                always_show = {
                    "packages/*",
                },
                never_show = {
                    ".DS_Store",
                    "__pycache__",
                },
                never_show_by_pattern = {
                    --".null-ls_*",
                },
            },
            window = {
                mappings = km.neo_tree.fs,
            },
        },
        buffers = {
            follow_current_file = true,

            group_empty_dirs = true, -- when true, empty folders will be grouped together
            show_unloaded = true,
            window = {
                mappings = km.neo_tree.buf,
            },
        },
        git_status = {
            window = {
                position = "float",
                mappings = km.neo_tree.git,
            },
        },
    }
    require("neo-tree").setup(opts)
end

function config.orgmode()
    local global = require("core.global")
    local utils = require("utils")
    local agenda_dir = utils.joinpath(global.home, "workspace", "my-orgs")
    if vim.fn.isdirectory(global.cache_dir) == 0 then
        utils.mkdir(utils.joinpath(agenda_dir, "notes"))
    end
    local opt = {
        org_agenda_files = { utils.joinpath(agenda_dir, "**", "*") },
        org_default_notes_file = utils.joinpath(agenda_dir, "notes", "note.org"),
    }
    require("orgmode").setup_ts_grammar()
    require("orgmode").setup(opt)
end

function config.window_picker()
    require("window-picker").setup()
end

function config.sniprun()
    local opts = {
        selected_interpreters = {}, -- " use those instead of the default for the current filetype
        repl_enable = {}, -- " enable REPL-like behavior for the given interpreters
        repl_disable = {}, -- " disable REPL-like behavior for the given interpreters
        interpreter_options = {}, -- " intepreter-specific options, consult docs / :SnipInfo <name>
        -- " you can combo different display modes as desired
        display = {
            "Classic", -- "display results in the command-line  area
            "VirtualTextOk", -- "display ok results as virtual text (multiline is shortened)
            "VirtualTextErr", -- "display error results as virtual text
            -- "TempFloatingWindow",      -- "display results in a floating window
            "LongTempFloatingWindow", -- "same as above, but only long results. To use with VirtualText__
            -- "Terminal"                 -- "display results in a vertical split
        },
        -- " miscellaneous compatibility/adjustement settings
        inline_messages = 0, -- " inline_message (0/1) is a one-line way to display messages
        -- " to workaround sniprun not being able to display anything

        borders = "shadow", -- " display borders around floating windows
        -- " possible values are 'none', 'single', 'double', or 'shadow'
    }
    require("sniprun").setup(opts)
end

function config.vimproc()
    --config
end

function config.trouble()
    local icons = {
        ui = require("modules.ui.icons").get("ui"),
        diagnostics = require("modules.ui.icons").get("diagnostics"),
    }
    local opts = {
        position = "bottom", -- position of the list can be: bottom, top, left, right
        height = 10, -- height of the trouble list when position is top or bottom
        width = 50, -- width of the list when position is left or right
        icons = true, -- use devicons for filenames
        mode = "documents_diagnostics", -- "workspace_diagnostics", "document_diagnostics", "quickfix", "lsp_references", "loclist"
        fold_open = icons.ui.ArrowOpen,
        fold_closed = icons.ui.ArrowClosed,
        group = true, -- group results by file
        padding = true, -- add an extra new line on top of the list
        -- action_keys = require("modules.lazy_keymap").trouble(),
        indent_lines = true, -- add an indent guide below the fold icons
        auto_open = false, -- automatically open the list when you have diagnostics
        auto_close = false, -- automatically close the list when you have no diagnostics
        auto_preview = true, -- automatically preview the location of the diagnostic. <esc> to close preview and go back to last window
        auto_fold = false, -- automatically fold a file trouble list at creation
        auto_jump = { "lsp_definitions" }, -- for the given modes, automatically jump if there is only a single result
        -- signs = {
        --     error = icons.ui.diagnostics.Error_alt,
        --     warning = icons.ui.diagnostics.Warning_alt,
        --     hint = icons.ui.diagnostics.Hint_alt,
        --     information = icons.ui.diagnostics.Information_alt,
        --     other = icons.ui.diagnostics.Question_alt
        -- },
        use_diagnostic_signs = false, -- enabling this will use the signs defined in your lsp client
    }

    require("trouble").setup(opts)
end

function config.undotree()
    local utils = require("utils")
    local path = utils.joinpath(require("core.global").cache_dir, "undotree")
    if vim.fn.has("persistent_undo") then
        utils.mkdir(path)
    end
    vim.g.undofile = path
    vim.g.undotree_WindowLayout = 3 -- LeftSideWindow
end

function config.which_key()
    local icons = {
        ui = require("modules.ui.icons").get("ui"),
        misc = require("modules.ui.icons").get("misc"),
    }
    local opts = {
        plugins = {
            presets = {
                operators = false,
                motions = false,
                text_objects = false,
                windows = false,
                nav = false,
                z = true,
                g = true,
            },
        },

        icons = {
            breadcrumb = icons.ui.Separator,
            separator = icons.misc.Vbar,
            group = icons.misc.Add,
        },

        window = {
            border = "none",
            position = "bottom",
            margin = { 1, 0, 1, 0 },
            padding = { 1, 1, 1, 1 },
            winblend = 0,
        },
        disable = {
            filetype = {
                "TelescopePrompt",
                "neo-tree",
            },
        },
    }

    require("which-key").setup(opts)
end

function config.wilder()
    local wilder = require("wilder")
    local icons = { ui = require("modules.ui.icons").get("ui") }

    wilder.setup({ modes = { ":", "/", "?" } })
    wilder.set_option("use_python_remote_plugin", 0)
    wilder.set_option("pipeline", {
        wilder.branch(wilder.cmdline_pipeline({ use_python = 0, fuzzy = 1, fuzzy_filter = wilder.lua_fzy_filter() }), wilder.vim_search_pipeline(), {
            wilder.check(function(_, x)
                return x == ""
            end),
            wilder.history(),
            wilder.result({
                draw = {
                    function(_, x)
                        return icons.ui.Calendar .. " " .. x
                    end,
                },
            }),
        }),
    })

    local popupmenu_renderer = wilder.popupmenu_renderer(wilder.popupmenu_border_theme({
        border = "rounded",
        empty_message = wilder.popupmenu_empty_message_with_spinner(),
        highlighter = wilder.lua_fzy_highlighter(),
        left = {
            " ",
            wilder.popupmenu_devicons(),
            wilder.popupmenu_buffer_flags({
                flags = " a + ",
                icons = { ["+"] = icons.ui.Pencil, a = icons.ui.Indicator, h = icons.ui.File },
            }),
        },
        right = {
            " ",
            wilder.popupmenu_scrollbar(),
        },
    }))
    local wildmenu_renderer = wilder.wildmenu_renderer({
        highlighter = wilder.lua_fzy_highlighter(),
        apply_incsearch_fix = true,
    })
    wilder.set_option(
        "renderer",
        wilder.renderer_mux({
            [":"] = popupmenu_renderer,
            ["/"] = wildmenu_renderer,
            substitute = wildmenu_renderer,
        })
    )
end

function config.toggleterm()
    local opts = {
        size = function(term)
            if term.direction == "horizontal" then
                return vim.o.lines * 0.3
            elseif term.direction == "vertical" then
                return vim.o.columns * 0.4
            end
        end,
        on_open = function()
            -- Prevent infinite calls from freezing neovim.
            -- Only set these options specific to this terminal buffer.
            vim.api.nvim_set_option_value("foldmethod", "manual", { scope = "local" })
            vim.api.nvim_set_option_value("foldexpr", "0", { scope = "local" })
        end,
        open_mapping = false,
        hide_number = true,
        start_in_insert = true,
        insert_mapping = true,
        persist_size = true,
        direction = "horizontal",
        close_on_exit = true,
        shell = vim.o.shell,
    }

    require("toggleterm").setup(opts)
end

function config.telescope()
    local icons = {
        ui = require("modules.ui.icons").get("ui", true),
    }

    local telescope_actions = require("telescope.actions.set")
    local fixfolds = {
        hidden = true,
        attach_mappings = function(_)
            telescope_actions.select:enhance({
                post = function()
                    vim.api.nvim_command([[:normal! zx"]])
                end,
            })
            return true
        end,
    }
    local lga_actions = require("telescope-live-grep-args.actions")

    local km = { live_grep_args = require("modules.lazy_keymap").live_grep_args(lga_actions) }

    local opts = {
        defaults = {
            prompt_prefix = " " .. icons.ui.Telescope .. " ",
            selection_caret = icons.ui.ChevronRight,
            entry_prefix = " ",
            scroll_strategy = "cycle", -- or limit
            results_title = false,
            layout_strategy = "horizontal",
            path_display = { "absolute" },
            file_ignore_patterns = {
                ".git/",
                ".cache",
                "%.class",
                "%.meta",
            },
            layout_config = {
                horizontal = {
                    preview_width = 0.5,
                },
            },
        },
        extensions = {
            fzf = {
                fuzzy = true,
                override_generic_sorter = true,
                override_file_sorter = true,
                case_mode = "smart_case",
            },
            frecency = {
                show_scores = false,
                show_unindexed = true,
                ignore_patterns = {
                    "*.git/*",
                    "*/tmp/*",
                    "*/__pycache__/*",
                    "*.meta",
                    "*.pyx",
                },
                disable_devicons = false,
            },
            live_grep_args = {
                auto_quoting = true, -- enable/disable auto-quoting
                -- define mappings, e.g.
                mappings = km.live_grep_args,
            },
        },
        pickers = {
            buffers = fixfolds,
            find_files = fixfolds,
            git_files = fixfolds,
            grep_string = fixfolds,
            live_grep = fixfolds,
            oldfiles = fixfolds,
        },
    }
    require("telescope").setup(opts)

    require("telescope").load_extension("frecency")
    require("telescope").load_extension("fzf")
    require("telescope").load_extension("live_grep_args")
    require("telescope").load_extension("notify")
    require("telescope").load_extension("project")
    require("telescope").load_extension("software-licenses")
    require("telescope").load_extension("zoxide")
    require("telescope").load_extension("bookmarks")
    require("telescope").load_extension("http")
end

function config.telescope_tabs()
    require("telescope-tabs").setup()
end

return config
