let s:path = fnamemodify(resolve(expand('<sfile>:p')), ':h')
let s:replaceLineScriptPath = simplify(s:path . "/../script/replace-line.sh")

function! enmasse#EnMasse()
  let list = getqflist()
  let sourceLines = s:GetSourceLinesFromList(list)
  call s:CreateEnMasseBuffer(list, sourceLines)
endfunction

function! enmasse#EnMasseWriteCurrentBuffer()
  let list = b:enMasseList
  let sourceLines = getline(1, "$")
  call s:WriteSourceLinesAgainstList(list, sourceLines)
endfunction

function! enmasse#EnMasseDisplayQuickfixEntryForCurrentLine()
  let list = b:enMasseList
  let currentLine = line(".")
  let quickfixItem = list[currentLine - 1]
  echo quickfixItem.text
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
endfunction

function! s:WriteSourceLinesAgainstList(list, sourceLines)
  let index = 0

  for item in a:list
    let source = shellescape(a:sourceLines[index])
    let file = shellescape(bufname(item.bufnr))
    let line = item.lnum

    let command = printf("%s %s %d %s", s:replaceLineScriptPath, file, line, source)
    call system(command)

    let index += 1
  endfor

  set nomodified
  checktime
endfunction