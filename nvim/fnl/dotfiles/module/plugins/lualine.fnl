(module dotfiles.module.plugins.lualine
  {require {core aniseed.core
            nvim aniseed.nvim}})

; Lualine configuration largerly inpsired by the Eviline config 
; from the lualine example docs
; Author: shadmansaleh
; Credit: glepnir

(local colors
  {:bg       "#1e2132"
   :fg       "#c6c8d1"
   :yellow   "#e2a478"
   :cyan     "#008080"
   :darkblue "#91acd1"
   :green    "#bfbe82"
   :orange   "#e9b189"
   :violet   "#ada0d3"
   :magenta  "#a093c7"
   :blach    "#161821"
   :blue     "#8fa0c6"
   :red      "#e27878"})

(local mode-color
  {:n colors.red
   :i colors.green
   :v colors.blue
   "" colors.blue
   :V colors.blue
   :c colors.magenta
   :no colors.red
   :s colors.orang
   :S colors.orange
   "" colors.orange
   :ic colors.yellow
   :R colors.violet
   :Rv colors.violet
   :cv colors.red
   :ce colors.red
   :r colors.cyan
   :rm colors.cyan
   "r?" colors.cyan
   :! colors.red
   :t colors.red})

(defn- buffer-not-empty []
  (-> (vim.fn.expand "%:t")
      vim.fn.empty
      (= 1)
      not))

(defn- hide-in-width []
  (> (vim.fn.winwidth 0) 80))

(. mode-color (vim.fn.mode))

(defn- check-git-workspace []
  (let [filepath (vim.fn.expand "%:p:h")
        gitdir (vim.fn.finddir ".git" (.. filepath ";"))]
    (and gitdir
         (> (core.count gitdir) 0)
         (< (core.count gitdir) (core.count filepath)))))

(defn- match-file-type [buf-ft]
  (fn [client]
    (and client.config.filetypes
         (core.some (fn [ft] (= ft buf-ft)) client.config.filetypes))))

(defn- active-lsp []
  (let [buf_ft (nvim.buf_get_option 0 :filetype)
        active-clients (vim.lsp.get_active_clients)
        client (->> active-clients
                         (core.filter (match-file-type buf_ft))
                         core.first)]
    (if client
      client.name
      "No active LSP")))

(defn- active-mode []
  {:fg (. mode-color (vim.fn.mode))})

(defn- component [field options]
  (core.assoc options 1 field))

(local config
  {:options
   {:component_separators ""
    :section_separators   ""
    :theme {:normal {:c {:fg colors.fg
                         :bg colors.bg}}
            :inactive {:c {:fg colors.fg
                           :bg colors.bg}}}}
   :sections {:lualine_a []
             :lualine_b []
             :lualine_y []
             :lualine_z ["diff"]
             :lualine_c [(component
                           (core.constantly "▊")
                           {:color active-mode
                            :padding {:left 0
                                      :right 1}})
                         (component
                           "mode"
                           {:color active-mode
                            :padding {:right 1}})
                         (component "filename")
                         (component "filetype")
                         (component
                           "filesize"
                           {:cond buffer-not-empty})
                         (component "location")
                         (component
                           "diagnostics"
                           {:sources [:nvim_diagnostic]
                            :symbols {:error " "
                                      :warn " "
                                      :info " "}
                            :diagnostics_color
                            {:color_error {:fg colors.red}
                             :color_warn {:fg colors.yellow}
                             :color_info {:fg colors.cyan}}})]
             :lualine_x [(component
                           active-lsp
                          {:icon " LSP:"
                           :color (fn []
                                    {:fg (if (vim.lsp.buf.server_ready)
                                           colors.green
                                           colors.orange)})})
                         (component
                           "o:encoding"
                           {:fmt string.upper
                            :cond hide-in-width
                            :color {:fg colors.green}})
                         (component
                           "fileformat"
                          {:fmt string.upper
                           :icons_enabled false
                           :color {:fg colors.green}})
                         (component
                           "branch"
                           {:icon ""
                            :color {:fg colors.violet}})
                         (component
                           "diff"
                           {:symbols {:added " "
                                      :modified "柳 "
                                      :removed: " "}})
                         (component
                           (core.constantly "▊")
                           {:color active-mode
                            :padding {:left 1}})]}
   :inactive_sections {:lualine_a []
                       :lualine_b []
                       :lualine_y []
                       :lualine_z []
                       :lualine_c [(component 
                                     (fn [] (vim.fn.bufnr "%"))
                                     {:color {:fg colors.blue}})
                                   (component 
                                     (fn [] (vim.fn.expand "%"))
                                     {:color {:fg colors.blue}})]
                       :lualine_x []}})

(let [lualine (require :lualine)]
  (lualine.setup config))
