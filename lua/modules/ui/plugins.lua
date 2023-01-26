local ui = {}
local conf = require("modules.ui.config")

-- ColorScheme
ui["catppuccin/nvim"] = {
    lazy = false,
    name = "catppuccin",
    config = conf.catppuccin,
}

ui["navarasu/onedark.nvim"] = {
    lazy = false,
    config = conf.onedark,
}

-- Start Menu
ui["goolord/alpha-nvim"] = {
    event = "BufWinEnter",
    config = conf.alpha,
}

ui["akinsho/bufferline.nvim"] = {
    event = { "BufReadPost", "BufAdd", "BufNewFile" },
    config = conf.bufferline_nvim,
}

-- Show LSP progress
ui["j-hui/fidget.nvim"] = {
    event = "BufReadPost",
    config = conf.fidget,
}

ui["lukas-reineke/indent-blankline.nvim"] = {
    event = "BufReadPost",
    config = conf.indent_blankline,
}

ui["hoob3rt/lualine.nvim"] = {
    dependencies = {
        { "nvim-tree/nvim-web-devicons" },
    },
    event = { "BufReadPost", "BufAdd", "BufNewFile" },
    config = conf.lualine,
}

ui["rcarriga/nvim-notify"] = {
    lazy = false,
    config = conf.notify,
}

ui["petertriho/nvim-scrollbar"] = {
    dependencies = {
        { "lewis6991/gitsigns.nvim", config = conf.gitsigns },
        { "kevinhwang91/nvim-hlslens", config = conf.nvim_hlslens },
    },
    event = { "BufReadPost", "BufNewFile" },
    config = conf.nvim_scrollbar,
}

return ui
