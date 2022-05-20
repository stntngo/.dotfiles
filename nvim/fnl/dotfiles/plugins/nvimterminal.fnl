(module dotfiles.plugins.nvimterminal
  {require {nvim aniseed.nvim
            term toggleterm.terminal}})

(local 
  terminal 
  (term.Terminal:new
    {:direction :float
     :on_open (fn [term]
                (vim.keymap.set :t :jj :<c-\><c-n>))
     :hidden true}))

(vim.keymap.set
  [:n :t]
  :<leader>$
  #(terminal:toggle))
