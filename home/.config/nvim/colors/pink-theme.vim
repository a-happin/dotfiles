if !has('gui_running') && &t_Co < 256
  finish
endif

hi clear
if exists('syntax_on')
  syntax reset
endif

let g:colors_name = expand ('<sfile>:t:r')

if &background ==# 'dark'
  hi Normal ctermbg=none ctermfg=white guibg=none guifg=#eaeaea
  hi LineNr cterm=NONE ctermbg=none ctermfg=darkgray gui=NONE guibg=none guifg=#767676
  hi CursorLineNr cterm=bold ctermbg=black ctermfg=lightmagenta gui=bold guibg=#2a2a2a guifg=lightmagenta
  hi Cursor cterm=reverse ctermbg=none ctermfg=lightmagenta gui=reverse guibg=none guifg=lightmagenta
  hi CursorLine cterm=NONE ctermbg=black gui=NONE guibg=#2a2a2a
  hi CursorColumn ctermbg=black guibg=#2a2a2a
  hi ColorColumn ctermbg=lightmagenta guibg=lightmagenta
  hi CocHighlightText cterm=underline gui=underline
  hi StatusLine cterm=bold ctermbg=white ctermfg=black gui=bold guibg=#eaeaea guifg=#000000
  hi StatusLineNC cterm=NONE ctermbg=darkgray ctermfg=black gui=NONE guibg=#767676 guifg=#000000
  hi Question ctermbg=none ctermfg=lightmagenta guibg=none guifg=lightmagenta
  hi ModeMsg cterm=bold ctermbg=none ctermfg=lightmagenta gui=bold guibg=none guifg=lightmagenta
  hi MoreMsg cterm=bold ctermbg=none ctermfg=lightmagenta gui=bold guibg=none guifg=lightmagenta
  hi ErrorMsg cterm=bold ctermbg=none ctermfg=red gui=bold guibg=none guifg=#d54e53
  hi WarningMsg cterm=bold ctermbg=none ctermfg=yellow gui=bold guibg=none guifg=#e7c547
  hi Pmenu cterm=NONE ctermbg=black ctermfg=white gui=NONE guibg=#000000 guifg=#eaeaea
  hi PmenuSel cterm=reverse ctermbg=black ctermfg=lightmagenta gui=reverse guibg=#000000 guifg=lightmagenta
  hi PmenuSbar ctermbg=darkgray ctermfg=none guibg=#767676 guifg=none
  hi PmenuThumb ctermbg=lightmagenta ctermfg=none guibg=lightmagenta guifg=none
  hi Directory ctermfg=blue guifg=#7aa6da
  hi Title cterm=bold ctermfg=lightmagenta gui=bold guifg=lightmagenta
  hi Visual ctermbg=lightmagenta ctermfg=black guibg=lightmagenta guifg=#000000
  hi WildMenu cterm=bold,reverse ctermbg=black ctermfg=lightmagenta gui=bold,reverse guibg=#000000 guifg=lightmagenta
  hi Comment ctermfg=243 guifg=#767676
  hi Constant ctermfg=red guifg=#d54e53
  hi String ctermfg=red guifg=#d54e53
  hi Identifier cterm=NONE ctermfg=blue gui=NONE guifg=#7aa6da
  hi Function ctermfg=blue guifg=#7aa6da
  hi Statement cterm=bold ctermfg=magenta gui=bold guifg=#c397d8
  hi Label ctermfg=magenta guifg=#c397d8
  hi Operator cterm=bold ctermfg=magenta gui=bold guifg=#c397d8
  hi PreProc ctermfg=magenta guifg=#c397d8
  hi Type cterm=bold ctermfg=blue gui=bold guifg=#7aa6da
  hi Special cterm=bold ctermfg=lightmagenta gui=bold guifg=lightmagenta
  hi Error cterm=bold ctermbg=red ctermfg=black gui=bold guibg=#d54e53 guifg=#000000
  hi Todo cterm=bold ctermbg=yellow ctermfg=black gui=bold guibg=#e7c547 guifg=#000000
  hi Conceal ctermfg=lightmagenta guifg=lightmagenta
  hi TabLine cterm=NONE ctermbg=black ctermfg=white gui=NONE guibg=#000000 guifg=#eaeaea
  hi TabLineSel cterm=NONE ctermbg=lightmagenta ctermfg=black gui=NONE guibg=lightmagenta guifg=#000000
  hi TabLineFill cterm=NONE ctermbg=none ctermfg=none gui=NONE guibg=none guifg=none
  hi SpecialKey cterm=NONE ctermfg=lightmagenta gui=NONE guifg=lightmagenta
  hi NonText cterm=NONE ctermfg=lightmagenta gui=NONE guifg=lightmagenta
  hi VertSplit cterm=NONE ctermbg=none ctermfg=darkgray gui=NONE guibg=none guifg=#767676
  hi IncSearch cterm=bold,reverse ctermbg=none ctermfg=white gui=bold,reverse guibg=none guifg=#eaeaea
  hi Search cterm=bold,reverse ctermbg=none ctermfg=yellow gui=bold,reverse guibg=none guifg=#e7c547
  hi MatchParen cterm=bold ctermbg=none ctermfg=lightcyan gui=bold guibg=none guifg=lightcyan
  hi Folded ctermbg=none ctermfg=lightmagenta guibg=none guifg=lightmagenta
  hi FoldColumn ctermbg=none ctermfg=lightmagenta guibg=none guifg=lightmagenta
  hi SignColumn ctermbg=none ctermfg=lightmagenta guibg=none guifg=lightmagenta
  hi SpellBad ctermbg=red ctermfg=black guibg=#d54e53 guifg=#000000
  hi SpellCap ctermbg=blue ctermfg=black guibg=#7aa6da guifg=#000000
  hi SpellLocal ctermbg=cyan ctermfg=black guibg=#70c0b1 guifg=#000000
  hi SpellRare ctermbg=magenta ctermfg=black guibg=#c397d8 guifg=#000000
  hi DiffAdd ctermbg=green ctermfg=black guibg=#b9ca4a guifg=#000000
  hi DiffChange ctermbg=none guibg=none
  hi DiffText ctermbg=yellow ctermfg=black guibg=#e7c547 guifg=#000000
  hi DiffDelete ctermbg=red ctermfg=black guibg=#d54e53 guifg=#000000
  hi diffAdded ctermbg=none ctermfg=green guibg=none guifg=#b9ca4a
  hi diffRemoved ctermbg=none ctermfg=red guibg=none guifg=#d54e53
  hi CocWarningSign ctermbg=none ctermfg=yellow guibg=none guifg=#e7c547
