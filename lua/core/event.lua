local autocmd = {}

function autocmd.nvim_create_augroups(definitions)
    for group_name, definition in pairs(definitions) do
        vim.api.nvim_command("augroup " .. group_name)
        vim.api.nvim_command("autocmd!")
        for _, def in ipairs(definition) do
            local command = table.concat(vim.tbl_flatten({ "autocmd", def }), " ")
            vim.api.nvim_command(command)
        end
        vim.api.nvim_command("augroup END")
    end
end

function autocmd.load_autocmds()
    local definitions = {
        packer = {},
        bufs = {
            -- Reload vim config automatically
            {
                "BufWritePost",
                [[$VIM_PATH/{*.vim,*.yaml,vimrc} nested source $MYVIMRC | redraw]],
            },
            -- Reload Vim script automatically if setlocal autoread
            {
                "BufWritePost,FileWritePost",
                "*.vim",
                [[nested if &l:autoread > 0 | source <afile> | echo 'source ' . bufname('%') | endif]],
            },
            { "BufWritePre", "/tmp/*", "setlocal noundofile" },
            { "BufWritePre", "COMMIT_EDITMSG", "setlocal noundofile" },
            { "BufWritePre", "MERGE_MSG", "setlocal noundofile" },
            { "BufWritePre", "*.tmp", "setlocal noundofile" },
            { "BufWritePre", "*.bak", "setlocal noundofile" },
            -- auto change directory
            -- { "BufEnter", "*", "silent! lcd %:p:h" },
            -- auto place to last edit
            {
                "BufReadPost",
                "*",
                [[if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g'\"" | endif]],
            },
            -- Auto toggle fcitx5
            { "InsertLeave", "* :silent", "!fcitx5-remote -g EN" },
            { "InsertEnter", "* :silent", "!fcitx5-remote -g EN" },
            { "FocusGained", "* :silent", "!fcitx5-remote -g EN" },
            { "FocusLost", "* :silent", "!fcitx5-remote -g skk" },
            { "QuitPre", "*", ":silent !fcitx5-remote -g skk " },
            -- {"BufCreate", "*", ":silent !fcitx5-remote -c"},
            -- {"BufEnter", "*", ":silent !fcitx5-remote -c "},
        },
        wins = {
            -- Highlight current line only on focused window
            {
                "WinEnter,BufEnter,InsertLeave",
                "*",
                [[if ! &cursorline && &filetype !~# '^\(dashboard\|clap_\)' && ! &pvw | setlocal cursorline | endif]],
            },
            {
                "WinLeave,BufLeave,InsertEnter",
                "*",
                [[if &cursorline && &filetype !~# '^\(dashboard\|clap_\)' && ! &pvw | setlocal nocursorline | endif]],
            },
            -- Force write shada on leaving nvim
            {
                "VimLeave",
                "*",
                [[if has('nvim') | wshada! | else | wviminfo! | endif]],
            },
            -- Check if file changed when its window is focus, more eager than 'autoread'
            { "FocusGained", "* checktime" },
            -- Equalize window dimensions when resizing vim window
            { "VimResized", "*", [[tabdo wincmd =]] },
        },
        ft = {
            { "FileType", "alpha", "set showtabline=0" },
            { "FileType", "markdown", "set wrap" },
            { "FileType", "make", "set noexpandtab shiftwidth=8 softtabstop=0" },
            { "FileType", "dap-repl", "lua require('dap.ext.autocompl').attach()" },
            {
                "FileType",
                "*",
                [[setlocal formatoptions-=cro]],
            },
            {
                "FileType",
                "c,cpp",
                "nnoremap <leader>h :ClangdSwitchSourceHeaderVSplit<CR>",
            },
        },
        yank = {
            -- {
            --     "TextYankPost",
            --     "*",
            --     [[silent! lua vim.highlight.on_yank({higroup="IncSearch", timeout=300})]],
            -- },
        },
    }
    autocmd.nvim_create_augroups(definitions)
end

autocmd.load_autocmds()
-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
    pattern = {
        "qf",
        "help",
        "man",
        "notify",
        "lspinfo",
        "spectre_panel",
        "startuptime",
        "tsplayground",
        "PlenaryTestPopup",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
    end,
})

vim.api.nvim_create_autocmd("BufReadPre", {
    pattern = {
        "config.lua",
    },
    callback = function()
        vim.opt_local.foldmethod = "expr"
        vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
        vim.opt_local.foldnestmax = 1
    end,
})
