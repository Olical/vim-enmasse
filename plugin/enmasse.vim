command! EnMasse :call enmasse#Open()
command! EnMasseVersion :echo enmasse#GetVersion()

augroup EnMasseDefault
  autocmd!
  autocmd WinLeave __EnMasse__ wincmd p
  autocmd BufWriteCmd __EnMasse__ call enmasse#WriteCurrentBuffer()
  autocmd CursorMoved __EnMasse__ call enmasse#DisplayQuickfixEntryForCurrentLine()
augroup END
