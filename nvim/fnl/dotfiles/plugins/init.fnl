(module dotfiles.plugins.init
  {require {core aniseed.core}})

(->> [:bufferline
      :dap
      :fugitive
      :lspconfig
      :lualine
      :mini
      :nvimterminal
      :phabricator
      :taskwarrior
      :telescope
      :todo
      :treesitter
      :trouble
      :vimgo
      :worktree]
     (core.run! (fn [package] (require (.. :dotfiles.plugins. package)))))
