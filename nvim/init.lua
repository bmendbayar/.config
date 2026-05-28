local opt = vim.opt
opt.statusline = "%<%f %h%m%r%=%-13a%-13.(%l,%c%V%) %P"
opt.tags = { "./tags", "tags;", "./.tags", vim.fn.expand("~/.systags"), ".tags;" }
opt.guicursor = ""
opt.signcolumn = "yes"
opt.termguicolors = true
opt.ignorecase = true
opt.autoindent = true
opt.smartindent = true
opt.expandtab = true
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.shiftround = true
opt.number = true
opt.relativenumber = false
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
opt.listchars = { space = "·", tab = "» ", trail = "·", nbsp = "␣" }
opt.laststatus = 2

vim.g.netrw_liststyle = 1
vim.g.netrw_sort_by = "size"

vim.pack.add({
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", branch = "main" },
	{ src = "https://github.com/chomosuke/typst-preview.nvim" },
	{ src = "https://github.com/projekt0n/github-nvim-theme" },
	{ src = "https://github.com/blazkowolf/gruber-darker.nvim" },
	{ src = "https://github.com/mrcjkb/rustaceanvim" },
	{ src = "https://github.com/Saghen/blink.cmp" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	{ src = "https://github.com/chentoast/marks.nvim" },
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown", "lua", "rust", "typst", "python", "bash" },
	callback = function()
		vim.treesitter.start()
	end,
})

require("marks").setup({
	builtin_marks = { "<", ">", "^" },
})

require("typst-preview").setup({})

require("gruber-darker").setup({
	italic = {
		strings = false,
		comments = false,
		operators = false,
		folds = false,
	},
})

local highlights_to_keep = {
	["@keyword"] = true,
	["@keyword.repeat"] = true,
	["@keyword.function"] = true,
	["@keyword.return"] = true,
	["@keyword.operator"] = true,
	["@string"] = true,
	["@character"] = true,
	["@comment"] = true,
	["@spell"] = true,
	["@markup"] = true,
	["@markup.heading"] = true,
}

local function minimal_colors()
	local highlights = vim.api.nvim_get_hl(0, {})
	for name, _ in pairs(highlights) do
		if name:sub(1, 1) == "@" then
			if not highlights_to_keep[name] then
				vim.api.nvim_set_hl(0, name, { link = "NONE", force = true })
			end
		end
	end

	vim.api.nvim_set_hl(0, "Number", { link = "NONE" })
	vim.api.nvim_set_hl(0, "@markup.raw.block.markdown", { link = "NormalFloat" })
	vim.api.nvim_set_hl(0, "cppStorageClass", { link = "Keyword" })
	vim.api.nvim_set_hl(0, "@type.builtin", { link = "Type" })
	vim.api.nvim_set_hl(0, "@type.definition", { link = "Type" })
	vim.api.nvim_set_hl(0, "@constant", { link = "NONE" })
	vim.api.nvim_set_hl(0, "Folded", { bg = "NONE", fg = "#505050", bold = true })
	vim.api.nvim_set_hl(0, "Whitespace", { bg = "NONE", fg = "#353535" })
end

vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		minimal_colors()
	end,
})

vim.cmd.colorscheme("gruber-darker")

