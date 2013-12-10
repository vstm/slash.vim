# Slash syntax highlighting for VIM

[Slash](http://slash-lang.org/) syntax plugin for Vim. Yup, that's it.

## Installation

The installation is the same as for other syntax files.

The first step is to put the `syntax.vim`-file into your `syntax` directory.
Normally you want to install it for your current user. In that case you can
copy the `slash.vim`-file to the `~/.vim/syntax` directory (on Windows this is
probably `%USERPROFILE%\vimfiles`).

If you want to make a global installation, you have to find your global
syntax directory. The easiest way to do this is to run the `:echo $VIMRUNTIME`
command. Directly below the VIMRTUNTIME-directory you should find your global
`syntax` directory.

After you have copied the `slash.vim` file the correct `syntax` directory, you
can register the slash-syntax for the `*.sl` files:

    au BufNewFile,BufRead *.sl set filetype=slash

Put this into your `~/.vimrc` and the installation is finished (you have to
restart VIM though).

If you use [pathogen.vim](https://github.com/tpope/vim-pathogen) or
[Vundle](https://github.com/gmarik/vundle) the installation is slightly easier.

### Using pathogen.vim

Clone the `slash.vim` repository to your bundle-Directory:

    git clone https://github.com/vstm/slash.vim.git ~/.vim/bundle/slash.vim

Add the "filetype"-line to your `~/.vimrc` to complete the installation.

### Using Vundle

Just add the following line to your `.vimrc`:

    Bundle 'vstm/slash.vim'

Then run `:BundleInstall` to let Vundle fetch the plugin.

Add the "filetype"-line to your `~/.vimrc` to complete the installation.

## TODO

This is my first VIM-Syntax file, so it probably sucks. Big time. The following
things are next on my list:

* Actually test the Vundle-Installation
* Should the plugin register the *filetype* by itself? "Research" how other
  syntax-plugins do it.
* Add folding support
* Add indentation support

Suggestions and Contributions are welcome!

## License

Copyright (c) Stefan Vetsch. Distributed under the same terms as Vim itself.
See `:help license`.
