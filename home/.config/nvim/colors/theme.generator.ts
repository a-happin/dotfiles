type Color = {
  cui: number | string,
  gui: number | string
}
const HighlightAttribute = {
  NONE: 'NONE',
  bold: 'bold',
  underline: 'underline',
  undercurl: 'undercurl',
  reverse: 'reverse',
  inverse: 'inverse',
  italic: 'italic',
  standout: 'standout',
  strikethough: 'strikethough'
} as const
type HighlightAttribute = typeof HighlightAttribute[keyof typeof HighlightAttribute]

type HighlightArgument = {
  fg?: Color,
  bg?: Color,
  attrs?: HighlightAttribute[],
  guisp?: Color
}

const none = {cui: 'none', gui: 'none'} as const

const black = {cui: 'black', gui: '#000000'} as const
const darkred = {cui: 'darkred', gui: '#a54242'} as const
const green = {cui: 'green', gui: '#b9ca4a'} as const
const orange = {cui: 'darkyellow', gui: '#e78c45'} as const
// const blue = {cui: 'blue', gui: '#7aa6da'} as const
const purple = {cui: 'magenta', gui: '#c397d8'} as const
const darkgray = {cui: 'darkgray', gui: '#767676'} as const

const gray    = {cui: 'gray', gui: '#969896'} as const
const red     = {cui: 'red', gui: '#d54e53'} as const
const lime    = {cui: 'green', gui: '#b9ca4a'} as const
const yellow  = {cui: 'yellow', gui: '#e7c547'} as const
const blue    = {cui: 'blue', gui: '#7aa6da'} as const
const magenta = {cui: 'magenta', gui: '#c397d8'} as const
const cyan    = {cui: 'cyan', gui: '#70c0b1'} as const
const white   = {cui: 'white', gui: '#eaeaea'} as const

const pink = {cui: 225, gui: '#ffd7ff'} as const

const lightcyan = {cui: 'lightcyan', gui: 'lightcyan'} as const
const lightyellow = {cui: 'lightyellow', gui: 'lightyellow'} as const
const lightgreen = {cui: 'lightgreen', gui: 'lightgreen'} as const
const lightmagenta = {cui: 'lightmagenta', gui: 'lightmagenta'} as const
const wombat_blue = {cui: 'blue', gui: '#8ac6f2'} as const

const accent_color = wombat_blue
const accent_bg = black
const sub_color = white
const normal = white
const normal_bg = none
const cursorline_color = {cui: 'black', gui: '#2a2a2a'} as const
// const selection_color = {cui: }
const directory_color = blue
const comment_color = {cui: 243, gui: '#767676'} as const
const constant_color = orange
const string_color = lime
const identifier_color = normal
const function_color = blue
const statement_color = magenta
const operator_color = gray
const type_color = blue
const special_color = cyan
/* const sub = magenta */
/* const sub2 = {cui: 117, gui: '#87d7ff'} // skyblue */
/* const orange2 = {cui: 208, gui: '#ff8700'} */

const error_red = red//196 // #FF0000
// const warning_yellow = {cui: 226, gui: '#ffff00'}
const warning_yellow = yellow

const header = () => console.log (
`if !has('gui_running') && &t_Co < 256
  finish
endif

hi clear
if exists('syntax_on')
  syntax reset
endif

let g:colors_name = expand ('<sfile>:t:r')
`
)

const highlight = (name: string, arg: HighlightArgument) => {
  const opts = []
  if (arg.attrs !== undefined && arg.attrs.length > 0)
  {
    opts.push (`cterm=${arg.attrs.join (',')}`)
  }
  if (arg.bg !== undefined)
  {
    opts.push (`ctermbg=${arg.bg.cui}`)
  }
  if (arg.fg !== undefined)
  {
    opts.push (`ctermfg=${arg.fg.cui}`)
  }
  if (arg.attrs !== undefined && arg.attrs.length > 0)
  {
    opts.push (`gui=${arg.attrs.join (',')}`)
  }
  if (arg.bg !== undefined)
  {
    opts.push (`guibg=${arg.bg.gui}`)
  }
  if (arg.fg !== undefined)
  {
    opts.push (`guifg=${arg.fg.gui}`)
  }
  if (opts.length > 0)
  {
    console.log (`  hi ${name} ${opts.join (' ')}`)
  }
}

