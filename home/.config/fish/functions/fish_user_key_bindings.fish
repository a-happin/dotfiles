function fish_user_key_bindings
  bind ' ' 'commandline -f expand-abbr; __expand_suffix_abbreviation; commandline -i " "'
end
