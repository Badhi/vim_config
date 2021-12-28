local M = {}

function M.setup()
    local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
    parser_config.awk = {
        install_info = {
            url = "/mnt/e/Work/tree-sitter-awk", -- local path or git repo
            files = {"src/parser.c"}
        },
        filetype = "awk", -- if filetype does not agrees with parser name
        --  used_by = {"bar", "baz"} -- additional filetypes that use this parser
    }

    require'nvim-treesitter.configs'.setup {
        ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
        ignore_install = { "javascript" }, -- List of parsers to ignore installing
        highlight = {
            enable = true,              -- false will disable the whole extension
            additional_vim_regex_highlighting = false,
        },
        textobjects = {
            swap = {
                enable = true,
                swap_next = {
                    ["<leader>a"] = "@parameter.inner",
                },
                swap_previous = {
                    ["<leader>A"] = "@parameter.inner",
                },
            },
        },
        nt_cpp_tools = {
            enable = true,
        },
        playground = {
            enable = true,
            disable = {},
            updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
            persist_queries = false, -- Whether the query persists across vim sessions
            keybindings = {
                toggle_query_editor = 'o',
                toggle_hl_groups = 'i',
                toggle_injected_languages = 't',
                toggle_anonymous_nodes = 'a',
                toggle_language_display = 'I',
                focus_language = 'f',
                unfocus_language = 'F',
                update = 'R',
                goto_node = '<cr>',
                show_help = '?',
            },
        }
    }

end

return M
