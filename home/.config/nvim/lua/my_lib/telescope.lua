local M = {}

local utils = require 'telescope.utils'
local strings = require "plenary.strings"
local Path = require "plenary.path"
local entry_display = require 'telescope.pickers.entry_display'
local make_entry = require 'telescope.make_entry'


-- override buffers make_entry
M.gen_from_buffer = function(opts)
  opts = opts or {}

  -- おい、忘れてるぞ calculating bufnr_width
  opts.bufnr_width = opts.bufnr_width or #tostring(vim.fn.bufnr("$"))

  local disable_devicons = opts.disable_devicons

  local icon_width = 0
  if not disable_devicons then
    local icon, _ = utils.get_devicons("fname", disable_devicons)
    icon_width = strings.strdisplaywidth(icon)
  end

  local displayer = entry_display.create {
    separator = " ",
    items = {
      { width = opts.bufnr_width },
      { width = 4 },
      { width = icon_width },
      { remaining = true },
      { width = 3 },
    },
  }

  local cwd = utils.path_expand(opts.cwd or vim.loop.cwd())

  local make_display = function(entry)
    -- bufnr_width + modes + icon + 3 spaces + : + lnum
    opts.__prefix = opts.bufnr_width + 4 + icon_width + 3 + 1 + #tostring(entry.lnum)
    local display_bufname = utils.transform_path(opts, entry.filename)
    local icon, hl_group = utils.get_devicons(entry.filename, disable_devicons)

    return displayer {
      { entry.bufnr, "TelescopeResultsNumber" },
      { entry.indicator, "TelescopeResultsComment" },
      { icon, hl_group },
      display_bufname .. ":" .. entry.lnum,
      { entry.modified, "TelescopeResultsSpecialComment" },
    }
  end

  return function(entry)
    local filename = entry.info.name ~= "" and entry.info.name or nil
    local bufname = filename and Path:new(filename):normalize(cwd) or "[No Name]"

    local hidden = entry.info.hidden == 1 and "h" or "a"
    local readonly = vim.api.nvim_buf_get_option(entry.bufnr, "readonly") and "=" or " "
    local changed = entry.info.changed == 1 and "+" or " "
    local indicator = entry.flag .. hidden .. readonly .. changed
    local lnum = 1

    -- account for potentially stale lnum as getbufinfo might not be updated or from resuming buffers picker
    if entry.info.lnum ~= 0 then
      -- but make sure the buffer is loaded, otherwise line_count is 0
      if vim.api.nvim_buf_is_loaded(entry.bufnr) then
        local line_count = vim.api.nvim_buf_line_count(entry.bufnr)
        lnum = math.max(math.min(entry.info.lnum, line_count), 1)
      else
        lnum = entry.info.lnum
      end
    end

    local res = make_entry.set_default_entry_mt({
      value = bufname,
      ordinal = entry.bufnr .. " : " .. bufname,
      display = make_display,
      bufnr = entry.bufnr,
      path = filename,
      filename = bufname,
      lnum = lnum,
      indicator = indicator,
      modified = entry.info.changed == 1 and '[+]' or '',
    }, opts)
    return res
  end
end

return M
