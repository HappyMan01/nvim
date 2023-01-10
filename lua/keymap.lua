local G = require('G')

G.cmd([[au BufEnter * if &buftype == '' && &readonly == 1 | set buftype=acwrite | set noreadonly | endif]])
G.cmd([[
func MagicSave()
    " If the directory is not exited, create it
    if empty(glob(expand("%:p:h")))
        call system("mkdir -p " . expand("%:p:h"))
    endif
    " If the file is not writable, use sudo to write it
    if &buftype == 'acwrite'
        w !sudo tee > /dev/null %
    else
        w
    endif
endf
]])
G.map({
    -- 设置s t 无效 ;=: ,重复上一次宏操作
    { 'n', ';',           ':',       {} },
    { 'v', ';',           ':',       {} },
    { 'i', 'jj',           '<esc>',       {} },
    { 'n', '+',           '<c-a>',   { noremap = true } },
    { 'n', '_',           '<c-x>',   { noremap = true } },
    { 'n', ',',           '@q',      { noremap = true } },

    -- 快速删除
    { 'i', '<c-h>',       'col(".") == col("$") ? \'<esc>"_db"_xa\' : \'<esc>"_db"_xi\'', { noremap = true, expr = true } },

    -- 跳转下一行
    { 'i', '<c-j>',       '<esc>f,a<cr>', { noremap = true } },


    -- c-s = :%s/(全局替换)
    { 'n', '<c-s>',       ':<c-u>%s/\\v//gc<left><left><left><left>', { noremap = true } },
    { 'v', '<c-s>',             ':s/\\v//gc<left><left><left><left>', { noremap = true } },

    -- only change text
    { 'v', '<BS>',        '"_d',     { noremap = true } },
    { 'n', 'x',           '"_x',     { noremap = true } },
    { 'v', 'x',           '"_x',     { noremap = true } },
    { 'n', 'Y',           'y$',      { noremap = true } },
    { 'v', 'c',           '"_c',     { noremap = true } },
    { 'v', 'p',           'pgvy',    { noremap = true } },
    { 'v', 'P',           'Pgvy',    { noremap = true } },

    -- S保存 Q退出
    { 'n', 'S',           ':call MagicSave()<cr>', { noremap = true, silent = true } },
    { 'n', 'Q',           ':q!<cr>', { noremap = true, silent = true } },

    -- VISUAL SELECT模式 s-tab tab左右缩进
    { 'v', '<',           '<gv',     { noremap = true } },
    { 'v', '>',           '>gv',     { noremap = true } },
    { 'v', '<s-tab>',     '<gv',     { noremap = true } },
    { 'v', '<tab>',       '>gv',     { noremap = true } },

    -- CTRL SHIFT + 方向 快速跳转
    { 'n', 'H',  '^',       { noremap = true } },
    { 'n', 'L', '$<left>',       { noremap = true } },
    { 'v', 'H',  '^',       { noremap = true } },
    { 'v', 'L', '$<left>',       { noremap = true } },

    -- 选中全文 选中{ 复制全文
    { 'n', '<leader>a',       'ggVG',    { noremap = true } },
    { 'n', '<leader>{',       'vi{',     { noremap = true } },

    -- alt + 上 下移动行
    { 'n', '<m-up>',      ':m .-2<cr>',       { noremap = true, silent = true } },
    { 'n', '<m-down>',    ':m .+1<cr>',       { noremap = true, silent = true } },
    { 'i', '<m-up>',      '<Esc>:m .-2<cr>i', { noremap = true, silent = true } },
    { 'i', '<m-down>',    '<Esc>:m .+1<cr>i', { noremap = true, silent = true } },
    { 'v', '<m-up>',      ":m '<-2<cr>gv",    { noremap = true, silent = true } },
    { 'v', '<m-down>',    ":m '>+1<cr>gv",    { noremap = true, silent = true } },

    -- windows: 窗口移动
    { 'n', '<c-h>',     '<c-w>h',           { noremap = true } },
    { 'n', '<c-l>',    '<c-w>l',           { noremap = true } },
    { 'n', '<c-k>',       '<c-w>k',           { noremap = true } },
    { 'n', '<c-j>',     '<c-w>j',           { noremap = true } },


    -- tt 打开一个10行大小的终端(并进行配置)
    { 'n', 'tt',          ':below 8sp | term<cr>a', { noremap = true, silent = true } },
    { 't', '<ESC>',          '<C-\\><C-n>', { noremap = true, silent = true } },
    { 't', '<C-\\>',          '<C-\\><C-n>:bdelete! %<CR>', { noremap = true, silent = true } },
    { 't', '<C-\\>',          '<C-\\><C-n>:bdelete! %<CR>', { noremap = true, silent = true } },
    { 't', '<C-k>',          '<C-\\><C-n><C-w>k', { noremap = true, silent = true } },
    -- buffers
    { 'n', 'W',           ':bw<cr>',          { noremap = true, silent = true } },
    { 'n', 'ss',          ':bn<cr>',          { noremap = true, silent = true } },
    { 'n', '<a-h>',    ':bp<cr>',          { noremap = true, silent = true } },
    { 'n', '<a-l>',   ':bn<cr>',          { noremap = true, silent = true } },
    -- { 'v', '<m-h>',    '<esc>:bp<cr>',     { noremap = true, silent = true } },
    -- { 'v', '<m-l>',   '<esc>:bn<cr>',     { noremap = true, silent = true } },
    -- { 'i', '<m-h>',    '<esc>:bp<cr>',     { noremap = true, silent = true } },
    -- { 'i', '<m-l>',   '<esc>:bn<cr>',     { noremap = true, silent = true } },

    -- 切换是否wrap
    { 'n', '\\w',         "&wrap == 1 ? ':set nowrap<cr>' : ':set wrap<cr>'", { noremap = true, expr = true } },
})

-- 重设tab长度
G.cmd('command! -nargs=* SetTab call SwitchTab(<q-args>)')
G.cmd([[
    fun! SwitchTab(tab_len)
        if !empty(a:tab_len)
            let [&shiftwidth, &softtabstop, &tabstop] = [a:tab_len, a:tab_len, a:tab_len]
        else
            let l:tab_len = input('input shiftwidth: ')
            if !empty(l:tab_len)
                let [&shiftwidth, &softtabstop, &tabstop] = [l:tab_len, l:tab_len, l:tab_len]
            endif
        endif
        redraw!
        echo printf('shiftwidth: %d', &shiftwidth)
    endf
]])

-- 折叠
G.map({
    { 'n', '--', "foldclosed(line('.')) == -1 ? ':call MagicFold()<cr>' : 'za'", { noremap = true, silent = true, expr = true } },
    { 'v', '-',  'zf', { noremap = true } },
})
G.cmd([[
    fun! MagicFold()
        let l:line = trim(getline('.'))
        if l:line == '' | return | endif
        let [l:up, l:down] = [0, 0]
        if l:line[0] == '}'
            exe 'norm! ^%'
            let l:up = line('.')
            exe 'norm! %'
        endif
        if l:line[len(l:line) - 1] == '{'
            exe 'norm! $%'
            let l:down = line('.')
            exe 'norm! %'
        endif
        try
            if l:up != 0 && l:down != 0
                exe 'norm! ' . l:up . 'GV' . l:down . 'Gzf'
            elseif l:up != 0
                exe 'norm! V' . l:up . 'Gzf'
            elseif l:down != 0
                exe 'norm! V' . l:down . 'Gzf'
            else
                exe 'norm! za'
            endif
        catch
            redraw!
        endtry
    endf
]])

-- space 行首行尾跳转
G.map({
    { 'n', '<space>', ':call MagicMove()<cr>', { noremap = true, silent = true } },
    { 'n', '0', '%', { noremap = true } },
    { 'v', '0', '%', { noremap = true } },
})
G.cmd([[
    fun! MagicMove()
        let [l:first, l:head] = [1, len(getline('.')) - len(substitute(getline('.'), '^\s*', '', 'G')) + 1]
        let l:before = col('.')
        exe l:before == l:first && l:first != l:head ? 'norm! ^' : 'norm! $'
        let l:after = col('.')
        if l:before == l:after
            exe 'norm! 0'
        endif
    endf
]])

-- 驼峰转换
G.map({ { 'v', 't', ':call ToggleHump()<CR>', { noremap = true, silent = true } }, })
G.cmd([[
    fun! ToggleHump()
        let [l, c1, c2] = [line('.'), col("'<"), col("'>")]
        let line = getline(l)
        let w = line[c1 - 1 : c2 - 2]
        let w = w =~ '_' ? substitute(w, '\v_(.)', '\u\1', 'g') : substitute(substitute(w, '\v^(\u)', '\l\1', 'g'), '\v(\u)', '_\l\1', 'g')
        call setbufline('%', l, printf('%s%s%s', c1 == 1 ? '' : line[:c1-2], w, c2 == 1 ? '' : line[c2-1:]))
        call cursor(l, c1)
    endf
]])
