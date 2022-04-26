function context-abbr --description 'add context abbreviation'

  argparse -n context-abbr -x 'replace-self,replace-context,replace-all,prepend,append' --min-args 3 --max-args 3 --stop-nonopt 'h/help' 'replace-self' 'replace-context' 'replace-all' 'prepend' 'append' 'e/eval' 'global' -- $argv
  or return 1

  set -l context
  set -l abbr
  set -l phrase
  set -l operation replace-self
  set -l global_flag 0
  set -l eval_flag 0

  if set -lq _flag_help
    string trim "
context-abbr: add context abbreviation

Usage: [options] CONTEXT WORD_GLOB PHRASE

Options:
  --global             allow extra arguments
  --replace-self       replace WORD with PHRASE (default)
  --replace-context    replace context with PHRASE
  --replace-all        replace all with PHRASE
  --prepend            prepend PHRASE
  --append             append PHRASE
  -e --eval            insert (eval PHRASE) instead of PHASE
  -h --help            show help message
"
    return
  end

  if test (count $argv) -ge 3
    set context $argv[1]
    set abbr $argv[2]
    set phrase $argv[3..-1]
  else
    # 引数の数がおかしい
    echo "context-abbr: too few arguments." >&2
    return 1
  end

  if set -lq _flag_replace_context
    set operation replace-context
  end

  if set -lq _flag_replace_all
    set operation replace-all
  end

  if set -lq _flag_prepend
    set operation prepend
  end

  if set -lq _flag_append
    set operation append
  end

  if set -lq _flag_global
    set global_flag 1
  end

  if set -lq _flag_eval
    set eval_flag 1
  end

  set -ga context_abbreviations (string join -- \n "$context" "$abbr" $global_flag "$operation" $eval_flag "$phrase" | string collect)
end
