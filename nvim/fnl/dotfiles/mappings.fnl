(module dotfiles.mappings
  {require {nvim aniseed.nvim
           core aniseed.core}})

(defn noremap [mode from to]
  (nvim.set_keymap mode from to {:noremap true}))

(set nvim.g.mapleader ",")
(set nvim.g.maplocalleader "\\")

(noremap :t :<esc> :<c-\><c-n>)
(noremap :t :jj :<c-\><c-n>) 
(noremap :i :jj :<esc>)
(noremap :n :<leader><space> "<cmd>noh<cr>")

; NOTE: I'm going to comment this out. The remapping of the arrow keys to <nop> is something left over from when I was just learning vim and wanted to avoid using the arrow keys.
; (core.run! (fn [dir]
;              (core.run! (fn [mode]
;                           (noremap mode dir :<nop>))
;                         [:n :i :t])
;              (noremap :t (.. :<shift> dir) dir)
;              [:<up> :<down> :<left> :<right>]))
