local ts = {}
local conf = require("modules.treesitter.config")

ts["nvim-treesitter/nvim-treesitter"] = {
    dependencies = {
        { "zbirenbaum/neodim", config = conf.neodim },
        { "RRethy/vim-illuminate", config = conf.vim_illuminate },
        { "norcalli/nvim-colorizer.lua", config = conf.nvim_colorizer },
        { "mfussenegger/nvim-treehopper" },
        { "windwp/nvim-ts-autotag", config = conf.auto_tag },
        { "JoosepAlviste/nvim-ts-context-commentstring" },
        { "p00f/nvim-ts-rainbow" },
        { "nvim-treesitter/nvim-treesitter-textobjects" },
        { "abecodes/tabout.nvim", config = conf.tabout },
        { "andymass/vim-matchup" },
    },
    build = ":TSUpdate",
    event = "BufReadPost",
    config = conf.nvim_treesitter,
}

return ts
