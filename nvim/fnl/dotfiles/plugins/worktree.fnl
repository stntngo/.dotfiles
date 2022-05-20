(module dotfiles.plugins.worktree
  {require {worktree :git-worktree}})

(worktree.setup
  {:change_directory_command :cd
   :update_on_change         true
   :update_on_change_command "e ."
   :clearjumps_on_change     true
   :autopush                 false})
