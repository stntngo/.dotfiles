(module dotfiles.plugins.mini
  {require {core     aniseed.core
            sessions mini.sessions
            starter  mini.starter
            vimp     vimp}})

(sessions.setup
  {:autowrite true})

(vimp.nnoremap
  :<leader>ss
  (fn []
    (vim.ui.input
      {:prompt "Enter new session name: "}
      sessions.write)))

(vimp.nnoremap
  :<leader>so
  (fn []
    (vim.ui.select
      (core.keys sessions.detected)
      {:prompt "Select session to load:"}
      (fn [choice]
        (sessions.read choice)))))

(starter.setup {})
