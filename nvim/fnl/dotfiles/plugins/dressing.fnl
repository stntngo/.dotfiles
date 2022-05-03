(module dotfiles.plugins.dressing
  {require {dressing dressing}})

(dressing.setup
  {:input  {:enabled  false
            :relative :editor}
   :select {:enabled false}})
