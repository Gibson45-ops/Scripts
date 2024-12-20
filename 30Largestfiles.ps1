# Finds the 30 Largest Files (Not Folders) in  C:\Users Then lists them with size and location in a TXT file located at C:\Temp\top_30_files.txt #
Get-ChildItem -Path C:\Users\* -Recurse -Include * |
  Sort-Object Length -Descending |
  Select-Object -First 30 |
  ForEach-Object {
    if ($_.PSIsContainer) {
      $folderSize = (Get-ChildItem -Path $_.FullName -Recurse | Measure-Object -Property Length -Sum).Sum
      $sizeInMB = [math]::Round($folderSize / 1MB, 2)
      "$($_.FullName) - $sizeInMB MB"
    } else {
      $sizeInMB = [math]::Round($_.Length / 1MB, 2)
      "$($_.FullName) - $sizeInMB MB"
    }
  } | Out-File -FilePath C:\Windows\Temp\top_30_items.txt

