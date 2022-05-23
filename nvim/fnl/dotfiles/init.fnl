(module dotfiles.init
  {require {core aniseed.core}})

(->> [:dotfiles.core
      :dotfiles.mappings
      :dotfiles.plugins.init]
     (core.run! require))
