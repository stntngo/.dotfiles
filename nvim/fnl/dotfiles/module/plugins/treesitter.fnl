(module dotfiles.module.plugins.treesitter)

(let [treesitter (require "nvim-treesitter.configs")]
  (treesitter.setup
    {:ensure_installed :all
     :highlight {:enable true
                 :additional_vim_regex_highlighting false}
     :playground
      {:enable true
       :disable []
       :updatetime 25
       :persist_queries false
       :keybindings
        {:toggle_query_editor :o
         :toggle_hl_groups :i
         :toggle_injected_languages :t
         :toggle_anonymous_nodes :a
         :toggle_language_display :I
         :focus_language :f
         :unfocus_language :F
         :update :R
         :goto_node :<cr>
         :show_help :?}}}))
