(module dotfiles.module.plugins.bufferline
  {require {util dotfiles.util
            core aniseed.core
            colors* dotfiles.colors}})

(local colors colors*.colors)

; (let [bufferline (require :bufferline)]
;   (bufferline.setup
;     {:options
;      {:color_icons true
;       :tab_size 24
;       ; :themable true
;       :show_close_icon false
;       :enforce_regular_tabs true
;       :show_buffer_icons false
;       :show_buffer_close_icons false
;       :diagnostics :nvim_lsp
;       :groups {:items
;                [{:name "Uber"
;                  :highlight {:guisp colors.red}
;                  :icon "ﱇ"
;                  :matcher (fn [buf]
;                             (-> buf.path
;                                 (string.find "code.uber.internal")
;                                 core.nil?
;                                 not))}]}}})
;      ; :highlights
;      ; {:buffer_selected {:guibg colors.blue
;      ;                    :guifg colors.black}}})

;   (util.nnoremap :gb :BufferLinePick))