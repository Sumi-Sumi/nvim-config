local lang = {}
local conf = require("modules.lang.config")

lang["chrisbra/csv.vim"] = {
    ft = "csv",
    config = conf.csv
}

lang["akinsho/flutter-tools.nvim"] = {
    dependencies = {
        { "nvim-lua/plenary.nvim" },
    },
    ft = "dart",
    config = conf.flutter_tools,
}

lang["iamcco/markdown-preview.nvim"] = {
    build = "cd app && npm install",
    ft = { "markdown" },
    config = conf.md_preview,
}

lang["simrat39/rust-tools.nvim"] = {
    dependencies = {
        { "nvim-lua/plenary.nvim", opt = false },
    },
    ft = "rust",
    config = conf.rust_tools,
}

lang["fatih/vim-go"] = {
    ft = "go",
    -- event = "GoInstallBinaries",
    config = conf.vim_go,
}

lang["lervag/vimtex"] = {
    ft = "tex",
    config = conf.vimtex,
}

return lang
