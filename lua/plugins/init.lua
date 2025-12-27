return {
	"mavantgarderc/raphael.nvim",
	"mavantgarderc/prismpunk.nvim",
	"mavantgarderc/conscious.nvim",
	-- ==================================================
	-- === ui ===
	-- Oil file explorer
	"stevearc/oil.nvim",
	-- status line & tabbar
	"nvim-lualine/lualine.nvim",
	-- startup dashboard
	"goolord/alpha-nvim",
	-- text coloring
	"echasnovski/mini.hipatterns",
	-- themes
	"RRethy/base16-nvim",
	"catppuccin/nvim",
	"folke/tokyonight.nvim",
	-- "ellisonleao/gruvbox.nvim",
	"EdenEast/nightfox.nvim",
	-- "rebelot/kanagawa.nvim",
	-- "thesimonho/kanagawa-paper.nvim",
	"nyoom-engineering/oxocarbon.nvim",
	"everviolet/nvim",
	-- ==================================================
	-- === LSP ===
	{
		"VonHeikemen/lsp-zero.nvim",
		branch = "v3.x",
		dependencies = {
			-- LSP Core
			"neovim/nvim-lspconfig",
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			-- Autocompletion Core
			"hrsh7th/nvim-cmp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lua",
			"saadparwaiz1/cmp_luasnip",
			{
				"Hoffs/omnisharp-extended-lsp.nvim",
				lazy = true,
			},
			-- Dev Enhancements
			{
				"folke/lazydev.nvim",
				ft = "lua",
				opts = {
					library = {
						{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
					},
				},
			},
			-- dadbod
			"tpope/vim-dadbod",
			"kristijanhusak/vim-dadbod-completion",
			"kristijanhusak/vim-dadbod-ui",
			"tpope/vim-dotenv",
			"nanotee/sqls.nvim",
			-- Utilities
			-- indent automation; no config needed
			"NMAC427/guess-indent.nvim",
			-- Snippets
			"L3MON4D3/LuaSnip",
			"rafamadriz/friendly-snippets",
			--
			"j-hui/fidget.nvim",
			--
			"stevearc/conform.nvim",
		},
	},
	-- === other plugins ===
	"windwp/nvim-autopairs",
	"epwalsh/obsidian.nvim",
	"lervag/vimtex",
	"MunifTanjim/nui.nvim",
	"nvim-treesitter/nvim-treesitter",
	"nvim-telescope/telescope.nvim",
	"mbbill/undotree",
	"lewis6991/gitsigns.nvim",
	"folke/flash.nvim",
	"mistweaverco/snap.nvim",
  "christoomey/vim-tmux-navigator",
  -- "swaits/zellij-nav.nvim",
}
