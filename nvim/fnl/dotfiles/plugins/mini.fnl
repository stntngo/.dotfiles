(module dotfiles.plugins.mini
  {require {core     aniseed.core
            sessions mini.sessions
            starter  mini.starter
            vimp     vimp}})

(sessions.setup
  {:autowrite true})

; <leader>ss prompts the user for a session name and stores the current
; session in the configured session directory under the given name.
(vimp.nnoremap
  :<leader>ss
  (fn []
    (vim.ui.input
      {:prompt "Enter new session name: "}
      sessions.write)))

; <leader>so prompts the user to select a session from the list of
; detected sessions. The selected session is loaded into the current
; window.
(vimp.nnoremap
  :<leader>so
  (fn []
    (vim.ui.select
      (core.keys sessions.detected)
      {:prompt "Select session to load:"}
      (fn [choice]
        (when choice
          (sessions.read choice))))))

(starter.setup {})
