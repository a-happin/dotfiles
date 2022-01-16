let s:path = expand ('%:p')
let s:macro = toupper (substitute (substitute (s:path, '.*/include/', '', ''), '[/.]', {m -> '_'}, 'g'))
call append (0, ['#ifndef ' . s:macro, '#define ' . s:macro, '#endif'])
