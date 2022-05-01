(module dotfiles.plugins.todo
  {require {util dotfiles.util
            todo todo-comments}})

(todo.setup
  {:signs true
   :sign_priority 8
   :keywords
    {:FIX {:icon   " "
           :color  "error"
           :alt [:FIXME :BUG :FIXIT :ISSUE]}
     :TODO {:icon    " "
            :color: "info"}
     :HACK {:icon  " "
            :color "warning"}
     :WARN {:icon  " "
            :color "warning"
            :alt   [:WARNING :XXX]}
     :PERF {:icon " "
            :alt [:OPTIM :PERFORMANCE :OPTIMIZE]}
     :NOTE {:icon  " "
            :color "hint"
            :alt [:INFO]}}
   :merge_keywords true
   :highlight {:before ""
               :keyword :wide
               :after ""
               :pattern ".*<(KEYWORDS)\\s*:"
               :comments_only true}
   :colors {:error   [:DiagnosticError]
            :warning [:DiagnosticWarn]
            :info    [:DiagnosticInfo]
            :hint    [:DiagnosticHint]
            :default [:Identifier]}
   :search {:command :rg
            :args ["--color=never"
                   "--no-heading"
                   "--with-filename"
                   "--line-number"
                   "--column"]
            :pattern "\\b(KEYWORDS):"}})

(util.leadernnoremap :td :TodoTrouble)
