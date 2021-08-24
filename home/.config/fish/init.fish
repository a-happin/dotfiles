# あいさつはいらない
set -U fish_greeting

# use default key bindings
set -U fish_key_bindings fish_default_key_bindings

# プロンプトのディレクトリ名を省略しない
set -U fish_prompt_pwd_dir_length 0

# set colors
set -U fish_color_autosuggestion 969896
set -U fish_color_cancel -r
set -U fish_color_command c397d8
set -U fish_color_comment e7c547
set -U fish_color_cwd green
set -U fish_color_cwd_root red
set -U fish_color_end c397d8
set -U fish_color_error d54e53
set -U fish_color_escape 00a6b2
set -U fish_color_history_current --bold
set -U fish_color_host normal
set -U fish_color_host_remote yellow
set -U fish_color_match --background=brblue
set -U fish_color_normal normal
set -U fish_color_operator 00a6b2
set -U fish_color_param 7aa6da
set -U fish_color_quote b9ca4a
set -U fish_color_redirection 70c0b1
set -U fish_color_search_match 'bryellow' '--background=brblack'
set -U fish_color_selection 'white' '--bold' '--background=brblack'
set -U fish_color_status red
set -U fish_color_user brgreen
set -U fish_color_valid_path --underline
set -U fish_pager_color_completion normal
set -U fish_pager_color_description 'B3A06D' 'yellow'
set -U fish_pager_color_prefix 'white' '--bold' '--underline'
set -U fish_pager_color_progress 'brwhite' '--background=cyan'