local actions = require("telescope.actions")
require("telescope").setup({
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
		rs = { "cargo-fmt" },
		typst = { "typstyle" },
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

vim.lsp.config("clangd", {
	cmd = { "clangd", "--clang-tidy", "--background-index", "--header-insertion=never" },
	filetypes = { "c", "h", "hpp", "cpp" },
})

vim.lsp.config("pyright", {
	cmd = { "pyright-langserver", "--stdio" },
	filetypes = { "python" },
})

vim.lsp.config("ruff", {
	cmd = { "ruff", "server" },
	filetypes = { "python" },
})

vim.lsp.config("lua_ls", {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = {
		".luarc.json",
		".luarc.jsonc",
		".luacheckrc",
		".stylua.toml",
		"stylua.toml",
		"selene.toml",
		"selene.yml",
		".git",
	},
})

vim.lsp.config("bash-language-server", {
	cmd = { "bash-language-server", "start" },
	filetypes = { "sh", "bash" },
})

vim.lsp.config("neocmakelsp", {
	cmd = { "neocmakelsp", "--stdio" },
	filetypes = { "cmake" },
})

local function create_tinymist_command(command_name, client, bufnr)
	local cmd_display = command_name:match("tinymist%.export(%w+)")
	local function run_tinymist_command()
		local arguments = { vim.api.nvim_buf_get_name(bufnr) }
		return client:exec_cmd({
			title = "Export " .. cmd_display,
			command = command_name,
			arguments = arguments,
		}, { bufnr = bufnr })
	end
	return run_tinymist_command, ("Export" .. cmd_display), ("Export to " .. cmd_display)
end

vim.lsp.config("tinymist", {
	cmd = { "tinymist" },
	filetypes = { "typst" },
	root_markers = { ".git" },
	on_attach = function(client, bufnr)
		for _, command in ipairs({
			"tinymist.exportSvg",
			"tinymist.exportPng",
			"tinymist.exportPdf",
			"tinymist.exportHtml",
			"tinymist.exportMarkdown",
		}) do
			local cmd_func, cmd_name, cmd_desc = create_tinymist_command(command, client, bufnr)
			vim.api.nvim_buf_create_user_command(bufnr, cmd_name, cmd_func, { nargs = 0, desc = cmd_desc })
		end
	end,
})

vim.lsp.enable({ "lua_ls", "clangd", "bash-language-server", "pyright", "ruff", "neocmakelsp", "tinymist" })

vim.diagnostic.config({ underline = false })

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
map("n", "<leader>ps", "<cmd>lua vim.pack.update()<CR>")
map("n", "<leader>cf", function() require("conform").format({ lsp_format = false }) end)
map("n", "<leader>w", "<cmd>:update<CR>")
map("n", "<leader>q", "<cmd>:quit<CR>")
map("n", "<leader>Q", "<cmd>:wqa<CR>")
map({ "n", "v", "x" }, ";", ":")
map({ "n", "v", "x" }, ":", ";")
map('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- harpoon replacement
map("n", "<leader>a", function() vim.cmd("argadd %") vim.cmd("argdedup") end)
map("n", "<leader>d", function() vim.cmd("argd %") end)
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
map("n", "gd", "<C-]>")
map("n", "gD", function() vim.lsp.buf.declaration() end)
map("n", "<leader>gi", function() vim.lsp.buf.implementation() end)
map("n", "gr", vim.lsp.buf.references)
map("n", "gl", function() vim.diagnostic.open_float({ border = "single" }) end)
map("n", "K", function() vim.lsp.buf.hover({ border = "single" }) end)
map("n", "<leader>sw", function() vim.lsp.buf.workspace_symbol() end)
map("n", "<leader>ca", function() vim.lsp.buf.code_action() end)
map("n", "<leader>cr", function() vim.lsp.buf.rename() end)
vim.cmd([[nnoremap g= g+| " g=g=g= is less awkward than g+g+g+]])
-- stylua: ignore end

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "yanking highlight",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("my.lsp", {}),
	callback = function(e)
		local client = vim.lsp.get_client_by_id(e.data.client_id)
		if not client then
			return
		end

		client.server_capabilities.semanticTokensProvider = nil

		-- local caps_to_disable = {
		-- 	"documentFormattingProvider",
		-- 	"documentRangeFormattingProvider",
		-- 	"hoverProvider",
		-- 	"renameProvider",
		-- 	"completionProvider",
		-- 	"codeActionProvider",
		-- 	"diagnosticProvider",
		-- }
		--
		-- for _, cap in ipairs(caps_to_disable) do
		-- 	client.server_capabilities[cap] = false
		-- end
		--
		-- local opts = { buffer = e.buf }
		-- vim.diagnostic.enable(false, { bufnr = e.buf })
	end,
})
