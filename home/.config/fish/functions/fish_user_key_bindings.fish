function fish_user_key_bindings
  type -q fzf_key_bindings && fzf_key_bindings
  bind ' ' "__expand_context_abbr; commandline -f expand-abbr; commandline -i ' '"
  bind \n "__expand_context_abbr; commandline -f execute"
  bind \r "__expand_context_abbr; commandline -f execute"
end
