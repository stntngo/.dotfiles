(module dotfiles.plugins.bufferline
  {require {util dotfiles.util
            core aniseed.core
            bufferline bufferline
            colors* dotfiles.colors}})

(local colors colors*.colors)

(bufferline.setup
  {:options
   {:color_icons true
    :tab_size 24
    :show_close_icon false
    :enforce_regular_tabs true
    :show_buffer_icons false
    :show_buffer_close_icons false
    :diagnostics :nvim_lsp
    :groups {:items
             [{:name "Uber"
               :highlight {:guifg colors.red}
               :matcher (fn [buf]
                          (-> buf.path
                              (string.find "code.uber.internal")
                              core.nil?
                              not))}]}}})

; TODO:  Investigate customizing the styling of the buffer tabs.

; XXX: Ensure consistency with vim grammar.
;
; I want to keep the typical vim grammar for these and I feel
; like I've managed that with <leader>bd to close a buffer, just
; like the :bd buffer ex-command itself. But <leader>bp to switch
; and choose a buffer seems wrong, what does [p]ick mean?
(util.leadernnoremap :bp :BufferLinePick)
(util.leadernnoremap :bd :BufferLinePickClose)
