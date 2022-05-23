(module dotfiles.plugins.fugitive
  {require {util dotfiles.util}})

;; <leader>G opens fugitive buffer.
; TODO: Remove pointless utility call.
(util.leadernnoremap :G "G")
