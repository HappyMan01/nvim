-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- increament/decrement
keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")

-- delelte a word backwords
keymap.set("n", "dw", "vb_b")

-- ；---> :
keymap.set("n", ";", ":")

-- forefront
keymap.set("n", "H", "^")
keymap.set("n", "L", "$")

--tab
keymap.set("n", "te", ":tabedit", opts)
keymap.set("n", "<tab>", ":tabnext<Return>", opts)
keymap.set("n", "<s-tab>", ":tabpre<Return>", opts)

-- move window
keymap.set("n", "sh", "<C-w>h")
keymap.set("n", "sl", "<C-w>l")
keymap.set("n", "sj", "<C-w>j")
keymap.set("n", "sk", "<C-w>k")

--resize window
keymap.set("n", "<C-w><left>", "<C-w><")
keymap.set("n", "<C-w><right>", "<C-w>>")
keymap.set("n", "<C-w><up>", "<C-w>+")
keymap.set("n", "<C-w><down>", "<C-w>-")

--diagnostic
-- keymap.set("n", "<C-d>", function()
--   vim.diagnostic.goto_next()
-- end, opts)

-- jj --> esc
keymap.set("i", "jj", "<Esc>")

---visual model
keymap.set("v", "H", "^")
keymap.set("v", "L", "$")
