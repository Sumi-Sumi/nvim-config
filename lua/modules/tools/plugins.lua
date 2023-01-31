local tools = {}
local conf = require("modules.tools.config")

-- CodePallet
tools["mrjones2014/legendary.nvim"] = {
    dependencies = {
        { "kkharji/sqlite.lua" },
        { "stevearc/dressing.nvim", event = "VeryLazy", config = conf.dressing },
        -- Please don't remove which-key.nvim otherwise you need to set timeoutlen=300 at `lua/core/lazyions.lua`
        { "folke/which-key.nvim", event = "VeryLazy", config = conf.which_key },
    },
    cmd = "Legendary",
    config = conf.legendary,
}

tools["nvim-neo-tree/neo-tree.nvim"] = {
    branch = "v2.x",
    dependencies = {
        { "nvim-lua/plenary.nvim" },
        { "nvim-tree/nvim-web-devicons" },
        { "MunifTanjim/nui.nvim" },
        { "s1n7ax/nvim-window-picker", config = conf.window_picker },
    },
    cmd = {
        "Neotree",
        "NeoTreeShow",
        "NeoTreeShowToggle",
        "NeoTreeShowInSplit",
        "NeoTreeShowInSplitToggle",
    },
    -- event = "BufReadPost",
    config = conf.neo_tree,
}

tools["nvim-orgmode/orgmode"] = {
    event = "VeryLazy",
    config = conf.orgmode,
}

-- Codeの部分実行
tools["michaelb/sniprun"] = {
    build = "bash ./install.sh",
    cmd = { "SnipRun" },
    config = conf.sniprun,
}

-- Show trouble
tools["folke/trouble.nvim"] = {
    cmd = { "Trouble", "TroubleToggle", "TroubleRefresh" },
    config = conf.trouble,
}

tools["mbbill/undotree"] = {
    cmd = "UndotreeToggle",
    config = conf.undotree,
}

tools["thinca/vim-quickrun"] = {
    cmd = "QuickRun",
    dependencies = {
        { "Shougo/vimproc.vim", build = "make" },
    },
}

tools["dstein64/vim-startuptime"] = {
    cmd = "StartupTime",
}

tools["folke/which-key.nvim"] = {
    lazy = false,
    config = conf.which_key,
}

tools["gelguy/wilder.nvim"] = {
    event = "CmdlineEnter",
    dependencies = { { "romgrk/fzy-lua-native" } },
    config = conf.wilder,
}

tools["akinsho/toggleterm.nvim"] = {
    -- cmd = "ToggleTerm",
    event = "UIEnter",
    config = conf.toggleterm,
}

tools["nvim-telescope/telescope.nvim"] = {
    dependencies = {
        { "nvim-lua/plenary.nvim" },
        { "nvim-lua/popup.nvim" },
        { "nvim-tree/nvim-web-devicons" },
        { "dhruvmanila/telescope-bookmarks.nvim" },
        { "sudormrfbin/cheatsheet.nvim", cmd = "Cheatsheet" },
        {
            "nvim-telescope/telescope-frecency.nvim",
            dependencies = {
                { "kkharji/sqlite.lua" },
                { "nvim-tree/nvim-web-devicons" },
            },
        },
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        { "nvim-telescope/telescope-live-grep-args.nvim" },
        { "nvim-telescope/telescope-media-files.nvim" },
        { "barrett-ruth/telescope-http.nvim" },
        { "nvim-telescope/telescope-project.nvim" },
        { "LukasPietzschmann/telescope-tabs", config = conf.telescope_tabs },
        { "chip/telescope-software-licenses.nvim" },
        { "jvgrootveld/telescope-zoxide" },

        { "debugloop/telescope-undo.nvim" },
        -- { "ahmedkhalf/project.nvim", event = "BufReadPost", config = conf.project },
    },
    cmd = {
        "Telescope",
    },
    config = conf.telescope,
}

return tools
