local yabs = require'yabs'

M = {}

function M.setup()
    yabs:setup({
        languages = { -- List of languages in vim's `filetype` format
        cpp = {
            default_task = 'build',
            tasks = {
                build = {
                    command = './cmake_build.sh',
                    type = 'shell',
                    output = 'buffer', -- Where to show output of the
                    -- command. Can be `buffer`,
                    -- `consolation`, `echo`,
                    -- `quickfix`, `terminal`, or `none`
                    opts = { -- Options for output (currently, there's only
                        -- `open_on_run`, which defines the behavior
                        -- for the quickfix list opening) (can be
                        -- `never`, `always`, or `auto`, the default)
                        open_on_run = 'never',
                        on_exit = vim.schedule_wrap(function (_, error)
                            if error == 0 then
                                yabs.languages.cpp.run_task('fail_check')
                            end
                        end
                        )
                    },
                },
                fail_check = {
                    command = './make_run.sh',
                    type = 'shell',
                    output = 'quickfix',
                    opts = {
                        open_on_run = 'always'
                    }
                }
            }
        }
      }
      })
end

return M
