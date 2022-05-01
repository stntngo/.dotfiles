(module dotfiles.plugins.treesitter
  {require {colors* dotfiles.colors
            core    aniseed.core
            treesitter nvim-treesitter.configs
            nvim    aniseed.nvim}})

(local colors colors*.colors)

(local highlights
  [])

; NOTE: I'm thinking maybe at some point I want to stray from
; the default syntax highlighting configuration for iceberg, but man
; this is some tedious work. And I don't really feel like going through
; each setting nor do I feel exceptionally confident in the choices I'm
; making. So we'll put this on the back burner and fiddle with it some
; other time.
;
;   [[:TSAttribute colors.magenta]
;    [:TSBoolean  colors.violet]
;    [:TSCharacter colors.violet]
;    [:TSCharacterSpecial colors.violet]
;    [:TSComment colors.comment]
;    [:TSConditional colors.blue]
;    [:TSConstant colors.violet]
;    [:TSConstBuiltin colors.violet]
;    [:TSConstMacro colors.violet]
;    [:TSDebug colors.orange]
;    [:TSDefine colors.green]
;    [:TSError colors.red]
;    [:TSException colors.violet]
;    [:TSField colors.violet]
;    [:TSFloat colors.violet]
;    [:TSFunction colors.cyan]
;    [:TSFuncBuiltIn colors.green]
;    [:TSMethod colors.darkblue]])

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
       :show_help :?}}})

(core.run!
  (fn [[group color]]
    (vim.highlight.create group {:guifg color}))
    highlights)
