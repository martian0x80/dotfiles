require "nvchad.autocmds"

local autocmd = vim.api.nvim_create_autocmd

autocmd("BufReadPost", {
    pattern = "*",
    callback = function()
    local line = vim.fn.line "'\""
    if
        line > 1
        and line <= vim.fn.line "$"
        and vim.bo.filetype ~= "commit"
        and vim.fn.index({ "xxd", "gitrebase" }, vim.bo.filetype) == -1
        then
        vim.cmd 'normal! g`"'
end
end,
})

autocmd("BufDelete", {
    callback = function()
    local bufs = vim.t.bufs
    if #bufs == 1 and vim.api.nvim_buf_get_name(bufs[1]) == "" then
        vim.cmd "Nvdash"
        end
        end,
})

vim.api.nvim_create_user_command("OverseerRestartLast", function()
local overseer = require("overseer")
local tasks = overseer.list_tasks({ recent_first = true })
if vim.tbl_isempty(tasks) then
    vim.notify("No tasks found", vim.log.levels.WARN)
    else
        overseer.run_action(tasks[1], "restart")
        end
        end, {})
