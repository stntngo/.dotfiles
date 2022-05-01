(module dotfiles.plugins.mini
  {require {core aniseed.core
            sessions mini.sessions
            vimp vimp}})

(sessions.setup
  {:autoread true
   :autowrite true})

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
