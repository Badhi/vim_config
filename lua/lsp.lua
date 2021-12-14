local M = {}

local function lsp_setup ()
    vim.cmd[[highlight DiagnosticHint guifg='Grey']]
    vim.cmd[[highlight DiagnosticUnderlineHint guisp=Grey gui=underline guifg=NONE guibg=NONE ctermfg=NONE ctermbg=NONE term=underline cterm=underline]]

    vim.fn.sign_define('DiagnosticSignError', {text='E', texthl='DiagnosticSignError', linehl='', numhl=''})
    vim.fn.sign_define('DiagnosticSignError', {text='', texthl='DiagnosticSignError', linehl='', numhl=''})
    vim.fn.sign_define('DiagnosticSignWarn', {text='', texthl='DiagnosticSignWarn', linehl='', numhl=''})
    vim.fn.sign_define('DiagnosticSignInformation', {text='', texthl='DiagnosticSignInformation', linehl='', numhl=''})
    vim.fn.sign_define('DiagnosticSignHint', {text='', texthl='DiagnosticSignHint', linehl='', numhl=''})
end

local function on_attach(_, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    -- Enable completion triggered by <c-x><c-o>
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    local opts = { noremap=true, silent=true }

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
    buf_set_keymap('n', '<leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
    --
    --buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    --buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    --buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    --buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    --buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    --buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)

    -- lsp saga
    buf_set_keymap('n', '<leader>ca', '<cmd>lua require("lspsaga.codeaction").code_action()<CR>', opts)
    buf_set_keymap('v', '<leader>ca', ':<C-U>lua require("lspsaga.codeaction").range_code_action()<CR>', opts)
    buf_set_keymap('n', 'gs', '<cmd>lua require("lspsaga.signaturehelp").signature_help()<CR>', opts)
    buf_set_keymap('n', 'gd', '<cmd>lua require"lspsaga.provider".preview_definition()<CR>', opts)
    buf_set_keymap('n', 'gR', '<cmd>lua require("lspsaga.rename").rename()<CR>', opts)
    buf_set_keymap('n', 'K', '<cmd>lua require("lspsaga.hover").render_hover_doc()<CR>', opts)
    buf_set_keymap('n', '<C-f>', '<cmd>lua require("lspsaga.action").smart_scroll_with_saga(1)<CR>', opts)
    buf_set_keymap('n', '<C-b>', '<cmd>lua require("lspsaga.action").smart_scroll_with_saga(-1)<CR>', opts)
    buf_set_keymap('n', '<leader>cd', '<cmd>lua require"lspsaga.diagnostic".show_line_diagnostics()<CR>', opts)
    buf_set_keymap('n', '[e', '<cmd>lua require"lspsaga.diagnostic".navigate("next")({severity_limit = "Error"})<CR>', opts)
    buf_set_keymap('n', ']e', '<cmd>lua require"lspsaga.diagnostic".navigate("prev")({severity_limit = "Error"})<CR>', opts)
    --buf_set_keymap('n', 'gr', '<cmd>lua require"lspsaga.provider".lsp_finder()<CR>', opts)
end

local function clangd_lsp()
    local clangd_path = vim.fn.exepath('clangd')

    if not clangd_path then
        print("cannot find the clangd path")
    else
        require'lspconfig'.clangd.setup{
            cmd = { clangd_path, '--background-index' , '--clang-tidy'},
            capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
            on_attach = on_attach,
            flags = {
                debounce_text_changes = 150,
            },
        }
    end
end

local function tsserver_lsp()
    require'lspconfig'.tsserver.setup{
        on_attach = on_attach
    }
end

--local function svlangserver_lsp()
    --require'lspconfig'.svlangserver.setup{
    --    cmd = {'svlangserver'},
    --    root = function() return '.' end,
    --}
--end

local function lua_lsp()
    -- Expecting lua lang server parth is set in the PATH env variable
    local sumneko_binary_path = vim.fn.exepath('lua-language-server')
    local sumneko_root_path = vim.fn.fnamemodify(sumneko_binary_path, ':h:h:h')

    local runtime_path = vim.split(package.path, ';')
    table.insert(runtime_path, "lua/?.lua")
    table.insert(runtime_path, "lua/?/init.lua")

    require'lspconfig'.sumneko_lua.setup {
        cmd = {sumneko_binary_path, "-E", sumneko_root_path .. "/main.lua"};
        settings = {
            Lua = {
                runtime = {
                    -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                    version = 'LuaJIT',
                    -- Setup your lua path
                    path = runtime_path,
                },
                diagnostics = {
                    -- Get the language server to recognize the `vim` global
                    globals = {'vim'},
                },
                workspace = {
                    -- Make the server aware of Neovim runtime files
                    library = vim.api.nvim_get_runtime_file("", true),
                },
                -- Do not send telemetry data containing a randomized but unique identifier
                telemetry = {
                    enable = false,
                },
            },
        },
    }
end

function M.setup()
    lsp_setup()

    clangd_lsp()
    tsserver_lsp()
    lua_lsp()
end

return M
