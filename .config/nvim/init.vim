:set number
lua require('plugins')
call plug#begin()
Plug 'https://github.com/vim-airline/vim-airline'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'https://github.com/rafamadriz/neon'
call plug#end()
