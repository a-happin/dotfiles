-- ファイル保存時のハッシュ値と同じだったらmodifiedフラグをresetする
-- 衝突した場合？知らん
-- BufReadPost: ファイルを読み込んだあと
-- BufModifiedSet: ファイルを書き込んだあと(更新)
-- BufNewFile: 存在しないファイルを開いた(新規ファイル) ただしファイル名が空のときは呼ばれない
-- BufAdd {}: 新規ファイル ファイル名が空 ただし VimEnter前は呼ばれない

local EMPTY_HASH = vim.fn.sha256("")

---@param buffer integer?
local function calc_hash(buffer)
  return vim.fn.sha256(table.concat(vim.api.nvim_buf_get_lines(buffer or 0, 0, -1, false), "\n"))
end

local function save_hash()
  if vim.bo.modifiable and not vim.bo.readonly and not vim.bo.modified then
    vim.b.my_hash = calc_hash ()
  end
end

local function auto_unset_modified()
  -- vim.notify(string.format("modifiable: %s\nreadonly: %s\nmodified: %s\ncalc_hash: %s\nsaved_hash:%s", vim.bo.modifiable, vim.bo.readonly, vim.bo.modified, calc_hash(), vim.b.my_hash), nil, {title = "auto_unset_modified"})
  if vim.bo.modifiable and not vim.bo.readonly and vim.bo.modified and calc_hash() == (vim.b.my_hash or EMPTY_HASH) then
    vim.bo.modified = false
  end
end

require'my_lib/augroup' ('auto_unset_modified', function (autocmd)
  autocmd ({"BufReadPost", "BufModifiedSet"}, { callback = save_hash })
  autocmd ({"TextChanged", "InsertLeave"}, { callback = auto_unset_modified })
end)

