# Lista os perfis de usuário locais em C:\Users
$usuarios = Get-CimInstance -Class Win32_UserProfile | Where-Object {
    $_.LocalPath -like "C:\Users\*"
}

# Extrai apenas o nome dos usuários (última parte do caminho)
$nomesUsuarios = $usuarios | ForEach-Object {
    Split-Path $_.LocalPath -Leaf
}

# Remove nomes duplicados (se houver)
$nomesUnicos = $nomesUsuarios | Sort-Object -Unique

# Exibe os nomes dos usuários
Write-Host "Lista de usuários encontrados:"
$nomesUnicos | ForEach-Object { Write-Host " - $_" }

# Exibe a contagem total
Write-Host "`nTotal de usuários com perfil local: $($nomesUnicos.Count)"

# Prepara o conteúdo para salvar no arquivo
$conteudo = @()
$conteudo += "Lista de usuários encontrados:"
$conteudo += $nomesUnicos | ForEach-Object { " - $_" }
$conteudo += ""
$conteudo += "Total de usuários com perfil local: $($nomesUnicos.Count)"

# Salva o conteúdo em arquivo.txt no diretório atual
$arquivo = ".\usuarios_local.txt"
$conteudo | Out-File -FilePath $arquivo -Encoding UTF8

Write-Host "`nLista salva em $arquivo"
