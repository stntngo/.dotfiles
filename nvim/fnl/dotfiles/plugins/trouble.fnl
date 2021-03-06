(module dotfiles.trouble
  {require {util dotfiles.util
            nvim aniseed.nvim
            trouble trouble}})

(trouble.setup
  {:mode :document_diagnostics
   :icons false})

(util.leadernnoremap :xx "TroubleToggle")
(util.leadernnoremap :xw "TroubleToggle workspace_diagnostics")
(util.leadernnoremap :xd "TroubleToggle document_diagnostics")
(util.leadernnoremap :xq "TroubleToggle quickfix")
(util.leadernnoremap :xl "TroubleToggle loclist")
(util.nnoremap :gR "TroubleToggle lsp_references")
