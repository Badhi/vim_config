local dap = require'dap'

M = {}

local function lua_debugger_setup()
    dap.configurations.lua = {
        {
            type = 'nlua',
            request = 'attach',
            name = "Attach to running Neovim instance",
            host = function()
                local value = vim.fn.input('Host [127.0.0.1]: ')
                if value ~= "" then
                    return value
                end
                return '127.0.0.1'
            end,
            port = function()
                local val = tonumber(vim.fn.input('Port: '))
                assert(val, "Please provide a port number")
                return val
            end,
        }
    }

    dap.adapters.nlua = function(callback, config)
        callback({ type = 'server', host = config.host, port = config.port })
    end
end

local function python_debugger_setup()
    dap.adapters.python = {
      type = 'executable';
      command = 'python3';
      args = { '-m', 'debugpy.adapter' };
    }
    dap.configurations.python = {
        {
            -- The first three options are required by nvim-dap
            type = 'python'; -- the type here established the link to the adapter definition: `dap.adapters.python`
            request = 'launch';
            name = "Launch file";

            -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

            program = "${file}"; -- This configuration will launch the current file if used.
            pythonPath = function()
                -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
                -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
                -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
                    return '/usr/bin/python3'
            end;
        },
    }
end

function M.setup()

    lua_debugger_setup()
    python_debugger_setup()

    local dapui = require'dapui'

    dap.listeners.after.event_initialized['dapui_config'] = function() dapui.open() end
    dap.listeners.before.event_terminated['dapui_config'] = function() dapui.close() end
    dap.listeners.before.event_exited['dapui_config'] = function() dapui.close() end


    dapui.setup({
        icons = { expanded = "▾", collapsed = "▸" },
        mappings = {
            -- Use a table to apply multiple mappings
            expand = { "<CR>", "<2-LeftMouse>" },
            open = "o",
            remove = "d",
            edit = "e",
            repl = "r",
        },
        sidebar = {
            -- You can change the order of elements in the sidebar
            elements = {
                -- Provide as ID strings or tables with "id" and "size" keys
                {
                    id = "scopes",
                    size = 0.25, -- Can be float or integer > 1
                },
                { id = "breakpoints", size = 0.25 },
                { id = "stacks", size = 0.25 },
                { id = "watches", size = 00.25 },
            },
            size = 40,
            position = "left", -- Can be "left", "right", "top", "bottom"
        },
        tray = {
            elements = { "repl" },
            size = 10,
            position = "bottom", -- Can be "left", "right", "top", "bottom"
        },
        floating = {
            max_height = nil, -- These can be integers or a float between 0 and 1.
            max_width = nil, -- Floats will be treated as percentage of your screen.
            border = "single", -- Border style. Can be "single", "double" or "rounded"
            mappings = {
                close = { "q", "<Esc>" },
            },
            enter = true,
        },
        windows = { indent = 1 },
    })

    require("nvim-dap-virtual-text").setup {
        enabled = true,                     -- enable this plugin (the default)
        enabled_commands = true,            -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
        highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
        highlight_new_as_changed = false,   -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
        show_stop_reason = true,            -- show stop reason when stopped for exceptions
        commented = false,                  -- prefix virtual text with comment string
        -- experimental features:
        virt_text_pos = 'eol',              -- position of virtual text, see `:h nvim_buf_set_extmark()`
        all_frames = false,                 -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
        virt_lines = false,                 -- show virtual lines instead of virtual text (will flicker!)
        virt_text_win_col = nil             -- position the virtual text at a fixed window column (starting from the first text column) ,
        -- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
    }

    --dap.set_log_level('TRACE')

    local opts = { noremap = true, silent = true}

    vim.api.nvim_set_keymap('n', '<F5>', "<cmd>:lua require'dap'.continue()<CR>", opts)
    vim.api.nvim_set_keymap('n', '<F10>', "<cmd>:lua require'dap'.step_over()<CR>", opts)
    vim.api.nvim_set_keymap('n', '<F11>', "<cmd>:lua require'dap'.step_into()<CR>", opts)
    vim.api.nvim_set_keymap('n', '<F12>', "<cmd>:lua require'dap'.step_out()<CR>", opts)
    vim.api.nvim_set_keymap('n', '<leader>b', "<cmd>:lua require'dap'.toggle_breakpoint()<CR>", opts)
    vim.api.nvim_set_keymap('n', '<leader>B', "<cmd>:lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", opts)
    vim.api.nvim_set_keymap('n', '<leader>lp', "<cmd>:lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>", opts)
    vim.api.nvim_set_keymap('n', '<leader>dr', "<cmd>:lua require'dap'.repl.open()<CR>", opts)
    vim.api.nvim_set_keymap('n', '<leader>dl', "<cmd>:lua require'dap'.run_last()<CR>", opts)
    vim.api.nvim_set_keymap('n', '<M-i>', "<cmd>lua require'dapui'.eval()<CR>", opts)
end

return M
