(module init)

; Unmap all confgiured vimpeccable bindings.
(local vimp (require :vimp))
(vimp.unmap_all)

; Run all of the dot files initialziation.
(require :dotfiles.init)
