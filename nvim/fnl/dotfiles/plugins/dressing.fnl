(module dotfiles.plugins.dressing
  {require {dressing dressing}})

; XXX: I don't even know if I really like this plugin. It goes a little too
; far toward the realm of "fancy TUI" for my taste I think. The input line
; on the bottom of the screen helps keep this feeling like it's still just
; a terminal application no matter how many color schemes and plugins get
; shoved into it.
(dressing.setup
  {:input  {:enabled  false
            :relative :editor}
   :select {:enabled false}})
