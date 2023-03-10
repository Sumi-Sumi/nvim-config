local is_linux = require("core.global").is_linux
local formatting = require("modules.completion.formatting")

local nvim_lsp = require("lspconfig")
local mason = require("mason")
local mason_lsp = require("mason-lspconfig")
local configs = {}

require("lspconfig.ui.windows").default_options.border = "single"

-- {{{ nvim-lsp attach functions

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

local function custom_attach(client, bufnr)
    require("lsp_signature").on_attach({
        bind = true,
        use_lspsaga = false,
        floating_window = true,
        fix_pos = true,
        hint_enable = true,
        hi_parameter = "Search",
        handler_opts = {
            border = "rounded",
        },
    })
end

local function switch_source_header_splitcmd(bufnr, splitcmd)
    bufnr = nvim_lsp.util.validate_bufnr(bufnr)
    local clangd_client = nvim_lsp.util.get_active_client_by_name(bufnr, "clangd")
    local params = { uri = vim.uri_from_bufnr(bufnr) }
    if clangd_client then
        clangd_client.request("textDocument/switchSourceHeader", params, function(err, result)
            if err then
                error(tostring(err))
            end
            if not result then
                vim.notify("Corresponding file can’t be determined", vim.log.levels.ERROR, { title = "LSP Error!" })
                return
            end
            vim.api.nvim_command(splitcmd .. " " .. vim.uri_to_fname(result))
        end)
    else
        vim.notify(
            "Method textDocument/switchSourceHeader is not supported by any active server on this buffer",
            vim.log.levels.ERROR,
            { title = "LSP Error!" }
        )
    end
end
-- }}}

-- LSP configs
-- Override server settings here
configs["bashls"] = {}

configs["efm"] = {}

configs["pyright"] = {}

configs["rnix"] = {}

configs["marksman"] = {}

configs["texlab"] = { -- {{{
    cmd = { "texlab" },
    capabilities = capabilities,
    settings = {
        texlab = {
            auxDirectory = "./build",
            bibtexFormatter = "none",
            build = {
                args = { "%f" },
                executable = "latexmk",
                forwardSearchAfter = false,
                onSave = false,
            },
            chktex = {
                onEdit = false,
                onOpenAndSave = true,
            },
            diagnosticsDelay = 200,
            formatterLineLength = 120,
            forwardSearch = {
                args = {},
            },
            -- texlab latexindent and luasnip conflict (2023/01/27).
            -- The latexindent from efm works perfectly.
            -- Since texlab formatter is not implemented yet, specifying this will disable the formatter.
            -- If texlab formatter is implemented, you cannot disable formatter in this way
            latexFormatter = "none",
        },
    },
} -- }}}

configs["gopls"] = { -- {{{
    on_attach = custom_attach,
    flags = { debounce_text_changes = 500 },
    capabilities = capabilities,
    cmd = { "gopls", "-remote=auto" },
    settings = {
        gopls = {
            usePlaceholders = true,
            analyses = {
                nilness = true,
                shadow = true,
                unusedparams = true,
                unusewrites = true,
            },
        },
    },
} -- }}}

