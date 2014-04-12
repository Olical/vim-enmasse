function! enmasse#EnMasse()
  let list = getqflist()
  let sourceLines = s:GetSourceLinesFromList(list)
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
  let command = printf("tail %s -n+%d | head -n1", shellescape(a:file), a:line)
  return system(command)
endfunction