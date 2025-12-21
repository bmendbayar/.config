local opt = vim.opt

vim.cmd([[set statusline=%<%f\ %h%m%r%=%-13a%-13.(%l,%c%V%)\ %P]])

-- opt.gcr = "n-v-c-sm:block,i-ci-ve:ver25,t:block-TermCursor"
opt.guicursor = ""
opt.signcolumn = "yes"
opt.colorcolumn = "80"
opt.termguicolors = true
opt.ignorecase = true

opt.autoindent = true
opt.smartindent = true
opt.expandtab = true
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.shiftround = true

opt.number = true
opt.relativenumber = true
opt.wrap = false
opt.cursorline = false
opt.scrolloff = 8

opt.inccommand = "split"
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true
opt.swapfile = false
opt.clipboard = "unnamed"
opt.completeopt = { "menuone", "popup", "noinsert" }

opt.foldenable = true
opt.foldlevel = 99
opt.foldmethod = "indent"
opt.foldcolumn = "0"
opt.foldopen = ""
opt.foldlevelstart = 99

opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

opt.laststatus = 2

vim.g.netrw_liststyle = 1
vim.g.netrw_sort_by = "size"

vim.pack.add({
	{ src = "https://github.com/blazkowolf/gruber-darker.nvim" },
	{ src = "https://github.com/vague-theme/vague.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/Saghen/blink.cmp" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	{ src = "https://github.com/chentoast/marks.nvim" },
	{ src = "https://github.com/folke/zen-mode.nvim" },
})

require("zen-mode").setup({
	window = {
		width = 100,
	},
})

require("marks").setup({
	builtin_marks = { "<", ">", "^" },
})

local function lsp_color_off()
	for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
		vim.api.nvim_set_hl(0, group, {})
	end
end

local function color_my_pencils(color)
	vim.cmd.colorscheme(color)

	vim.api.nvim_set_hl(0, "Folded", { fg = "#6e6a86", bg = "none", bold = true })
	vim.cmd([[highlight! link TelescopeNormal   Normal]])
	vim.cmd([[highlight! link TelescopeBorder   FloatBorder]])

	lsp_color_off()
	vim.g.syntax_on = true
end

require("vague").setup({
	bold = true,
	italic = false,
	transparent = true,
})

require("gruber-darker").setup({
	italic = {
		strings = false,
		comments = false,
		operators = false,
		folds = false,
	},
})

-- MY_COLOR = "vague"
MY_COLOR = "gruber-darker"
color_my_pencils(MY_COLOR)

require("mason").setup({ ui = { border = "single" } })

local actions = require("telescope.actions")
require("telescope").setup({
	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		},
	},

	defaults = {
		color_devicons = false,
		sorting_strategy = "ascending",
		borderchars = { "", "", "", "", "", "", "", "" },
		path_displays = "smart",
		layout_strategy = "horizontal",
		layout_config = {
			height = 100,
			width = 400,
			prompt_position = "top",
			preview_cutoff = 40,
		},

		mappings = {
			i = {
				["<c-d>"] = actions.delete_buffer,
			},
			n = {
				["<c-d>"] = actions.delete_buffer,
				["dd"] = actions.delete_buffer,
			},
		},
	},
})
require("telescope").load_extension("fzf")

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		luau = { "stylua" },
		cpp = { "clang_format" },
		c = { "clang_format" },
		sh = { "shfmt" },
	},

	formatters = {
		clang_format = {
			command = "clang-format",
			args = { "--style=file", "-fallback-style=Google" },
		},
	},
})

