function context-abbr --description 'add context abbreviation'

  argparse -n context-abbr -x 'S,C' -s 'h/help' 'S/replace-itself' 'C/replace-command' 'eval' -- $argv
  or return 1

  set -l context
  set -l word
  set -l phrase
  set -l replace_flag 0
  set -l eval_flag 0

  if set -lq _flag_help
    string trim "
context-abbr: add context abbreviation

Usage: [options] CONTEXT WORD_GLOB PHRASE

Options:
  -S --replace-itself  replace WORD with PHRASE (default)
  -C --replace-command replace command with PHRASE
  --eval               insert (eval PHRASE) instead of PHASE
  -h --help            show help message
"
    return
  end

  if test (count $argv) -ge 3
    set context $argv[1]
    set word $argv[2]
    set phrase $argv[3..-1]
  else
    # 引数の数がおかしい
    echo "context-abbr: too few arguments." >&2
    return 1
  end

  if set -lq _flag_replace_command
    set replace_flag 1
  end

  if set -lq _flag_eval
    set eval_flag 1
  end

  set -ga context_abbreviations (string join -- \n "$context" "$word" $replace_flag $eval_flag "$phrase" | string collect)
end
