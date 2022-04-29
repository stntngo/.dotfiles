(module dotfiles.module.plugins.fugitive
  {require {util dotfiles.util}})

;; <leader>G opens fugitive buffer.
(util.leadernnoremap :G "G")

;; <Leader>Ga stages current buffer in
;; git repository.
(util.leadernnoremap :Ga "G add %")

;; <Leader>Gd shows current diff.
(util.leadernnoremap :Gd "Gdiff")

;; <Leader>Gb shows git blame of
;; current buffer.
(util.leadernnoremap :Gb "G blame")

;; <Leader>Gc creates a new commit.
(util.leadernnoremap :Gc "G commit --verbose")

;; <Leader>GC amends changes to the previous commit.
(util.leadernnoremap :GC "G commit --amend")
