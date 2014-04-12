function! enmasse#EnMasse()
  let list = getqflist()
  let sourceLines = s:GetSourceLinesFromList(list)
  call s:CreateEnMasseBuffer(list, sourceLines)
endfunction

function! enmasse#EnMasseWriteCurrentBuffer()
endfunction

function! s:GetSourceLinesFromList(list)
  let sourceLines = []
  let file = 0
  let line = 0

  for item in a:list
    let file = bufname(item.bufnr)
    let line = item.lnum
    call add(sourceLines, s:GetLineFromFile(file, line))
  endfor

  return sourceLines
endfunction

function! s:GetLineFromFile(file, line)
  let command = printf("sed '%dq;d' %s | awk '{printf $0}'", a:line, shellescape(a:file))
  return system(command)
endfunction

function! s:CreateEnMasseBuffer(list, sourceLines)
  new enmasse-list
  call append(0, a:sourceLines)
  $delete
  goto 1
  call setbufvar(bufnr(''), "enMasseList", a:list)
  set nomodified
endfunction