function subsh --description 'insert string to head of commandline'
    set -l sub "$argv"

    # --inherit-variable でフック定義時の値をキャプチャ
    function __subsh_hook -e fish_postexec --inherit-variable sub
        if test -n "$sub" -a -n "$argv"
            commandline "$sub "
        else
            # 空エンターあるいは引数なしの`subsh`で終了
            functions -e __subsh_hook
        end
    end
end
