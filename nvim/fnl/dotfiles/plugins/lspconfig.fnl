(module dotfiles.plugins.lspconfig
  {require {core aniseed.core
            nvim aniseed.nvim
            lsp lspconfig
            cmp cmp
            luasnip luasnip
            cmp_nvim_lsp cmp_nvim_lsp}})

; Set up per-buffer configuration for the LSP. Right now everything uses the 
; same configuration but there's no reason that will remain true into the future.
(defn on-attach [client bufnr]
  (let [opts {:noremap true :silent true}
        buf-set-keymap (fn [from scope to]
                         (nvim.buf_set_keymap 
                           bufnr 
                           :n 
                           from 
                           (.. "<cmd>lua vim.lsp." scope "." to "()<cr>")
                           opts))
        buf-set-option (fn [key val]
                         (nvim.buf_set_option bufnr key val))]

    (buf-set-option :omnifunc "v:lua.vim.lsp.omnifunc")

    (buf-set-keymap :gd :buf :definition)
    (buf-set-keymap :gD :buf :declaration)
    (buf-set-keymap :gr :buf :references)
    (buf-set-keymap :gi :buf :implementation)
    (buf-set-keymap :K :buf :hover)
    (buf-set-keymap :<c-k> :buf :signature_help)
    (buf-set-keymap :<leader>rn :buf :rename)
    (buf-set-keymap :<leader>lf :buf :formatting)

    (nvim.buf_set_keymap bufnr :n :<c-n> "<cmd>lua vim.diagnostic.goto_prev()<cr>" opts)
    (nvim.buf_set_keymap bufnr :n :<c-p> "<cmd>lua vim.diagnostic.goto_next()<cr>" opts)))

; Define the common capabilities of the nvim lsp client in order to provide the
; LSP servers with all of the features the native nvim client is capable of
; supporting
(local capabilities (-> (vim.lsp.protocol.make_client_capabilities)
                        cmp_nvim_lsp.update_capabilities))

(lsp.gopls.setup
  {:name :gopls
   ; WARN: gopls binary not managed by dotbot.
   :cmd ["gopls" "-remote=auto" "serve"]
   :init_options {:gofumpt true
                  :staticcheck true
                  :memoryMode :DegradeClosed}
   :whitelist [:go]
   :capabilities capabilities
   :on_attach on-attach})

(lsp.rust_analyzer.setup
  {:name :rust_analyzer
   ; WARN: rust-analyzer binary not managed by dotbot.
   :cmd ["rustup" "run" "nightly" "rust-analyzer"]
   :settings {:rust-analyzer
              {:assist {:importGranularity "module"
                        :importPrefix "self"
                        :formatOnSave true}
               :cargo {:loadOutDirsFromCheck true}
               :procMacro {:enable true}}}
   :whitelist [:rust]
   :capabilities capabilities
   :on_attach on-attach})

(lsp.elixirls.setup
  {:name :elixirls
   :cmd ["elixir-ls"]
   :whitelist [:elixir]
   :capabilities capabilities
   :on_attach on-attach})

(lsp.clangd.setup
  {:name :clangd
   ; WARN: clangd binary not managed by dotbot.
   :cmd ["clangd"]
   :whitelist [:c :cpp :objc :objcpp]
   :capabilities capabilities
   :on_attach on-attach})

(lsp.clojure_lsp.setup
  {:name :clojure_lsp
   ; WARN: clojure-lsp not managed by dotbot.
   :cmd ["clojure-lsp"]
   :whitelist [:clojure :edn :fennel]
   :capabilities capabilities
   :on_attach on-attach})

(lsp.bashls.setup
  {:name :bashls
   ; WARN: bashls not managed by dotbot.
   :cmd ["bash-language-server" "start"]
   :whitelist [:sh]
   :capabilities capabilities
   :on_attach on-attach})

(lsp.zls.setup
  {:name :zls
   ; WARN: zls not managed by dotbot.
   :cmd ["zls"]
   :whitelist [:zls :zir]
   :capabilities capabilities
   :on_attach on-attach})

(lsp.pyright.setup
  {:name :pyright
   :cmd ["pyright-langserver" "--stdio"]
   :whitelist [:python]
   :settings {:python {:analysis {:extraPaths ["/Users/niels/.dotfiles/dotbot"]}}}
   :capabilities capabilities
   :on_attach on-attach})

(lsp.tsserver.setup
  {:name :tsserver
   :cmd ["typescript-language-server" "--stdio"]
   :whitelist [:javascript :javascriptreact :javascript.jsx :typescript :typescriptreact :typescript.tsx]
   :init_options {:hostInfo :neovim}
   :capabilities capabilities
   :on_attach on-attach})

; efm-langserver is a generic language server that can run any
; commands when responding to specific LSP API calls. It provides
; a nice interface for adding document formatting and extra linters
; that aren't bundled into a language's LSP already.
(lsp.efm.setup
  {:name :efm
   :init_options {:documentFormatting true}
   :whitelist [:python]
   :capabilities capabilities
   :on_attach on-attach
   :settings
    {:rootMarkers [".git/"]
     :version 2
     :lintDebounce 1000
     :languages {:python 
                 [{:formatCommand "black --fast -"
                   :formatStdin true}]}}})

(let [group (nvim.create_augroup
              :language-server
              {:clear true})]
  (nvim.create_autocmd
    :BufWrite
    {:pattern ["*.go"
               "*.rs"
               "*.ex"
               "*.exs"
               "*.c"
               "*.h"
               "*.clj"
               "*.edn"
               "*.sh"
               "*.zig"
               "*.ts"
               "*.tsx"
               "*.js"
               "*.jsx"
               "*.py"]
     :command "lua vim.lsp.buf.formatting_sync(nil, 500)"
     :group group}))

(vim.diagnostic.config
  {:virtual_text {:prefix "●"}})

(->> [[:DiagnosticSignError " "]
      [:DiagnosticSignWarn  " "]
      [:DiagnosticSignHint  " "]
      [:DiagnosticSignInfo  " "]]
     (core.run!
       (fn [[sev text]]
         (vim.fn.sign_define sev {:texthl sev :text text :numhl sev}))))

(cmp.setup
  {:snippet {:expand (fn [args] (luasnip.lsp_expand args.body))}
   :preselect cmp.PreselectMode.None
   :window {}
   :mapping (cmp.mapping.preset.insert
              {:<c-b> (cmp.mapping.scroll_docs -4)
               :<c-f> (cmp.mapping.scroll_docs 4)
               :<tab> (cmp.mapping.select_next_item)
               :<s-tab> (cmp.mapping.select_prev_item)
               :<c-space> (cmp.mapping.complete)
               :<c-e> (cmp.mapping.abort)
               :<cr> (cmp.mapping.confirm {:select true})})
   :sources (cmp.config.sources
              [{:name :nvim_lsp}
               {:name :luasnip}
               {:name :conjure}
               {:name :buffer}])})

(set nvim.g.completeopt "menu,menuone,noselect")

(cmp.setup.filetype
  "gitcommit"
  [{:name :cmp_git}
   {:name :buffer}])

(cmp.setup.cmdline
  "/"
  {:mapping (cmp.mapping.preset.cmdline)
   :sources [{:name :buffer}]})

(cmp.setup.cmdline
  ":"
  {:mapping (cmp.mapping.preset.cmdline)
   :sources (cmp.config.sources
              [{:name :path}
               {:name :cmdline}])})
