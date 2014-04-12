command! EnMasse :call enmasse#EnMasse()
autocmd BufWriteCmd enmasse-list call enmasse#EnMasseWriteCurrentBuffer()