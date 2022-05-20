(module dotfiles.plugins.taskwarrior
  {require {terminal   toggleterm.terminal}})

(local
  taskwarrior
  (terminal.Terminal:new
    {:cmd :taskwarrior-tui
     :direction :float
     :on_open (fn [term]
                  (vim.cmd :startinsert!))
     :hidden true}))

(vim.keymap.set 
  [:n :t]
  :<leader>T
  #(taskwarrior:toggle))