configs["sumneko_lua"] = { -- {{{
    capabilities = capabilities,
    on_attach = custom_attach,
    settings = {
        Lua = {
            diagnostics = { globals = { "vim", "packer_plugins" } },
            workspace = {
                library = {
                    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                    [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                },
                maxPreload = 100000,
                preloadFileSize = 10000,
            },
            telemetry = { enable = false },
            -- Do not override treesitter lua highlighting with sumneko lua highlighting
            semantic = { enable = false },
        },
    },
} -- }}}

configs["clangd"] = { -- {{{
    capabilities = vim.tbl_deep_extend("keep", { offsetEncoding = { "utf-16", "utf-8" } }, capabilities),
    single_file_support = true,
    on_attach = custom_attach,
    cmd = {
        "clangd",
        "--background-index",
        "--pch-storage=memory",
        -- You MUST set this arg ↓ to your c/cpp compiler location (if not included)!
        "--query-driver=/usr/bin/clang++,/usr/bin/**/clang-*,/bin/clang,/bin/clang++,/usr/bin/gcc,/usr/bin/g++",
        "--clang-tidy",
        "--all-scopes-completion",
        "--cross-file-rename",
        "--completion-style=detailed",
        "--header-insertion-decorators",
        "--header-insertion=iwyu",
    },
    commands = {
        ClangdSwitchSourceHeader = {
            function()
                switch_source_header_splitcmd(0, "edit")
            end,
            description = "Open source/header in current buffer",
        },
        ClangdSwitchSourceHeaderVSplit = {
            function()
                switch_source_header_splitcmd(0, "vsplit")
            end,
            description = "Open source/header in a new vsplit",
        },
        ClangdSwitchSourceHeaderSplit = {
            function()
                switch_source_header_splitcmd(0, "split")
            end,
            description = "Open source/header in a new split",
        },
    },
} -- }}}

configs["jsonls"] = { -- {{{
    flags = { debounce_text_changes = 500 },
    capabilities = capabilities,
    on_attach = custom_attach,
    settings = {
        json = {
            -- Schemas https://www.schemastore.org
            schemas = {
                {
                    fileMatch = { "package.json" },
                    url = "https://json.schemastore.org/package.json",
                },
                {
                    fileMatch = { "tsconfig*.json" },
                    url = "https://json.schemastore.org/tsconfig.json",
                },
                {
                    fileMatch = {
                        ".prettierrc",
                        ".prettierrc.json",
                        "prettier.config.json",
                    },
                    url = "https://json.schemastore.org/prettierrc.json",
                },
                {
                    fileMatch = { ".eslintrc", ".eslintrc.json" },
                    url = "https://json.schemastore.org/eslintrc.json",
                },
                {
                    fileMatch = {
                        ".babelrc",
                        ".babelrc.json",
                        "babel.config.json",
                    },
                    url = "https://json.schemastore.org/babelrc.json",
                },
                {
                    fileMatch = { "lerna.json" },
                    url = "https://json.schemastore.org/lerna.json",
                },
                {
                    fileMatch = {
                        ".stylelintrc",
                        ".stylelintrc.json",
                        "stylelint.config.json",
                    },
                    url = "http://json.schemastore.org/stylelintrc.json",
                },
                {
                    fileMatch = { "/.github/workflows/*" },
                    url = "https://json.schemastore.org/github-workflow.json",
                },
            },
        },
    },
} -- }}}

configs["html"] = { -- {{{
    filetypes = { "html" },
    init_options = {
        configurationSection = { "html", "css", "javascript" },
        embeddedLanguages = { css = true, javascript = true },
    },
    settings = {},
    single_file_support = true,
    flags = { debounce_text_changes = 500 },
    capabilities = capabilities,
    on_attach = custom_attach,
} -- }}}

--{{{ patching hook after mason-install
-- Make mason packages work with nixos
-- We're using patchelf to mathe that work
-- Thanks to: https://github.com/williamboman/mason.nvim/issues/428#issuecomment-1357192515
local function return_exe_value(cmd)
    local handle = io.popen(cmd)
    local result = handle:read("*a")
    handle:close()

    return result
end

local mason_registry = require("mason-registry")
if is_linux and vim.api.nvim_exec("!cat /etc/os-release | grep '^NAME'", true):find("NixOS") ~= nil then
    mason_registry:on("package:install:success", function(pkg)
        pkg:get_receipt():if_present(function(receipt)
            -- Figure out the interpreter inspecting nvim itself
            -- This is the same for all packages, so compute only once
            -- Set the interpreter on the binary
            local nvim = return_exe_value("nix path-info -r /run/current-system | grep neovim-unwrapped"):sub(1, -2)
            local interpreter = return_exe_value(("patchelf --print-interpreter %q" .. "/bin/nvim"):format(nvim)):sub(1, -2)
            for _, rel_path in pairs(receipt.links.bin) do
                local bin_abs_path = pkg:get_install_path() .. "/" .. rel_path
                if pkg.name == "lua-language-server" then
                    bin_abs_path = pkg:get_install_path() .. "/extension/server/bin/lua-language-server"
                    os.execute(("patchelf --set-interpreter %s %s"):format(interpreter, bin_abs_path))
                elseif pkg.name == "clangd" then
                    bin_abs_path = pkg:get_install_path() .. "/clangd/bin/clangd"
                    os.execute(("patchelf --set-interpreter %s %s"):format(interpreter, bin_abs_path))
                elseif pkg.name == "marksman" then
                    bin_abs_path = pkg:get_install_path() .. "/marksman"
                    local libstdcpp = return_exe_value("nix path-info -r /run/current-system | grep gcc | grep lib | head -n1"):sub(1, -2) .. "/lib"
                    local zlib = return_exe_value("nix path-info -r /run/current-system | grep zlib | head -n1"):sub(1, -2) .. "/lib"
                    local icu4c = return_exe_value("nix path-info -r /run/current-system | grep icu4c | head -n1"):sub(1, -2) .. "/lib"
                    os.execute(("patchelf --set-interpreter %s --set-rpath %s:%s:%s %s"):format(interpreter, libstdcpp, zlib, icu4c, bin_abs_path))
                elseif pkg.name == "stylua" then
                    bin_abs_path = pkg:get_install_path() .. "/stylua"
                    os.execute(("patchelf --set-interpreter %s %s"):format(interpreter, bin_abs_path))
                elseif pkg.name == "texlab" then
                    bin_abs_path = pkg:get_install_path() .. "/texlab"
                    os.execute(("patchelf --set-interpreter %s %s"):format(interpreter, bin_abs_path))
                end
            end
        end)
    end)
end
-- }}}

-- {{{ lsp and mason init
mason.setup({
    ui = {
        border = "rounded",
    },
})

local _lsp = {}
local n = 0
for k, _ in pairs(configs) do
    n = n + 1
    _lsp[n] = k
end
mason_lsp.setup({
    ensure_installed = _lsp,
})
for _, server in ipairs(mason_lsp.get_installed_servers()) do
    nvim_lsp[server].setup(configs[server])
end
-- }}}

-- {{{ efmls-config
local efmls = require("efmls-configs")

-- Init `efm-langserver` here.
efmls.init({
    on_attach = custom_attach,
    capabilities = capabilities,
    init_options = { documentFormatting = true, codeAction = true },
})

-- Require `efmls-configs-nvim`'s config here
local vint = require("efmls-configs.linters.vint")
local eslint = require("efmls-configs.linters.eslint")
local flake8 = require("efmls-configs.linters.flake8")
local shellcheck = require("efmls-configs.linters.shellcheck")

local black = require("efmls-configs.formatters.black")
local stylua = require("efmls-configs.formatters.stylua")
local prettier = require("efmls-configs.formatters.prettier")
local shfmt = require("efmls-configs.formatters.shfmt")

-- Add your own config for formatter and linter here

-- local rustfmt = require("modules.completion.efm.formatters.rustfmt")
local clangfmt = require("modules.completion.efm.formatters.clangfmt")
local latexfmt = require("modules.completion.efm.formatters.latexfmt")

-- Override default config here

flake8 = vim.tbl_extend("force", flake8, {
    prefix = "flake8: max-line-length=120, ignore F403 and F405",
    lintStdin = true,
    lintIgnoreExitCode = true,
    lintFormats = { "%f:%l:%c: %t%n%n%n %m" },
    lintCommand = "flake8 --max-line-length 120 --extend-ignore F403,F405 --format '%(path)s:%(row)d:%(col)d: %(code)s %(code)s %(text)s' --stdin-display-name ${INPUT} -",
})

black = vim.tbl_extend("force", black, {
    prefix = "black: max-line-length=120",
    formatCommand = "black --no-color -q -l 120 -",
})

stylua = vim.tbl_extend("force", black, {
    prefix = "stylua: --indent-type Spaces",
    formatCommand = "stylua --indent-type Spaces --column-width 150 -",
})

-- Setup formatter and linter for efmls here

efmls.setup({
    vim = { formatter = vint },
    lua = { formatter = stylua },
    c = { formatter = clangfmt },
    cpp = { formatter = clangfmt },
    python = { formatter = black, linter = flake8 },
    vue = { formatter = prettier },
    typescript = { formatter = prettier, linter = eslint },
    javascript = { formatter = prettier, linter = eslint },
    typescriptreact = { formatter = prettier, linter = eslint },
    javascriptreact = { formatter = prettier, linter = eslint },
    yaml = { formatter = prettier },
    html = { formatter = prettier },
    css = { formatter = prettier },
    scss = { formatter = prettier },
    sh = { formatter = shfmt, linter = shellcheck },
    markdown = { formatter = prettier },
    tex = { formatter = latexfmt },
    -- rust = {formatter = rustfmt},
})

formatting.configure_format_on_save()
-- }}}
