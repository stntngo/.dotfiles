(module dotfiles.plugins.nvimterminal
  {require {nvim aniseed.nvim
            term nvim-terminal}})

(set nvim.o.hidden true)

(term.setup
  {:window        {:position :botright}
   :toggle_keymap :<leader>$})
