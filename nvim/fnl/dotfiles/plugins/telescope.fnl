(module dotfiles.plugins.telescope
  {require {vimp      vimp
            builtin   telescope.builtin}})

; In the pre-lua days I used fzf for this sort of functionality.
; So that's where the command naming convention comes from.
(vimp.nnoremap :fzb builtin.buffers)          ; Search buffers
(vimp.nnoremap :fzf builtin.fd)               ; Search files
(vimp.nnoremap :fzrg builtin.live_grep)       ; Search Lines
(vimp.nnoremap :<leader>Gt builtin.git_stash) ; Search Git Stashes

(vimp.nnoremap 
  :fzd 
  (fn []
    ; TODO: Don't harcode dotfiles path.
    (builtin.fd {:search_dirs ["/Users/niels/.dotfiles"]})))
