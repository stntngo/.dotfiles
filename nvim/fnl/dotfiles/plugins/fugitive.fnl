(module dotfiles.plugins.fugitive
  {require {util dotfiles.util
            nvim aniseed.nvim}})

;; <leader>G opens fugitive buffer.
; TODO: Remove pointless utility call.
(util.leadernnoremap :G "G")

; As far as I can tell, fugitive doesn't have a "toggle" functionality.
; And I also don't have a fully functional ftplugin setup with fennel,
; so for the time being I create an autocmd that will close the
; fugitive buffer with the same keymapping that opens it.
(let [group (nvim.create_augroup
              :fugitive-user
              {:clear true})]
  (nvim.create_autocmd
    :FileType
    {:pattern  :fugitive
     :callback (fn [info]
                 (vim.keymap.set :n :<leader>G ":bd<cr>" {:buffer info.buf}))}))
