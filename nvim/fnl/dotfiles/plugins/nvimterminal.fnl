(module dotfiles.plugins.nvimterminal
  {require {nvim aniseed.nvim}})

(let [term (require :nvim-terminal)]
  (set nvim.o.hidden true)

  (term.setup
    {:window {:position :botright}}))
