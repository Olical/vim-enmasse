if exists("g:loaded_enmasse") || v:version < 700 || &cp
  finish
endif

let g:loaded_enmasse = 1

command! EditList :call enmasse#EditList()
command! WriteList :call enmasse#WriteList()