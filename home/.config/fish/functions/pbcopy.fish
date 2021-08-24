function pbcopy
  if command -q pbcopy
    pbcopy
  else if command -q clip.exe
    clip.exe
  else if command -q xsel
    xsel --clipboard --input
  else
    return 1
  end
end
