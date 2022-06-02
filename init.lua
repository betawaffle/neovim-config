require("plugins")
require("packer_compiled")

vim.o.clipboard = "unnamedplus,unnamed"
vim.o.completeopt = "menuone,noinsert,noselect"
vim.o.conceallevel = 0
vim.o.cursorline = true
vim.o.expandtab = true
vim.o.formatoptions = "croqj"
vim.o.grepprg = "rg --with-filename --no-heading --line-number --column --hidden --smart-case --follow"
vim.o.hidden = true
vim.o.list = true
vim.o.listchars = "tab:>-,trail:-,extends:>,precedes:>,conceal:*,nbsp:+"
vim.o.mouse = "a"
vim.o.relativenumber = true
vim.o.scrolloff = 5
vim.o.shiftwidth = 0
vim.o.shortmess = "aoOtTIF"
vim.o.showmode = false
vim.o.sidescrolloff = 5
vim.o.signcolumn = "yes"
vim.o.softtabstop = -1
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.switchbuf = "useopen,usetab"
vim.o.tabstop = 4
vim.o.textwidth = 78
vim.o.tildeop = true
vim.o.timeoutlen = 500
vim.o.title = true
vim.o.titlestring = "nvim %F"
vim.o.updatetime = 300
-- vim.o.wildignore = ""
vim.o.wildmenu = true
vim.o.wildmode = "longest:full"
vim.o.winminheight = 0
vim.o.wrap = false

vim.o.termguicolors = true

-- vim.g.completion_enable_auto_popup = 1

vim.g.vim_markdown_folding_disabled = 1
vim.g.vim_markdown_frontmatter = 1

vim.g.mapleader = [[ ]]

local function nnoremap(lhs, rhs, opts)
    opts = opts or {}
    opts.noremap = true
    vim.api.nvim_set_keymap("n", lhs, rhs, opts)
end

local function tnoremap(lhs, rhs, opts)
    opts = opts or {}
    opts.noremap = true
    vim.api.nvim_set_keymap("t", lhs, rhs, opts)
end

tnoremap("<esc>", [[<c-\><c-n>]])

nnoremap("<leader>h",  ":vertical help<space>")

nnoremap("<esc>",      ":nohlsearch<cr>", { silent = true })
nnoremap("<m-up>",     ":.move .-2<cr>",  { silent = true })
nnoremap("<m-down>",   ":.move .+1<cr>",  { silent = true })
nnoremap("<m-left>",   ":bprevious<cr>",  { silent = true })
nnoremap("<m-right>",  ":bnext<cr>",      { silent = true })

nnoremap("<leader>fb",  ":Telescope buffers<cr>")
nnoremap("<leader>fg",  ":Telescope live_grep<cr>")
nnoremap("<leader>ff",  ":Telescope find_files<cr>")
nnoremap("<leader>fh",  ":Telescope help_tags<cr>")

vim.g.gruvbox_material_palette = "original"
vim.g.gruvbox_material_enable_italic = 1
vim.g.gruvbox_material_enable_bold = 1
vim.g.gruvbox_material_ui_contrast = "high"
vim.g.gruvbox_material_diagnostic_virtual_text = "colored"
vim.g.gruvbox_material_statusline_style = "original"
vim.cmd [[colorscheme gruvbox-material]]

