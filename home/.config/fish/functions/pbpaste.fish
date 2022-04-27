function pbpaste
  if command -q pbpaste
    command pbpaste
  else if command -q powershell.exe
    powershell.exe get-clipboard | sed -z 's/\r\n$//'
  else if command -q xsel
    xsel --clipboard --output
  else
    return 1
  end
end
