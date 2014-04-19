let s:path = fnamemodify(resolve(expand('<sfile>:p')), ':h')
let s:replaceLineScriptPath = simplify(s:path . "/../script/replace-line.py")

function! enmasse#EnMasse()
  let list = getqflist()
  let sourceLines = s:GetSourceLinesFromList(list)

  if len(list) > 0 && len(sourceLines) > 0
    call s:CreateEnMasseBuffer(list, sourceLines)
  else
    call s:EchoError("No entries to edit.")
  endif
endfunction

function! enmasse#EnMasseWriteCurrentBuffer()
  let list = b:enMasseList
  let sourceLines = getline(1, "$")

  if len(list) == len(sourceLines)
    call s:WriteSourceLinesAgainstList(list, sourceLines)
  else
    call s:EchoError("Mismatch between buffer lines and quickfix list. Refusing to write.")
  endif
endfunction

function! enmasse#EnMasseDisplayQuickfixEntryForCurrentLine()
  let quickfixItem = s:GetQuickfixItemForCurrentLine()
  echo quickfixItem.text
endfunction

function! s:EchoError(message)
    echohl ErrorMsg
    echo "EnMasse:" a:message
    echohl None
endfunction

function! s:GetSourceLinesFromList(list)
  let sourceLines = []

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
  nmap <silent><buffer> <CR> :call <SID>OpenFileForCurrentLine()<CR>
endfunction

function! s:OpenFileForCurrentLine()
  let quickfixItem = s:GetQuickfixItemForCurrentLine()
  let file = bufname(quickfixItem.bufnr)
  exec printf("new %s", file)
  call cursor(quickfixItem.lnum, quickfixItem.col)
endfunction

function! s:GetQuickfixItemForCurrentLine()
  let list = b:enMasseList
  let currentLine = line(".")
  let quickfixItem = list[currentLine - 1]
  return quickfixItem
endfunction

function! s:WriteSourceLinesAgainstList(list, sourceLines)
  let index = 0

  for item in a:list
    let file = shellescape(bufname(item.bufnr))
    let line = item.lnum - 1
    let source = shellescape(a:sourceLines[index])

    let command = printf("%s %s %d %s", s:replaceLineScriptPath, file, line, source)
    call system(command)

    let index += 1
  endfor

  set nomodified
  checktime
endfunction