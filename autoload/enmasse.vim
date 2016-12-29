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
  return "1.1.1"
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
  exec "echomsg a:msg"
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
  let lines = readfile(a:file, "b")
  return lines[a:line - 1]
endfunction

function! s:CreateEnMasseBuffer(list, sourceLines)
  noautocmd keepalt botright new! __EnMasse__
  setlocal stl=\ EnMasse
  setlocal buftype=acwrite
  setlocal bufhidden=hide
  setlocal noswapfile
  setlocal nobuflisted
  normal! gg"_dG
  call setbufvar(bufnr(''), "enMasseList", a:list)
  call append(0, a:sourceLines)
  normal! "_ddgg
  nnoremap <silent><buffer> <CR> :call <SID>OpenLineInPreviewWindow()<CR>
  set nomodified
  if line('$') < winheight(winnr())
      execute 'resize' line('$')
  end
endfunction

function! s:OpenLineInPreviewWindow()
  let quickfixItem = s:GetQuickfixItemForCurrentLine()
  let file = bufname(quickfixItem.bufnr)
  execute printf("pedit +%d %s", quickfixItem.lnum, file)
endfunction

function! s:GetQuickfixItemForCurrentLine()
  let list = b:enMasseList
  let currentLine = line(".")
  let quickfixItem = list[currentLine - 1]
  return quickfixItem
endfunction

function! s:WriteSourceLinesAgainstList(list, sourceLines)
  let toWrite = s:MergeChangesUnderPaths(a:list, a:sourceLines)

  for [filePath, fileChanges] in items(toWrite)
    let lines = readfile(filePath, "b")
    let changed = 0

    for lineChange in fileChanges
      if lines[lineChange.line] != lineChange.change
        let lines[lineChange.line] = lineChange.change
        let changed = 1
      endif
    endfor

    if changed
      execute "silent doautocmd FileWritePre " . filePath
      call writefile(lines, filePath, "b")
      execute "silent doautocmd FileWritePost " . filePath
    endif
  endfor

  set nomodified
  checktime
endfunction

function! s:MergeChangesUnderPaths(list, sourceLines)
  let index = 0
  let paths = {}

  for item in a:list
    let path = bufname(item.bufnr)
    let changes = get(paths, path, [])
    let paths[path] = add(changes, {"change": a:sourceLines[index], "line": item.lnum - 1})
    let index += 1
  endfor

  return paths
endfunction
