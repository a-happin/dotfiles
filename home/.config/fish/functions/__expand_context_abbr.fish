function __expand_context_abbr

  # カーソル位置よりも前に1つ以上トークンが必要
  #if test (count (commandline -poc)) = 0
  #  return
  #end

  # cache
  set -l commandline (commandline -poc | string join ' ')

  # wordの途中で発動しないようにする
  if test (commandline -t) != (commandline -tc)
    return
  end

  # 定義した順。本当はソートしたい。
  for abbr in $context_abbreviations

    # \n区切りで情報が入っているので分解
    set -l a (string split \n $abbr)

    # わかりやすさのために別名をつける
    set -l context $a[1]
    set -l word $a[2]
    set -l global_flag $a[3]
    set -l operation $a[4]
    set -l eval_flag $a[5]
    set -l phrase $a[6]

    # contextが完全一致した場合
    if string match -q -- "$context" "$commandline"
      if string match -q -- "$word" (commandline -t)

        # eval
        if test $eval_flag = 1
          set -l argv (commandline -t)
          set phrase (eval $phrase | string join ' ')
        end

        switch "$operation"
          case "replace-self"
            commandline -t -- "$phrase"
          case "replace-context"
            commandline -p -- (string join -- ' ' "$phrase" (commandline -t))
          case "replace-all"
            commandline -p -- "$phrase"
          case "prepend"
            commandline -p -- (string join -- ' ' "$phrase" (commandline -p))
          case "append"
            commandline -pi -- " $phrase"
        end

        # 再描画
        commandline -f repaint

        # 残りのabbrを試さずに終了
        return 0
      end
    end
    # global && contextが前方一致
    if test $global_flag = 1 && string match -q -- (string trim -l -- "$context ")'**' "$commandline"
      if string match -q -- "$word" (commandline -t)

        # eval
        if test $eval_flag = 1
          set -l argv (commandline -t)
          set phrase (eval $phrase | string join ' ')
        end

        switch "$operation"
          case "replace-self"
            commandline -t -- "$phrase"
          case "replace-context"
            # commandlineをmatched_contextとargvに分離
            set -l matched_context
            set -l argv
            set -l matched 0
            set -l i
            for i in (commandline -p)
              if test $matched = 0
                set -a matched_context "$i"
                if string match -q -- "$context" (string join -- ' ' "$matched_context")
                  set matched 1
                end
              else
                set -a argv "$i"
              end
            end
            commandline -p -- (string join -- ' ' "$phrase" $argv)
          case "replace-all"
            commandline -p -- "$phrase"
          case "prepend"
            commandline -p -- (string join -- ' ' "$phrase" (commandline -p))
          case "append"
            commandline -pi -- " $phrase"
        end

        # 再描画
        commandline -f repaint

        # 残りのabbrを試さずに終了
        return 0
      end
    end
  end
end