require("gitsigns").setup({
	signs = {
		add = { text = "+" },
		change = { text = "~" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
	},
})

vim.lsp.enable({
	"lua_ls",
	"clangd",
	"bash-language-server",
	"pyright",
	"stylua",
	"cmake-language-server",
	"rust-analyzer",
})

require("blink.cmp").setup({
	signature = { enabled = true },
	completion = {
		documentation = { auto_show = true, auto_show_delay_ms = 500 },
		menu = {
			auto_show = true,
			border = "single",
			draw = {
				columns = { { "kind_icon", "label", "label_description", gap = 1 }, { "kind" } },
			},
		},
	},
	fuzzy = { implementation = "prefer_rust_with_warning" },
})

local function pack_clean()
	local active_plugins = {}
	local unused_plugins = {}

	for _, plugin in ipairs(vim.pack.get()) do
		active_plugins[plugin.spec.name] = plugin.active
	end

	for _, plugin in ipairs(vim.pack.get()) do
		if not active_plugins[plugin.spec.name] then
			table.insert(unused_plugins, plugin.spec.name)
		end
	end

	if #unused_plugins == 0 then
		print("No unused plugins.")
		return
	end

	local choice = vim.fn.confirm("Remove unused plugins?", "&Yes\n&No", 2)
	if choice == 1 then
		vim.pack.del(unused_plugins)
	end
end

local map = vim.keymap.set
vim.g.mapleader = " "

-- stylua: ignore start
map("n", "<Leader>ex", "<cmd>Ex %:p:h<CR>")
map("n", "<leader>pc", pack_clean)
map("n", "<leader>lco", lsp_color_off)
map("n", "<leader>ps", "<cmd>lua vim.pack.update()<CR>")
map("n", "<leader>cf", function() require("conform").format({ lsp_format = false }) end)
map("n", "<leader>w", "<Cmd>:update<CR>")
map("n", "<leader>q", "<Cmd>:quit<CR>")
map("n", "<leader>Q", "<Cmd>:wqa<CR>")
map({ "n", "v", "x" }, ";", ":")
map({ "n", "v", "x" }, ":", ";")
map("n", "<leader>zz", function() require("zen-mode").toggle() end)

-- harpoon replacement
map("n", "<leader>a", function() vim.cmd("argadd %") vim.cmd("argdedup") end)
map("n", "<leader>l", function() vim.cmd.args() end)
map("n", "<C-h>", function() vim.cmd("silent! 1argument") end)
map("n", "<C-j>", function() vim.cmd("silent! 2argument") end)
map("n", "<C-k>", function() vim.cmd("silent! 3argument") end)
map("n", "<C-l>", function() vim.cmd("silent! 4argument") end)

local gitsigns = require("gitsigns")
map("n", "<leader>hb", gitsigns.blame_line)
map("n", "<leader>tb", gitsigns.toggle_current_line_blame)

local builtin = require("telescope.builtin")
map("n", "<leader>ff", builtin.find_files)
map("n", "<leader>fg", builtin.live_grep)
map("n", "<leader>fh", builtin.help_tags)
map("n", "<leader>fb", builtin.builtin)
map("n", "<leader>fm", builtin.man_pages)
map("n", "<leader>fr", builtin.lsp_references)
map("n", "<leader><leader>", builtin.buffers)
map("n", "<leader>fc", function() builtin.find_files({ cwd = vim.fn.stdpath("config") }) end)

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "yanking highlight",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.cmd([[nnoremap g= g+| " g=g=g= is less awkward than g+g+g+]])

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("my.lsp", {}),
	callback = function(e)
		-- local client = vim.lsp.get_client_by_id(e.data.client_id)
		-- if client and client.server_capabilities.semanticTokensProvider then
		-- 	client.server_capabilities.semanticTokensProvider = nil
		-- end
    lsp_color_off()

		local opts = { buffer = e.buf }
		map("n", "gd", function() vim.lsp.buf.definition() end, opts)
		map("n", "gD", function() vim.lsp.buf.declaration() end, opts)
		map("n", "gl", function() vim.diagnostic.open_float({ border = "single" }) end, opts)
		map("n", "K", function() vim.lsp.buf.hover({ border = "single" }) end, opts)
		map("n", "<leader>gi", function() vim.lsp.buf.implementation() end, opts)
		map("n", "<leader>sw", function() vim.lsp.buf.workspace_symbol() end, opts)
		map("n", "<leader>ca", function() vim.lsp.buf.code_action() end, opts)
		map("n", "<leader>cr", function() vim.lsp.buf.rename() end, opts)
	end,
})
-- stylua: ignore end
