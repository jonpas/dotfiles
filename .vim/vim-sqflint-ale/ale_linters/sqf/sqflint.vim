" Author: Jonpas
" Description: sqflint linter for SQF files

call ale#Set('sqf_sqflint_executable', 'sqflint')

function! ale_linters#sqf#sqflint#Handle(buffer, lines) abort
    " Matches patterns lines like the following:
    " [33,3]:error:Parenthesis "[" not closed
    let l:pattern = '\v^\[(\d+),(\d+)\]:(error|warning|info):(.+)$'
    let l:output = []

    for l:match in ale#util#GetMatches(a:lines, l:pattern)
        call add(l:output, {
        \   'lnum': l:match[1] + 0,
        \   'col': l:match[2] + 0,
        \   'text': l:match[4],
        \   'type': l:match[3] is# 'error' ? 'E' : 'W',
        \})
    endfor

    return l:output
endfunction

call ale#linter#Define('sqf', {
\   'name': 'sqflint',
\   'executable': {b -> ale#Var(b, 'sqf_sqflint_executable')},
\   'command': '%e %s -e e',
\   'callback': 'ale_linters#sqf#sqflint#Handle',
\})
