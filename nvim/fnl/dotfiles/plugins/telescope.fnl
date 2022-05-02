(module dotfiles.plugins.telescope
  {require {vimp      vimp
            telescope telescope.builtin}})

; In the pre-lua days I used fzf for this sort of functionality.
; So that's where the command naming convention comes from.

(vimp.nnoremap :fzb telescope.buffers)     ; Search buffers
(vimp.nnoremap :fzf telescope.fd)          ; Search files
(vimp.nnoremap :fzrg telescope.live_grep)  ; Search Lines
