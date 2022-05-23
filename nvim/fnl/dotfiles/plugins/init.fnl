(module dotfiles.plugins.init
  {require {core aniseed.core}})

(->> [:vimgo
      :telescope
      :nvimterminal
      :lspconfig
      :fugitive
      :trouble
      :lualine
      :bufferline
      :treesitter
      :todo
      :dressing
      :phabricator
      :worktree
      :mini
      :taskwarrior
      :dap]
     (core.run! (fn [package] (require (.. :dotfiles.plugins. package)))))
