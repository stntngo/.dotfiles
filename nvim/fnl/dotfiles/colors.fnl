(module dotfiles.colors)

(local mod (require :nightfox.palette))
(local palette (mod.load :nordfox))


(def colors
  (let [mod (require :nightfox.palette)
        palette (mod.load :nordfox)]
    {:bg       palette.bg0
     :fg       palette.fg0
     :yellow   palette.yellow.base
     :cyan     palette.cyan.base
     :darkblue palette.blue.base
     :green    palette.green.base
     :orange   palette.orange.base
     :violet   palette.magenta.base
     :magenta  palette.magenta.dim
     :black    palette.black.base
     :blue     palette.blue.dim
     :red      palette.red.base
     :gray     palette.black.light
     :comment  palette.comment}))
