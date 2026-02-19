mkdir -p ~/.config/nvim && cat > ~/.config/nvim/init.lua <<'EOF'
vim.opt.termguicolors=true
vim.cmd("syntax on")
vim.cmd("filetype plugin indent on")

local lazypath=vim.fn.stdpath("data").."/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({"git","clone","--filter=blob:none","https://github.com/folke/lazy.nvim.git",lazypath})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { "folke/tokyonight.nvim", priority=1000, config=function() vim.cmd("colorscheme tokyonight") end },
  { "neovim/nvim-lspconfig" },
  { "williamboman/mason.nvim", config=true },
  { "williamboman/mason-lspconfig.nvim", config=function()
      require("mason-lspconfig").setup({ ensure_installed={"gopls","pyright","bashls"} })
    end },
  { "hrsh7th/nvim-cmp",
    dependencies={ "hrsh7th/cmp-nvim-lsp" },
    config=function()
      local cmp=require("cmp")
      cmp.setup({
        mapping={
          ["<C-Space>"]=cmp.mapping.complete(),
          ["<CR>"]=cmp.mapping.confirm({select=true}),
        },
        sources={{name="nvim_lsp"}},
      })
    end },
})

local caps=require("cmp_nvim_lsp").default_capabilities()
require("lspconfig").gopls.setup({capabilities=caps})
require("lspconfig").pyright.setup({capabilities=caps})
require("lspconfig").bashls.setup({capabilities=caps})
EOF
