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
  (let [opts           {:noremap true :silent true :buffer bufnr}]

    (nvim.buf_set_option bufnr :omnifunc "v:lua.vim.lsp.omnifunc")

    (vim.keymap.set :n :gd vim.lsp.buf.definition opts)
    (vim.keymap.set :n :gD vim.lsp.buf.declaration opts)
    (vim.keymap.set :n :gr vim.lsp.buf.references opts)
    (vim.keymap.set :n :gi vim.lsp.buf.implementation opts)
    (vim.keymap.set :n :K  vim.lsp.buf.hover opts)
    (vim.keymap.set :n :<c-k> vim.lsp.buf.signature_help opts)
    (vim.keymap.set :n :<leader>rn vim.lsp.buf.rename opts)
    (vim.keymap.set :n :<leader>lf vim.lsp.buf.formatting opts)

    (vim.keymap.set :n :<c-n> vim.diagnostic.goto_prev opts)
    (vim.keymap.set :n :<c-p> vim.diagnostic.goto_next opts)))

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
; (lsp.efm.setup
;   {:name :efm
;    :init_options {:documentFormatting true}
;    :whitelist [:python]
;    :capabilities capabilities
;    :on_attach on-attach
;    :settings
;     {:rootMarkers [".git/"]
;      :version 2
;      :lintDebounce 1000
;      :languages {:python 
;                  [{:formatCommand "black --fast -"
;                    :formatStdin true}]}}})

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
