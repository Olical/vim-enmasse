# En Masse [![Build Status][travis-image]][travis]

[![Join the chat at https://gitter.im/Wolfy87/vim-enmasse](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/Wolfy87/vim-enmasse?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Takes a quickfix list and makes it editable. You can then write each change back to their respective files using your favourite way of writing files, `:w` or `ZZ`, for example. Fix multiple [JSHint][] issues at once or perform a complex find and replace across your project all within the comfort of Vim.

![Animated demonstration](./images/example.gif)

## Using the plugin

As you can see in the demonstration above, all you have to do is populate a quickfix list in some way (I used [JSHint][], but you could use [Ag][], for example), then execute `:EnMasse`. This will open a new buffer with each line corresponding to a line in the quickfix list.

You can then edit each line in any way you want. When done just write this magical buffer and it will update each line in their corresponding files. For more information, check out [the documentation!][docs]

## Installation

### [vim-plug](https://github.com/junegunn/vim-plug#readme)

add this line to `.vimrc`

```
Plug 'Olical/vim-enmasse'
```

### [vim-pathogen](https://github.com/tpope/vim-pathogen#readme)

```
cd ~/.vim/bundle
git clone https://github.com/Olical/vim-enmasse
```

### [Vundle.vim](https://github.com/gmarik/Vundle.vim#readme)

add this line to `.vimrc`

```
Plugin 'Olical/vim-enmasse'
```

## Tests

Tests are performed using [vader][], to pull the dependencies and run them simply execute `./tests/run`. The tests are automatically executed by [TravisCI][travis] too, so keep an eye on that if you push changes or open a PR. The badge up the top of this README indicates the state of master, it should ALWAYS be green. A test should be written before any change is made.

## Author

[Oliver Caldwell][author-site] ([@OliverCaldwell][author-twitter])

## Unlicenced

Find the full [unlicense][] in the `UNLICENSE` file, but here's a snippet.

>This is free and unencumbered software released into the public domain.
>
>Anyone is free to copy, modify, publish, use, compile, sell, or distribute this software, either in source code form or as a compiled binary, for any purpose, commercial or non-commercial, and by any means.

Do what you want. Learn as much as you can. Unlicense more software.

[unlicense]: http://unlicense.org/
[author-site]: http://oli.me.uk/
[author-twitter]: https://twitter.com/OliverCaldwell
[jshint]: https://github.com/walm/jshint.vim
[ag]: https://github.com/rking/ag.vim
[docs]: https://github.com/Olical/vim-enmasse/blob/master/doc/enmasse.txt
[travis-image]: https://travis-ci.org/Olical/vim-enmasse.svg?branch=master
[travis]: https://travis-ci.org/Olical/vim-enmasse
[vader]: https://github.com/junegunn/vader.vim
