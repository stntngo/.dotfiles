(module dotfiles.plugins.telescope
  {require {telescope telescope
            builtin   telescope.builtin}})

(telescope.setup 
  {:extensions
   {:fzf {:fuzzy true
          :override_generic_sort true
          :case_mode :smart_case}}})

(telescope.load_extension :fzf)

; In the pre-lua days I used fzf for this sort of functionality.
; So that's where the command naming convention comes from.
(vim.keymap.set :n :fzb builtin.buffers)          ; Search buffers
(vim.keymap.set :n :fzf builtin.find_files)       ; Search files
(vim.keymap.set :n :fzrg builtin.live_grep)       ; Search Lines

(vim.keymap.set :n 
  :fzd 
  (fn []
    ; TODO: Don't harcode dotfiles path.
    (builtin.fd {:search_dirs ["/Users/niels/.dotfiles"]})))
