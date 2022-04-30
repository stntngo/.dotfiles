(module dotfiles.module.plugins.lualine
  {require {core aniseed.core
            nvim aniseed.nvim
            colors* dotfiles.colors}})

; Lualine configuration largerly inpsired by the Eviline config 
; from the lualine example docs
; Author: shadmansaleh
; Credit: glepnir

(local colors colors*.colors)

(local mode-color
  {:n   colors.blue
   :i   colors.orange
   :v   colors.green
   "" colors.green
   :V   colors.green
   :c   colors.magenta
   :no  colors.red
   :s   colors.orang
   :S   colors.orange
   "" colors.orange
   :ic  colors.yellow
   :R   colors.violet
   :Rv  colors.violet
   :cv  colors.red
   :ce  colors.red
   :r   colors.cyan
   :rm  colors.cyan
   "r?" colors.cyan
   :!   colors.red
   :t   colors.violet})

(defn- buffer-not-empty []
  (-> (vim.fn.expand "%:t")
      vim.fn.empty
      (= 1)
      not))

(defn- hide-in-width []
  (> (vim.fn.winwidth 0) 80))

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
      "no active LSP")))

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
                           :bg colors.bg}
                       :z {:fg colors.fg
                           :bg colors.bg}}}}
   :sections {:lualine_a []
             :lualine_b []
             :lualine_y []
             :lualine_z []
             :lualine_c [(component
                           (core.constantly "▊")
                           {:color   active-mode
                            :padding {:left 0
                                      :right 1}})
                         (component
                           "mode"
                           {:color   active-mode
                            :fmt     string.lower
                            :padding {:right 1}})
                         (component "filename")
                         (component
                           "filetype"
                           {:icons_enabled false})
                         (component
                           "filesize"
                           {:cond buffer-not-empty})
                         (component "location")
                         (component
                           "diagnostics"
                           {:sources [:nvim_diagnostic]
                            :symbols {:error " "
                                      :warn  " "
                                      :info  " "}
                            :diagnostics_color
                            {:color_error {:fg colors.red}
                             :color_warn  {:fg colors.yellow}
                             :color_info  {:fg colors.cyan}}})]
             :lualine_x [(component
                           active-lsp
                          {:color (fn []
                                    {:fg (if (vim.lsp.buf.server_ready)
                                             colors.green
                                             colors.orange)})})
                         (component
                           "o:encoding"
                           {:fmt string.lower
                            :cond hide-in-width
                            :color {:fg colors.green}})
                         (component
                           "fileformat"
                          {:fmt string.lower
                           :icons_enabled false
                           :color {:fg colors.green}})
                         (component
                           "branch"
                           {:icons_enabled false
                            :color {:fg colors.violet}})
                         (component
                           "diff"
                           {:diff_color {:added    {:fg colors.green}
                                         :modified {:fg colors.orange}
                                         :removed  {:fg colors.red}}})
                         (component
                           (core.constantly "▊")
                           {:color   active-mode
                            :padding {:left 1}})]}
   :inactive_sections {:lualine_a []
                       :lualine_b []
                       :lualine_y []
                       :lualine_z [(component
                                     "diff"
                                     {:diff_color {:added    {:fg colors.green}
                                                   :modified {:fg colors.orange}
                                                   :removed  {:fg colors.red}}})]
                       :lualine_c [(component 
                                     (fn [] (vim.fn.expand "%"))
                                     {:color {:fg colors.blue}})]
                       :lualine_x []}})

(let [lualine (require :lualine)]
  (lualine.setup config))
