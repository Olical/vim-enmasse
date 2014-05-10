command! EnMasse :call enmasse#EnMasse()
command! EnMasseVersion :echo enmasse#GetVersion()

autocmd BufWriteCmd __EnMasse__ call enmasse#EnMasseWriteCurrentBuffer()
autocmd CursorMoved __EnMasse__ call enmasse#EnMasseDisplayQuickfixEntryForCurrentLine()
