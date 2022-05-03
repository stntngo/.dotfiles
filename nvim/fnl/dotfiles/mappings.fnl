(module dotfiles.mappings
  {require {nvim aniseed.nvim
            vimp vimp
            core aniseed.core}})

(set nvim.g.mapleader ",")
(set nvim.g.maplocalleader "\\")


(vimp.tnoremap :<esc> :<c-\><c-n>)
(vimp.tnoremap :jj :<c-\><c-n>)
(vimp.inoremap :jj :<esc>)
(vimp.nnoremap :<leader><space> "<cmd>noh<cr>")

(vimp.nnoremap :<leader>u :<cmd>UndotreeToggle<cr>)
(set nvim.g.undotree_SetFocusWhenToggle 1)
(set nvim.g.undotree_WindowLayout 2)
