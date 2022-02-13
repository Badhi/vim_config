local M = {}

local function lsp_status()
    if not pcall(require, 'lsp-status') then
        return 
    end
    return require'lsp-status'.status()
end

local function lualine_setup()
    require'lualine'.setup {
        options = {
            icons_enabled = true,
            --theme = 'gruvbox',
            --component_separators = {'', ''},
            --section_separators = {'', ''},
            disabled_filetypes = {}
        },
        sections = {
            lualine_a = {'mode'},
            lualine_b = {'branch'},
            lualine_c = {'filename'},
            lualine_x = {'encoding', 'fileformat', 'filetype'},
            lualine_y = {'progress', lsp_status},
            lualine_z = {'location'}
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = {'filename'},
            lualine_x = {'location'},
            lualine_y = {},
            lualine_z = {}
        },
        tabline = {},
        extensions = {}
    }
end

local function heirline_setup()
    local conditions = require("heirline.conditions")
    local utils = require("heirline.utils")

    local colors = {
        red = utils.get_highlight("DiagnosticError").fg,
        green = utils.get_highlight("String").fg,
        blue = utils.get_highlight("Function").fg,
        gray = utils.get_highlight("NonText").fg,
        orange = utils.get_highlight("DiagnosticWarn").fg,
        purple = utils.get_highlight("Statement").fg,
        cyan = utils.get_highlight("Special").fg,
        diag = {
            warn = utils.get_highlight("DiagnosticWarn").fg,
            error = utils.get_highlight("DiagnosticError").fg,
            hint = utils.get_highlight("DiagnosticHint").fg,
            info = utils.get_highlight("DiagnosticInfo").fg,
        },
--        git = {
 --           del = utils.get_highlight("diffDeleted").fg,
  --          add = utils.get_highlight("diffAdded").fg,
   --         change = utils.get_highlight("diffChanged").fg,
    --    },
    }

    local ViMode = {
        -- get vim current mode, this information will be required by the provider
        -- and the highlight functions, so we compute it only once per component
        -- evaluation and store it as a component attribute
        init = function(self)
            self.mode = vim.fn.mode(1) -- :h mode()
        end,
        -- Now we define some dictionaries to map the output of mode() to the
        -- corresponding string and color. We can put these into `static` to compute
        -- them at initialisation time.
        static = {
            mode_names = { -- change the strings if yow like it vvvvverbose!
            n = "N",
            no = "N?",
            nov = "N?",
            noV = "N?",
            ["no^V"] = "N?",
            niI = "Ni",
            niR = "Nr",
            niV = "Nv",
            nt = "Nt",
            v = "V",
            vs = "Vs",
            V = "V_",
            Vs = "Vs",
            ["^V"] = "^V",
            ["^Vs"] = "^V",
            s = "S",
            S = "S_",
            ["^S"] = "^S",
            i = "I",
            ic = "Ic",
            ix = "Ix",
            R = "R",
            Rc = "Rc",
            Rx = "Rx",
            Rv = "Rv",
            Rvc = "Rv",
            Rvx = "Rv",
            c = "C",
            cv = "Ex",
            r = "...",
            rm = "M",
            ["r?"] = "?",
            ["!"] = "!",
            t = "T",
        },
            mode_colors = {
                n = colors.red ,
                i = colors.green,
                v = colors.cyan,
                V =  colors.cyan,
                ["^V"] =  colors.cyan,
                c =  colors.orange,
                s =  colors.purple,
                S =  colors.purple,
                ["^S"] =  colors.purple,
                R =  colors.orange,
                r =  colors.orange,
                ["!"] =  colors.red,
                t =  colors.red,
            }
        },
        -- We can now access the value of mode() that, by now, would have been
        -- computed by `init()` and use it to index our strings dictionary.
        -- note how `static` fields become just regular attributes once the
        -- component is instantiated.
        -- To be extra meticulous, we can also add some vim statusline syntax to
        -- control the padding and make sure our string is always at least 2
        -- characters long. Plus a nice Icon.
        provider = function(self)
            return " %2("..self.mode_names[self.mode].."%)"
        end,
        -- Same goes for the highlight. Now the foreground will change according to the current mode.
        hl = function(self)
            local mode = self.mode:sub(1, 1) -- get only the first mode character
            return { fg = self.mode_colors[mode], style = "bold", }
        end,
    }

    local FileNameBlock = {
        -- let's first set up some attributes needed by this component and it's children
        init = function(self)
            self.filename = vim.api.nvim_buf_get_name(0)
        end,
    }
    -- We can now define some children separately and add them later

    local FileIcon = {
        init = function(self)
            local filename = self.filename
            local extension = vim.fn.fnamemodify(filename, ":e")
            self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
        end,
        provider = function(self)
            return self.icon and (self.icon .. " ")
        end,
        hl = function(self)
            return { fg = self.icon_color }
        end
    }

    local FileName = {
        provider = function(self)
            -- first, trim the pattern relative to the current directory. For other
            -- options, see :h filename-modifers
            local filename = vim.fn.fnamemodify(self.filename, ":.")
            if filename == "" then return "[No Name]" end
            -- now, if the filename would occupy more than 1/4th of the available
            -- space, we trim the file path to its initials
            if not conditions.width_percent_below(#filename, 0.25) then
                filename = vim.fn.pathshorten(filename)
            end
        end,
        hl = { fg = utils.get_highlight("Directory").fg },
    }

    local FileFlags = {
        {
            provider = function() if vim.bo.modified then return "[+]" end end,
            hl = { fg = colors.green }

        }, {
            provider = function() if (not vim.bo.modifiable) or vim.bo.readonly then return "" end end,
            hl = { fg = colors.orange }
        }
    }

    -- Now, let's say that we want the filename color to change if the buffer is
    -- modified. Of course, we could do that directly using the FileName.hl field,
    -- but we'll see how easy it is to alter existing components using a "modifier"
    -- component

    local FileNameModifer = {
        hl = function()
            if vim.bo.modified then
                -- use `force` because we need to override the child's hl foreground
                return { fg = colors.cyan, style = 'bold', force=true }
            end
        end,
    }

    -- let's add the children to our FileNameBlock component
    FileNameBlock = utils.insert(FileNameBlock,
                                    FileIcon,
                                    utils.insert(FileNameModifer, FileName), -- a new table where FileName is a child of FileNameModifier
                                    unpack(FileFlags), -- A small optimisation, since their parent does nothing
                                    { provider = '%<'} -- this means that the statusline is cut here when there's not enough space
                                    )


    local statusline = { ViMode , FileNameBlock}
    require'heirline'.setup(statusline)
end

function M.setup()
    local lualine = true
    if lualine then
        lualine_setup()
    else
        heirline_setup()
    end
end

return M
