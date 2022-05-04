(module dotfiles.mappings
  {require {nvim aniseed.nvim
            vimp vimp
            core aniseed.core}})

(set nvim.g.mapleader ",")
(set nvim.g.maplocalleader "\\")

; Both <esc> and jk will pop the terminal back out to normal mode
(vimp.tnoremap :<esc> :<c-\><c-n>)
(vimp.tnoremap :jk :<c-\><c-n>)

; jj in insert mode for quickly getting back to normal mode. 
(vimp.inoremap :jj :<esc>)

; <leader><space> will clear any potential highlights from the buffers.
(vimp.nnoremap :<leader><space> "<cmd>noh<cr>")

; <leader>u will toggle the undotree buffer on the left side of the window. 
; The cursor will focus the newly created buffer if the toggle action shows
; the buffer.
(vimp.nnoremap :<leader>u :<cmd>UndotreeToggle<cr>)
(set nvim.g.undotree_SetFocusWhenToggle 1)
(set nvim.g.undotree_WindowLayout 2)
