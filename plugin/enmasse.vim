command! EnMasse :call enmasse#EnMasse()

autocmd BufWriteCmd __EnMasse__ call enmasse#EnMasseWriteCurrentBuffer()
autocmd CursorMoved __EnMasse__ call enmasse#EnMasseDisplayQuickfixEntryForCurrentLine()
