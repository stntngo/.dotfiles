(module dotfiles.util
  {require {nvim aniseed.nvim}})

(defn expand [path]
  (nvim.fn.expand path))

(defn glob [path]
  (nvim.fn.glob path true true true))

(defn exists? [path]
  (= (nvim.fn.filereadable path) 1))

(defn lua-file [path]
  (nvim.ex.luafile path))

(def config-path (nvim.fn.stdpath "config"))

(defn nnoremap [from to]
  "does this return the correct doc string?"
  (nvim.set_keymap
    :n
    from
    (.. ":" to "<cr>")
    {:noremap true}))

(defn leadernnoremap [from to]
  (nnoremap
    (.. "<leader>" from)
    to))
