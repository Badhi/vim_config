local M = {}

local function lsp_setup ()

    vim.api.nvim_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    local opts = { noremap=true, silent=true }

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    vim.api.nvim_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    vim.api.nvim_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    vim.api.nvim_set_keymap('n', '<C-]>', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    vim.api.nvim_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    vim.api.nvim_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    vim.api.nvim_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    vim.api.nvim_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    vim.api.nvim_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    vim.api.nvim_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
    vim.api.nvim_set_keymap('n', '<leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
    --
    --vim.api.nvim_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    --vim.api.nvim_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    --vim.api.nvim_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    --vim.api.nvim_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    --vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    --vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    --vim.api.nvim_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)

    -- lsp saga
    vim.api.nvim_set_keymap('n', '<leader>ca', '<cmd>lua require("lspsaga.codeaction").code_action()<CR>', opts)
    vim.api.nvim_set_keymap('v', '<leader>ca', ':<C-U>lua require("lspsaga.codeaction").range_code_action()<CR>', opts)
    vim.api.nvim_set_keymap('n', 'gs', '<cmd>lua require("lspsaga.signaturehelp").signature_help()<CR>', opts)
    vim.api.nvim_set_keymap('n', 'gd', '<cmd>lua require"lspsaga.provider".preview_definition()<CR>', opts)
    vim.api.nvim_set_keymap('n', 'gR', '<cmd>lua require("lspsaga.rename").rename()<CR>', opts)
    vim.api.nvim_set_keymap('n', 'K', '<cmd>lua require("lspsaga.hover").render_hover_doc()<CR>', opts)
    vim.api.nvim_set_keymap('n', '<C-f>', '<cmd>lua require("lspsaga.action").smart_scroll_with_saga(1)<CR>', opts)
    vim.api.nvim_set_keymap('n', '<C-b>', '<cmd>lua require("lspsaga.action").smart_scroll_with_saga(-1)<CR>', opts)
    vim.api.nvim_set_keymap('n', '<leader>cd', '<cmd>lua require"lspsaga.diagnostic".show_line_diagnostics()<CR>', opts)
    vim.api.nvim_set_keymap('n', '[e', '<cmd>lua require"lspsaga.diagnostic".navigate("next")({severity_limit = "Error"})<CR>', opts)
    vim.api.nvim_set_keymap('n', ']e', '<cmd>lua require"lspsaga.diagnostic".navigate("prev")({severity_limit = "Error"})<CR>', opts)
    vim.api.nvim_set_keymap('n', 'gr', '<cmd>lua require"lspsaga.provider".lsp_finder()<CR>', opts)
    --vim.lsp.set_log_level('trace')
    vim.cmd[[highlight DiagnosticHint guifg='Grey']]
    vim.cmd[[highlight DiagnosticUnderlineHint guisp=Grey gui=underline guifg=NONE guibg=NONE ctermfg=NONE ctermbg=NONE term=underline cterm=underline]]

    vim.fn.sign_define('DiagnosticSignError', {text='E', texthl='DiagnosticSignError', linehl='', numhl=''})
    vim.fn.sign_define('DiagnosticSignError', {text='', texthl='DiagnosticSignError', linehl='', numhl=''})
    vim.fn.sign_define('DiagnosticSignWarn', {text='', texthl='DiagnosticSignWarn', linehl='', numhl=''})
    vim.fn.sign_define('DiagnosticSignInformation', {text='', texthl='DiagnosticSignInformation', linehl='', numhl=''})
    vim.fn.sign_define('DiagnosticSignHint', {text='', texthl='DiagnosticSignHint', linehl='', numhl=''})

    require "lsp_signature".setup({
        hint_prefix = '🚩',
        toggle_key = '<M-x>'
    })
end

local function on_attach(_, bufnr)

    require 'lsp_signature'.on_attach()
    -- Enable completion triggered by <c-x><c-o>
end

local function clangd_lsp()
    local clangd_path = vim.fn.exepath('clangd-12')

    if not clangd_path then
        print("cannot find the clangd path")
    else
        require("clangd_extensions").setup {
            server = {
                cmd = { clangd_path, '--background-index' , '--clang-tidy'},
                capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
                on_attach = on_attach,
                flags = {
                    debounce_text_changes = 150,
                },
            },
            extensions = {
                -- defaults:
                -- Automatically set inlay hints (type hints)
                autoSetHints = true,
                -- Whether to show hover actions inside the hover window
                -- This overrides the default hover handler
                hover_with_actions = true,
                -- These apply to the default ClangdSetInlayHints command
                inlay_hints = {
                    -- Only show inlay hints for the current line
                    only_current_line = false,
                    -- Event which triggers a refersh of the inlay hints.
                    -- You can make this "CursorMoved" or "CursorMoved,CursorMovedI" but
                    -- not that this may cause  higher CPU usage.
                    -- This option is only respected when only_current_line and
                    -- autoSetHints both are true.
                    only_current_line_autocmd = "CursorHold",
                    -- wheter to show parameter hints with the inlay hints or not
                    show_parameter_hints = true,
                    -- whether to show variable name before type hints with the inlay hints or not
                    show_variable_name = false,
                    -- prefix for parameter hints
                    parameter_hints_prefix = "<- ",
                    -- prefix for all the other hints (type, chaining)
                    other_hints_prefix = "=> ",
                    -- whether to align to the length of the longest line in the file
                    max_len_align = false,
                    -- padding from the left if max_len_align is true
                    max_len_align_padding = 1,
                    -- whether to align to the extreme right or not
                    right_align = false,
                    -- padding from the right if right_align is true
                    right_align_padding = 7,
                    -- The color of the hints
                    highlight = "Comment",

                }
            }
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

local function pyright_lsp()
    require'lspconfig'.pyright.setup{
        on_attach = on_attach
    }
end

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

local function awk_lsp()
    local configs = require('lspconfig.configs')
    local lspconfig = require('lspconfig')
    if not configs.awklsp then
      configs.awklsp = {
        default_config = {
          cmd = { 'awk-language-server' },
          filetypes = { 'awk' },
          single_file_support = true,
          handlers = {
            ['workspace/workspaceFolders'] = function()
              return {{
                uri = 'file://' .. vim.fn.getcwd(),
                name = 'current_dir',
              }}
            end
          }
        },
      }
    end
    lspconfig.awklsp.setup{}
end

local function rust_lsp()

    local opts = {
        tools = { -- rust-tools options
            autoSetHints = true,
            hover_with_actions = true,
            inlay_hints = {
                show_parameter_hints = false,
                parameter_hints_prefix = "",
                other_hints_prefix = "",
            },
        },

        -- all the opts to send to nvim-lspconfig
        -- these override the defaults set by rust-tools.nvim
        -- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
        server = {
            -- on_attach is a callback called when the language server attachs to the buffer
            -- on_attach = on_attach,
            settings = {
                -- to enable rust-analyzer settings visit:
                -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
                ["rust-analyzer"] = {
                    -- enable clippy on save
                    checkOnSave = {
                        command = "clippy"
                    },
                }
            }
        },
    }

    local extension_path = vim.fn.getenv('LLDB_EXT_PATH')
    if not extension_path then
        print('Cannot set rust debugger, LLDB_EXT_PATH path not set')
        return
    else
        local codelldb_path = extension_path .. 'adapter/codelldb'
        local liblldb_path = extension_path .. 'lldb/lib/liblldb.so'

        opts['dap'] = {
            adapter = require('rust-tools.dap').get_codelldb_adapter(
                codelldb_path, liblldb_path)
        }
    end

    require('rust-tools').setup(opts)
end

function M.setup()
    lsp_setup()

    clangd_lsp()
    tsserver_lsp()
    pyright_lsp()
    lua_lsp()
    awk_lsp()
    rust_lsp()
end

return M