header ()
console.log (`if &background ==# 'dark'`)
  // 通常色
  highlight ('Normal', {fg: normal, bg: normal_bg})

  // 通常行番号
  highlight ('LineNr', {fg: darkgray, bg: normal_bg, attrs: ['NONE']})

  // カーソル行番号
  highlight ('CursorLineNr', {fg: accent_color, bg: cursorline_color, attrs: ['bold']})

  // カーソル (効かない…)
  highlight ('Cursor', {fg: accent_color, bg: none, attrs: ['reverse']})

  // カーソル行
  highlight ('CursorLine', {bg: cursorline_color, attrs: ['NONE']})

  // カーソル列
  highlight ('CursorColumn', {bg: cursorline_color})

  // set colorcolumn=80
  highlight ('ColorColumn', {bg: accent_color})

  // coc 単語の上にカーソルを乗せたとき
  highlight ('CocHighlightText', {attrs: ['underline']})


  // ステータスライン
  highlight ('StatusLine', {fg: black, bg: sub_color, attrs: ['bold']})
  // ステータスライン（非アクティブ）
  highlight ('StatusLineNC', {fg: black, bg: darkgray, attrs: ['NONE']})
  // プロンプトメッセージ
  highlight ('Question', {fg: accent_color, bg: normal_bg})
  // -- INSERT --
  highlight ('ModeMsg', {fg: accent_color, bg: normal_bg, attrs: ['bold']})
  // -- More --
  highlight ('MoreMsg', {fg: accent_color, bg: normal_bg, attrs: ['bold']})
  // error
  highlight ('ErrorMsg', {fg: error_red, bg: normal_bg, attrs: ['bold']})
  // warning
  highlight ('WarningMsg', {fg: warning_yellow, bg: normal_bg, attrs: ['bold']})


  // 補完ポップアップ
  highlight ('Pmenu', {fg: white, bg: black, attrs: ['NONE']})
  // 補完ポップアップ選択中アイテム
  highlight ('PmenuSel', {fg: accent_color, bg: accent_bg, attrs: ['reverse']})
  // ポップアップメニューのスクロールバー
  highlight ('PmenuSbar', {fg: none, bg: darkgray})
  // ポップアップメニューのスクロールバーのつまみ
  highlight ('PmenuThumb', {fg: none, bg: accent_color})

  // ディレクトリ
  highlight ('Directory', {fg: directory_color})


  // よくわかんないけどvimの関数名が該当していた
  highlight ('Title', {fg: function_color, attrs: ['bold']})
  // 選択中
  highlight ('Visual', {fg: accent_bg, bg: accent_color})

  // コマンドライン選択中補完候補
  highlight ('WildMenu', {fg: accent_color, bg: accent_bg, attrs: ['bold', 'reverse']})

  // コメント
  highlight ('Comment', {fg: comment_color})

  // 定数
  highlight ('Constant', {fg: constant_color})

  // 文字列
  highlight ('String', {fg: string_color})

  // 変数名
  highlight ('Identifier', {fg: identifier_color, attrs: ['NONE']})

  // 関数 クラスメソッドも含む
  highlight ('Function', {fg: function_color})

  // 文(ifなど)
  highlight ('Statement', {fg: statement_color, attrs: ['bold']})

  // ラベル
  highlight ('Label', {fg: statement_color})

  // 演算子
  highlight ('Operator', {fg: operator_color, attrs: ['bold']})

  // プリプロセッサ
  highlight ('PreProc', {fg: statement_color})

  // 型
  highlight ('Type', {fg: type_color, attrs: ['bold']})

  // 特殊記号? vimの<CR>や行継続\が対応していた
  highlight ('Special', {fg: constant_color, attrs: ['bold']})
  // \nなどのエスケープシークエンス
  highlight ('SpecialChar', {fg: constant_color, attrs: ['bold']})
  // ???
  highlight ('Tag', {fg: special_color, attrs: ['bold']})
  // 括弧、コンマなど
  highlight ('Delimiter', {fg: gray, attrs: ['bold']})
  // ???
  highlight ('SpecialComment', {fg: special_color, attrs: ['bold']})
  // ???
  highlight ('Debug', {fg: special_color, attrs: ['bold']})

  // エラー 確認できず
  highlight ('Error', {fg: black, bg: error_red, attrs: ['bold']})

  // TODO:
  highlight ('Todo', {fg: black, bg: warning_yellow, attrs: ['bold']})

  // Conceal
  highlight ('Conceal', {fg: accent_color})

  // タブ(非アクティブ)
  highlight ('TabLine', {fg: white, bg: black, attrs: ['NONE']})
  // タブ（アクティブ）
  highlight ('TabLineSel', {fg: accent_bg, bg: accent_color, attrs: ['NONE']})
  // タブ(タブがない部分)
  highlight ('TabLineFill', {fg: none, bg: normal_bg, attrs: ['NONE']})

  // 特殊記号? \V(Ctrl-V押したときに出るやつ)が対応していた
  highlight ('SpecialKey', {fg: accent_color, attrs: ['NONE']})

  // テキストではない? listchars(末尾空白やTab文字)が対応していた
  highlight ('NonText', {fg: accent_color, attrs: ['NONE']})

  // EOF後の~
  /* highlight ('EndOfBuffer', {fg: none, bg: none, attrs: none}) */

  // vsplitしたときの区切り線
  highlight ('VertSplit', {fg: darkgray, bg: none, attrs: ['NONE']})

  // 非表示にするためのグループ？
  // デフォルトのままがいいかも
  /* highlight ('Ignore', {fg: black, bg: none}) */

  // 検索結果
  // インクリメンタル検索中かつ最初にマッチした場所
  highlight ('IncSearch', {fg: sub_color, bg: none, attrs: ['bold', 'reverse']})
  // 上記以外
  highlight ('Search', {fg: yellow, bg: none, attrs: ['bold', 'reverse']})


  // 対応する括弧
  highlight ('MatchParen', {fg: lightcyan, bg: none, attrs: ['bold']})

  // 折りたたみ表示
  highlight ('Folded', {fg: gray, bg: none})
  // 折りたたみ表示カラム(set foldcolumn=1以上)
  highlight ('FoldColumn', {fg: gray, bg: none})

  // 印用カラム? cocがエラー位置表示用に使ってるっぽい
  highlight ('SignColumn', {fg: normal, bg: normal_bg})

  // スペル間違い
  highlight ('SpellBad', {fg: black, bg: red})
  // 大文字でなければならない？
  highlight ('SpellCap', {fg: black, bg: blue})
  // ?
  highlight ('SpellLocal', {fg: black, bg: cyan})
  // ?
  highlight ('SpellRare', {fg: black, bg: magenta})

  // vimdiff
  // 追加
  highlight ('DiffAdd', {fg: black, bg: green})
  // 変更した行の文字以外
  highlight ('DiffChange', {bg: none})
  // 変更した行の文字
  highlight ('DiffText', {fg: black, bg: yellow})
  // 削除
  highlight ('DiffDelete', {fg: black, bg: red})

  // git commit -v 時の差分
  // 追加
  highlight ('diffAdded', {fg: green, bg: none})
  // 削除
  highlight ('diffRemoved', {fg: red, bg: none})

  // coc
  highlight ('CocWarningSign', {fg: warning_yellow, bg: none})

  // lsp
  highlight ('LspReferenceText', {attrs: ['underline']})
  highlight ('LspReferenceRead', {attrs: ['underline']})
  highlight ('LspReferenceWrite', {attrs: ['underline']})

console.log (`endif`)
console.log (
`hi! link EndOfBuffer Ignore
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
hi! link vimUserFunc Function
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
hi! link @namespace.vim Function
hi! link @variable.vim Function
hi! link @variable.builtin.vim Function
hi! link @property.vim Function
`)
