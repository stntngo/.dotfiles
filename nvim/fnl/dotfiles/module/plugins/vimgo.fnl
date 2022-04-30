(module dotfiles.module.plugins.vimgo
  {require {core aniseed.core
            nvim aniseed.nvim}})

(if (not (core.nil? (nvim.fn.getenv "GO_BIN_PATH")))
  (set nvim.g.go_bin_path (nvim.fn.getenv "GO_BIN_PATH")))

(set nvim.g.go_gopls_enabled 0)
(set nvim.g.go_metaliner_command "gopls")
(set nvim.g.go_def_mapping_enabled 0)
(set nvim.g.go_doc_keywordprg_enabled 0)
(set nvim.g.go_fmt_autosave 0)
