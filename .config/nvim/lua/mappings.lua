require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("n", "<C-Up>", "<C-w>k")
map("n", "<C-Down>", "<C-w>j")
map("n", "<C-Left>", "<C-w>h")
map("n", "<C-Right>", "<C-w>l")
map("n", "<leader>ot", function()
    require("base46").toggle_transparency()
end, { desc = "Toggle Transparency" })
-- map("i", "<ESC>", "<C-\\><C-n>")
map("n", "<leader>rt", "<cmd>OverseerToggle<CR>", { desc = "OverseerToggle" })
map("n", "<leader>rr", "<cmd>OverseerRun<CR>", { desc = "OverseerRun" })
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
