function __expand_context_abbr

  # カーソル位置よりも前に1つ以上トークンが必要
  if test (count (commandline -poc)) = 0
    return
  end

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
    set -l replace_flag $a[3]
    set -l eval_flag $a[4]
    set -l phrase $a[5]

    if string match -q -- "$context" (commandline -poc | string join ' ')
      if string match -q -- "$word" (commandline -t)

        # eval
        if test $eval_flag = 1
          set phrase (eval $phrase | string join ' ')
        end

        # replace command
        if test $replace_flag = 1
          commandline -poc | read -l command
          commandline -p -- (commandline -p | string replace -- "$command" $phrase)
          commandline -f repaint
          break

        # replace itself
        else
          commandline -t -- $phrase
          commandline -f repaint
          break
        end

      end
    end
  end
end
