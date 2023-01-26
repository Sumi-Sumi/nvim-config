local utils = {}
local conf = require("modules.utils.config")

utils["rainbowhxch/accelerated-jk.nvim"] = {
    event = "VeryLazy",
    config = conf.accelerated_jk,
}

utils["max397574/better-escape.nvim"] = {
    event = "BufReadPost",
    config = conf.better_escape,
}

utils["ojroques/nvim-bufdel"] = {
    event = "BufReadPost",
}

-- utils["famiu/bufdelete.nvim"] = {
--     cmd = {
--         "Bdelete",
--         "Bwipeout",
--         "Bdelete!",
--         "Bwipeout!",
--     },
--     config = conf.bufdelete,
-- }

utils["rhysd/clever-f.vim"] = {
    event = "BufReadPost",
    config = conf.clever_f,
}

utils["sindrets/diffview.nvim"] = {
    cmd = { "DiffviewOpen", "DiffviewClose" },
}

utils["phaazon/hop.nvim"] = {
    branch = "v2",
    event = "BufReadPost",
    config = conf.hop,
}

utils["terrortylor/nvim-comment"] = {
    event = "BufReadPost",
    config = conf.nvim_comment,
}

utils["tyru/open-browser.vim"] = {
    cmd = {
        "OpenBrowser",
        "OpenBrowserSearch",
        "OpenBrowserSmartSearch",
    },
    setup = conf.open_browser,
}

utils["folke/todo-comments.nvim"] = {
    event = "BufReadPost",
    config = conf.todo_comments,
}

-- utils["ahmedkhalf/project.nvim"] = {
--
--     after = "telescope",
--     conf = config.project
-- }

utils["ntpeters/vim-better-whitespace"] = {
    event = "BufWritePre",
    config = conf.better_whitespace,
}

utils["romainl/vim-cool"] = {
    event = { "CursorMoved", "InsertEnter" },
}

utils["junegunn/vim-easy-align"] = {
    cmd = "EasyAlign",
}

utils["tpope/vim-fugitive"] = {
    cmd = { "Git", "G", "Gwrite" },
}

utils["tpope/vim-repeat"] = {
    event = "BufReadPost",
}

utils["kylechui/nvim-surround"] = {
    event = "BufReadPost",
    config = conf.surround,
}

utils["vim-skk/skkeleton"] = {
    dependencies = {
        { "vim-denops/denops.vim" },
    },
    event = "VeryLazy",
    config = conf.skkeleton,
}

utils["vim-jp/vimdoc-ja"] = {
    lazy = false,
}

return utils
