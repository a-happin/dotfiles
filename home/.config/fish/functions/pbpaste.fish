function pbpaste
  if command -q pbpaste
    pbpaste
  else if command -q powershell.exe
    powershell.exe get-clipboard
  else if command -q xsel
    xsel --clipboard --output
  end
end
