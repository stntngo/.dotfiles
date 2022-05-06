(module dotfiles.plugins.telescope
  {require {vimp      vimp
            telescope telescope
            builtin   telescope.builtin}})

(telescope.setup 
  {:extensions
   {:fzf {:fuzzy true
          :override_generic_sort true
          :case_mode :smart_case}}})

(telescope.load_extension :fzf)

; In the pre-lua days I used fzf for this sort of functionality.
; So that's where the command naming convention comes from.
(vimp.nnoremap :fzb builtin.buffers)          ; Search buffers
(vimp.nnoremap :fzf builtin.find_files)               ; Search files
(vimp.nnoremap :fzrg builtin.live_grep)       ; Search Lines
(vimp.nnoremap :<leader>Gt builtin.git_stash) ; Search Git Stashes

(vimp.nnoremap 
  :fzd 
  (fn []
    ; TODO: Don't harcode dotfiles path.
    (builtin.fd {:search_dirs ["/Users/niels/.dotfiles"]})))