endif
hi! link EndOfBuffer Ignore
hi! link TermCursor Cursor
hi! link ToolbarButton TabLineSel
hi! link ToolbarLine TabLineFill
hi! link cssBraces Delimiter
hi! link cssClassName Special
hi! link cssClassNameDot Normal
hi! link cssPseudoClassId Special
hi! link cssTagName Statement
hi! link helpHyperTextJump Constant
hi! link htmlArg Constant
hi! link htmlEndTag Statement
hi! link htmlTag Statement
hi! link jsonQuote Normal
hi! link phpVarSelector Identifier
hi! link pythonFunction Title
hi! link rubyDefine Statement
hi! link rubyFunction Title
hi! link rubyInterpolationDelimiter String
hi! link rubySharpBang Comment
hi! link rubyStringDelimiter String
hi! link rustFuncCall Normal
hi! link rustFuncName Title
hi! link rustType Constant
hi! link sassClass Special
hi! link shFunction Normal
hi! link vimContinue Comment
hi! link vimFuncSID vimFunction
hi! link vimFuncVar Normal
hi! link vimFunction Title
hi! link vimGroup Statement
hi! link vimHiGroup Statement
hi! link vimHiTerm Identifier
hi! link vimMapModKey Special
hi! link vimOption Identifier
hi! link vimVar Normal
hi! link xmlAttrib Constant
hi! link xmlAttribPunct Statement
hi! link xmlEndTag Statement
hi! link xmlNamespace Statement
hi! link xmlTag Statement
hi! link xmlTagName Statement
hi! link yamlKeyValueDelimiter Delimiter
hi! link CtrlPPrtCursor Cursor
hi! link CtrlPMatch Title
hi! link CtrlPMode2 StatusLine
hi! link deniteMatched Normal
hi! link deniteMatchedChar Title
hi! link elixirBlockDefinition Statement
hi! link elixirDefine Statement
hi! link elixirDocSigilDelimiter String
hi! link elixirDocTest String
hi! link elixirExUnitMacro Statement
hi! link elixirExceptionDefine Statement
hi! link elixirFunctionDeclaration Title
hi! link elixirKeyword Statement
hi! link elixirModuleDeclaration Normal
hi! link elixirModuleDefine Statement
hi! link elixirPrivateDefine Statement
hi! link elixirStringDelimiter String
hi! link jsFlowMaybe Normal
hi! link jsFlowObject Normal
hi! link jsFlowType PreProc
hi! link graphqlName Normal
hi! link graphqlOperator Normal
hi! link gitmessengerHash Comment
hi! link gitmessengerHeader Statement
hi! link gitmessengerHistory Constant
hi! link jsArrowFunction Operator
hi! link jsClassDefinition Normal
hi! link jsClassFuncName Title
hi! link jsExport Statement
hi! link jsFuncName Title
hi! link jsFutureKeys Statement
hi! link jsFuncCall Normal
hi! link jsGlobalObjects Statement
hi! link jsModuleKeywords Statement
hi! link jsModuleOperators Statement
hi! link jsNull Constant
hi! link jsObjectFuncName Title
hi! link jsObjectKey Identifier
hi! link jsSuper Statement
hi! link jsTemplateBraces Special
hi! link jsUndefined Constant
hi! link markdownBold Special
hi! link markdownCode String
hi! link markdownCodeDelimiter String
hi! link markdownHeadingDelimiter Comment
hi! link markdownRule Comment
hi! link ngxDirective Statement
hi! link plug1 Normal
hi! link plug2 Identifier
hi! link plugDash Comment
hi! link plugMessage Special
hi! link SignifySignAdd GitGutterAdd
hi! link SignifySignChange GitGutterChange
hi! link SignifySignChangeDelete GitGutterChangeDelete
hi! link SignifySignDelete GitGutterDelete
hi! link SignifySignDeleteFirstLine SignifySignDelete
hi! link StartifyBracket Comment
hi! link StartifyFile Identifier
hi! link StartifyFooter Constant
hi! link StartifyHeader Constant
hi! link StartifyNumber Special
hi! link StartifyPath Comment
hi! link StartifySection Statement
hi! link StartifySlash Comment
hi! link StartifySpecial Normal
hi! link svssBraces Delimiter
hi! link swiftIdentifier Normal
hi! link typescriptAjaxMethods Normal
hi! link typescriptBraces Normal
hi! link typescriptEndColons Normal
hi! link typescriptFuncKeyword Statement
hi! link typescriptGlobalObjects Statement
hi! link typescriptHtmlElemProperties Normal
hi! link typescriptIdentifier Statement
hi! link typescriptMessage Normal
hi! link typescriptNull Constant
hi! link typescriptParens Normal

