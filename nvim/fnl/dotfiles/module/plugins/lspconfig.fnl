(module dotfiles.module.plugins.lspconfig
  {autoload {util dotfiles.util
             core aniseed.core
             nvim aniseed.nvim}})

(defn- define-sign [[sev text]]
    (vim.fn.sign_define sev {:texthl sev :text text :numhl sev}))

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

; Set up the lsp configurations. For some reason I've wrapped only the require for the call
; to require for loading lspconfig in pcall but literally no other call to require.
(let [(ok? lsp) (pcall #(require :lspconfig))
      cmp_nvim_lsp (require :cmp_nvim_lsp)
      capabilities (-> (vim.lsp.protocol.make_client_capabilities)
                       cmp_nvim_lsp.update_capabilities)]
  (when ok?
    (lsp.gopls.setup
      {:name :gopls
       :cmd ["gopls" "-remote=auto" "serve"]
       :init_options {:gofumpt true
                      :staticcheck true
                      :memoryMode :DegradeClosed}
       :whitelist [:go]
       :capabilities capabilities
       :on_attach on-attach})

    (lsp.rust_analyzer.setup
      {:name :rust_analyzer
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
       :cmd ["clangd"]
       :whitelist [:c :cpp :objc :objcpp]
       :capabilities capabilities
       :on_attach on-attach})

    (lsp.clojure_lsp.setup
      {:name :clojure_lsp
       :cmd ["clojure-lsp"]
       :whitelist [:clojure :edn]
       :capabilities capabilities
       :on_attach on-attach})

    (lsp.bashls.setup
      {:name :bashls
       :cmd ["bash-language-server" "start"]
       :whitelist [:sh]
       :capabilities capabilities
       :on_attach on-attach})

    (lsp.zls.setup
      {:name :zls
       :cmd ["zls"]
       :whitelist [:zls :zir]
       :capabilities capabilities
       :on_attach on-attach})
    
    (lsp.pyright.setup
      {:name :pyright
       :cmd ["pyright-langserver" "--stdio"]
       :whitelist [:python]
       :capabilities capabilities
       :on_attach on-attach})

    (lsp.tsserver.setup
      {:name :tsserver
       :cmd ["typescript-language-server" "--stdio"]
       :whitelist [:javascript :javascriptreact :javascript.jsx :typescript :typescriptreact :typescript.tsx]
       :init_options {:hostInfo :neovim}
       :capabilities capabilities
       :on_attach on-attach})

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
                   "*.jsx"]
         :command "lua vim.lsp.buf.formatting()"
         :group group}))

    (vim.diagnostic.config
      {:virtual_text {:prefix "●"}})

    (->> [[:DiagnosticSignError ""]
          [:DiagnosticSignWarn  ""]
          [:DiagnosticSignHint  ""]
          [:DiagnosticSignInfo  ""]]
         (core.run! define-sign))))

(let [(ok? fidget) (pcall #(require :fidget))]
  (when ok?
    (fidget.setup
      {:text {:spinner :dots}})))

; TODO (niels): I want to set up an abstraction
; for safely requiring packages. So that it sends
; a message to me when it fails to load rather 
; than just doing throwing a red-background error
; when things crash.
(let [cmp (require :cmp)
      luasnip (require :luasnip)]

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
                 {:name :cmdline}])}))
