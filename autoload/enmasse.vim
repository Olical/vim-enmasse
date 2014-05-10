let s:path = fnamemodify(resolve(expand('<sfile>:p')), ':h')
let s:replaceLineScriptPath = simplify(s:path . "/../script/replace-line.py")

function! enmasse#Open()
  let list = s:GetQuickfixList()
  let sourceLines = s:GetSourceLinesFromList(list)

  if len(list) > 0 && len(sourceLines) > 0
    call s:CreateEnMasseBuffer(list, sourceLines)
  else
    call s:EchoError("No entries to edit.")
  endif
endfunction

function! enmasse#GetVersion()
  return "1.0.0"
endfunction

function! enmasse#WriteCurrentBuffer()
  let list = b:enMasseList
  let sourceLines = getline(1, "$")

  if len(list) ==# len(sourceLines)
    call s:WriteSourceLinesAgainstList(list, sourceLines)
  else
    call s:EchoError("Mismatch between buffer lines and quickfix list. Refusing to write.")
  endif
endfunction

function! enmasse#DisplayQuickfixEntryForCurrentLine()
  let quickfixItem = s:GetQuickfixItemForCurrentLine()
  call s:EchoTruncated(quickfixItem.text)
endfunction

function! s:EchoTruncated(msg)
  let saved=&shortmess
  set shortmess+=T
  exe "norm :echomsg a:msg\n"
  let &shortmess=saved
endfunction

function! s:EchoError(message)
    echohl ErrorMsg
    echo "EnMasse:" a:message
    echohl None
endfunction

function! s:GetQuickfixList()
  let list = getqflist()
  let uniqueList = []

  for item in list
    let existingItem = s:GetMatchingLineFromQuickfix(item, uniqueList)

    if has_key(existingItem, "bufnr")
      let existingItem.text = join([existingItem.text, item.text], " | ")
    else
      call add(uniqueList, item)
    endif
  endfor

  call sort(uniqueList, "s:SortByBufferAndLine")

  return uniqueList
endfunction

function! s:SortByBufferAndLine(i1, i2)
  if a:i1.bufnr > a:i2.bufnr || (a:i1.bufnr ==# a:i2.bufnr && a:i1.lnum > a:i2.lnum)
    return 1
  else
    return -1
  endif
endfunction

function! s:GetMatchingLineFromQuickfix(target, list)
  for item in a:list
    if a:target.bufnr ==# item.bufnr && a:target.lnum ==# item.lnum
      return item
    endif
  endfor

  return {}
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
  let lines = readfile(a:file)
  return lines[a:line - 1]
endfunction

function! s:CreateEnMasseBuffer(list, sourceLines)
  new __EnMasse__
  set buftype=acwrite
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