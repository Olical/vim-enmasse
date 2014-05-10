command! EnMasse :call enmasse#Open()

autocmd BufWriteCmd __EnMasse__ call enmasse#WriteCurrentBuffer()
autocmd CursorMoved __EnMasse__ call enmasse#DisplayQuickfixEntryForCurrentLine()
