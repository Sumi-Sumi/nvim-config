local cmp = {}
local conf = require("modules.completion.config")

cmp["zbirenbaum/copilot.lua"] = {
    dependencies = {
        {
            "zbirenbaum/copilot-cmp",
            config = function()
                require("copilot_cmp").setup()
            end,
        },
    },
    event = "VeryLazy",
    cmd = "Copilot",
    config = conf.copilot,
}

cmp["hrsh7th/nvim-cmp"] = {
    event = "InsertEnter",
    dependencies = {
        { "onsails/lspkind.nvim" },
        { "windwp/nvim-autopairs", config = conf.autopairs },
        { "L3MON4D3/LuaSnip", dependencies = { { "rafamadriz/friendly-snippets" } }, config = conf.luasnip },

        { "lukas-reineke/cmp-under-comparator" },
        { "saadparwaiz1/cmp_luasnip" },
        { "hrsh7th/cmp-nvim-lsp" },
        { "hrsh7th/cmp-buffer" },
        { "hrsh7th/cmp-cmdline" },
        { "kdheepak/cmp-latex-symbols" },
        { "hrsh7th/cmp-nvim-lsp-document-symbol" },
        { "hrsh7th/cmp-nvim-lua" },
        { "hrsh7th/cmp-path" },
        { "f3fora/cmp-spell" },
        { "andersevenrud/cmp-tmux" },
        { "hrsh7th/cmp-omni" },
    },
    config = conf.cmp,
}

cmp["neovim/nvim-lspconfig"] = {
    dependencies = {
        { "creativenull/efmls-configs-nvim" },
        { "glepnir/lspsaga.nvim", config = conf.lspsaga },
        { "ray-x/lsp_signature.nvim" },
        { "williamboman/mason.nvim" },
        { "williamboman/mason-lspconfig.nvim" },
        { "WhoIsSethDaniel/mason-tool-installer.nvim", config = conf.mason_install },
    },
    cmd = "LspStart",
    event = { "BufReadPost", "BufAdd", "BufNewFile" },
    config = conf.nvim_lsp,
}

return cmp
