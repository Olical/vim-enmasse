# En Masse [![Stories in Ready](https://badge.waffle.io/wolfy87/vim-enmasse.png?label=ready&title=Ready)](https://waffle.io/wolfy87/vim-enmasse)

Takes a quickfix list and makes it editable. You can then write each change back to their respective files using your favourite way of writing files, `:w` or `ZZ`, for example. Fix multiple [JSHint][] issues at once or perform a complex find and replace across your project all within the comfort of Vim.

![Animated demonstration](./images/example.gif)

## Using the plugin

As you can see in the demonstration above, all you have to do is populate a quickfix list in some way (I used [JSHint][], but you could use [Ag][], for example), then execute `:EnMasse`. This will open a new buffer with each line corresponding to a line in the quickfix list.

You can then edit each line in any way you want. When done just write this magical buffer and it will update each line in their corresponding files. Do not delete any lines, that will not work and EnMasse will actually prevent you from writing if you've added or removed any lines.

Pressing enter on a line will open that actual line in another buffer so you can get the context of what you're about to edit.

## Hinting at the quickfix

As you move your cursor through the lines the matching quickfix entry message will be echoed at the bottom of the screen. So if you're scrolling through a buffer created from a JSHint quickfix list, you'll be provided with the corresponding JSHint message for each line at the bottom of the window.

If there were multiple quickfix entries for a single line (missing semi-colon and unused variable, for example) then their messages will be merged into one in the hint. If the message is too long to fit on one line it will be truncated. It's either that or you have a "press enter to continue" prompt pop up every time the echo wraps onto the next line. Not cool. So truncation is the better alternative, even if you lose a bit of information sometimes.

## Author

[Oliver Caldwell][] / [@OliverCaldwell][]

## Unlicence

This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

In jurisdictions that recognize copyright laws, the author or authors
of this software dedicate any and all copyright interest in the
software to the public domain. We make this dedication for the benefit
of the public at large and to the detriment of our heirs and
successors. We intend this dedication to be an overt act of
relinquishment in perpetuity of all present and future rights to this
software under copyright law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

For more information, please refer to <http://unlicense.org/>

[jshint]: https://github.com/walm/jshint.vim
[ag]: https://github.com/rking/ag.vim
[Oliver Caldwell]: http://oli.me.uk/
[@OliverCaldwell]: https://twitter.com/OliverCaldwell