local function on_attach(_, bufnr)
    vim.cmd [[autocmd BufWritePre                        <buffer> lua vim.lsp.buf.formatting_seq_sync()]]
    vim.cmd [[autocmd CursorHold,CursorHoldI,InsertLeave <buffer> lua vim.lsp.codelens.refresh()]]
    vim.cmd [[autocmd CursorHold                         <buffer> lua vim.diagnostic.open_float(nil, { focusable = false })]]

    local function buf_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    buf_option("omnifunc", "v:lua.vim.lsp.omnifunc")

    local opts = { noremap = true, silent = true }

    buf_keymap("n", "<c-k>",     "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
    buf_keymap("n", "<space>D",  "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
    buf_keymap("n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
    buf_keymap("n", "<space>e",  "<cmd>lua vim.diagnostic.open_float()<cr>", opts)
    buf_keymap("n", "<space>f",  "<cmd>lua vim.lsp.buf.formatting()<cr>", opts)
    buf_keymap("n", "<space>q",  "<cmd>lua vim.diagnostic.setloclist()<cr>", opts)
    buf_keymap("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
    buf_keymap("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>", opts)
    buf_keymap("n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>", opts)
    buf_keymap("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>", opts)
    buf_keymap("n", "K",         "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
    buf_keymap("n", "[d",        "<cmd>lua vim.diagnostic.goto_prev()<cr>", opts)
    buf_keymap("n", "]d",        "<cmd>lua vim.diagnostic.goto_next()<cr>", opts)
    buf_keymap("n", "gD",        "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
    buf_keymap("n", "gd",        "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
    buf_keymap("n", "gi",        "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
    buf_keymap("n", "gr",        "<cmd>lua vim.lsp.buf.references()<cr>", opts)

    -- require("completion").on_attach()
end

local lspconfig = require("lspconfig")

local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

lspconfig.zls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
}

require("rust-tools").setup {
    server = {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
            ["rust-analyzer"] = {
                cargo = {
                    -- autoreload = false,
                },
                diagnostics = {
                    disabled = { "incorrect-ident-case" },
                },
            },
        },
    },
}

require("nvim-treesitter.configs").setup {
    -- ensure_installed = "maintained",
    highlight = {
        enable = true,
    },
    context_commentstring = {
        enable = true,
    },
    textobjects = {
        select = {
            enable = true,
            lookahead = true,
            keymaps = {
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
            },
        },
        move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
                ["]m"] = "@function.outer",
                ["]]"] = "@class.outer",
            },
            goto_next_end = {
                ["]M"] = "@function.outer",
                ["]["] = "@class.outer",
            },
            goto_previous_start = {
                ["[m"] = "@function.outer",
                ["[["] = "@class.outer",
            },
            goto_previous_end = {
                ["[M"] = "@function.outer",
                ["[]"] = "@class.outer",
            },
        },
    },
}

require("lualine").setup {
    options = {
        theme = "gruvbox-material",
        component_separators = { left = "", right = "" },
        section_separators   = { left = "", right = "" },
    },
    sections = {
        lualine_a = { "mode" },
        lualine_b = {
            "branch",
            "diff",
            {
                "diagnostics",
                sources = { "nvim_diagnostic" },
                symbols = { error = " ", warn = " ", info = " ", hint = " " },
            },
        },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
    },
    tabline = {},
    extensions = {},
}

require("bufferline").setup {
    options = {
        numbers = function(opts)
            return opts.id
        end,
        close_command = "bdelete! %d",
        right_mouse_command = "bdelete! %d",
        left_mouse_command = "buffer %d",
        middle_mouse_command = nil,
        diagnostics = "nvim_lsp",
        diagnostics_update_in_insert = true,
        show_buffer_close_icons = false,
        show_close_icon = false,
        separator_style = "slant",
    },
}

local actions = require('telescope.actions')

require('telescope').setup {
    defaults = {
        mappings = {
            i = {
                ["<esc>"] = actions.close,
            },
        },
    },
}

require("which-key").setup {
}

require("twilight").setup {
}

local cmp = require('cmp')

cmp.setup {
    -- Enable LSP snippets
    -- snippet = {
    --     expand = function(args)
    --         vim.fn["vsnip#anonymous"](args.body)
    --     end,
    -- },
    mapping = {
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-n>'] = cmp.mapping.select_next_item(),
        -- Add tab support
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        ['<Tab>'] = cmp.mapping.select_next_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
        }),
  },

  -- Installed sources
  sources = {
    { name = 'nvim_lsp' },
    -- { name = 'vsnip' },
    { name = 'path' },
    { name = 'buffer' },
  },
}
