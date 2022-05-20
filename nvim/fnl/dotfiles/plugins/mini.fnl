(module dotfiles.plugins.mini
  {require {core     aniseed.core
            sessions mini.sessions
            starter  mini.starter
            surround mini.surround}})

(sessions.setup
  {:autowrite true})

(surround.setup {})

; <leader>ss prompts the user for a session name and stores the current
; session in the configured session directory under the given name.
(vim.keymap.set :n
  :<leader>ss
  (fn []
    (vim.ui.input
      {:prompt "Enter new session name: "}
      sessions.write)))

; <leader>so prompts the user to select a session from the list of
; detected sessions. The selected session is loaded into the current
; window.
(vim.keymap.set :n
  :<leader>so
  (fn []
    (vim.ui.select
      (core.keys sessions.detected)
      {:prompt "Select session to load:"}
      (fn [choice]
        (when choice
          (sessions.read choice))))))

; TODO: I don't like the default searching functionality for the starter
; page. I'd like to eventually use the starter page with my own
; configuration but as of right now I don't like what it has to offer.
; (starter.setup {})
