$destino = "D:\teste"
$relatorioPath = Join-Path $destino "relatorio.txt"

# Cria o diretório de destino se não existir
if (!(Test-Path -Path $destino)) {
    New-Item -ItemType Directory -Path $destino | Out-Null
}

# Lista todos os perfis de usuários (inclusive o atual)
$usuarios = Get-CimInstance -Class Win32_UserProfile | Where-Object {
    $_.LocalPath -like "C:\Users\*"
}

# Garante que o usuário atual esteja incluído
$usuarioAtualPath = $env:USERPROFILE
if ($usuarios.LocalPath -notcontains $usuarioAtualPath) {
    $usuarioAtual = [PSCustomObject]@{ LocalPath = $usuarioAtualPath }
    $usuarios += $usuarioAtual
}

# Pastas a copiar
$pastasParaCopiar = @("Downloads", "Desktop", "Documents", "Pictures", "Videos")

# Remove relatório anterior
if (Test-Path $relatorioPath) {
    Remove-Item $relatorioPath -Force
}
Add-Content -Path $relatorioPath -Value "Relatório de cópia de perfis - $(Get-Date)`r`n"

# Contador de perfis copiados
$perfisCopiados = 0

foreach ($usuario in $usuarios) {
    $nomeUsuario = Split-Path $usuario.LocalPath -Leaf
    $caminhoNovaPasta = Join-Path -Path $destino -ChildPath $nomeUsuario

    if (!(Test-Path -Path $caminhoNovaPasta)) {
        New-Item -ItemType Directory -Path $caminhoNovaPasta | Out-Null
    }

    $pastaCopiada = $false

    foreach ($pasta in $pastasParaCopiar) {
        $origem = Join-Path -Path $usuario.LocalPath -ChildPath $pasta
        $destinoFinal = Join-Path -Path $caminhoNovaPasta -ChildPath $pasta

        if (Test-Path -Path $origem) {
            # Verifica se é uma pasta real e não um link simbólico/junção
            $atributos = (Get-Item $origem).Attributes
            if ($atributos -band [System.IO.FileAttributes]::ReparsePoint) {
                Write-Output "⚠️ Pasta '$pasta' de ${nomeUsuario} é um link simbólico. Ignorando..."
                continue
            }

            try {
                robocopy $origem $destinoFinal /E /NFL /NDL /NJH /NJS /NC /NS | Out-Null
                Write-Output "✅ Pasta '$pasta' de ${nomeUsuario} copiada com sucesso."
                $pastaCopiada = $true
            } catch {
                Write-Output "❌ Erro ao copiar pasta '$pasta' de ${nomeUsuario}: $_"
            }
        } else {
            Write-Output "⚠️ Usuário ${nomeUsuario} não tem a pasta '$pasta'. Pulando..."
        }
    }

    # Se alguma pasta foi copiada, incrementa o contador
    if ($pastaCopiada) {
        $perfisCopiados++
    }

    # Calcula tamanho total das pastas copiadas do usuário
    if (Test-Path $caminhoNovaPasta) {
        $tamanhoTotalBytes = (Get-ChildItem -Path $caminhoNovaPasta -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
        $tamanhoMB = [math]::Round($tamanhoTotalBytes / 1MB, 2)
        $tamanhoGB = [math]::Round($tamanhoTotalBytes / 1GB, 2)
        Add-Content -Path $relatorioPath -Value "$nomeUsuario - ${tamanhoMB} MB (${tamanhoGB} GB)"
    } else {
        Add-Content -Path $relatorioPath -Value "$nomeUsuario - Pasta não copiada"
    }
}

# Adiciona total de perfis copiados ao relatório
Add-Content -Path $relatorioPath -Value "`r`nPerfis copiados com sucesso: $perfisCopiados"

# Mensagem final de conclusão
Write-Host "`n✅ Cópia finalizada com sucesso!" -ForegroundColor Green
Write-Host "📄 Relatório gerado em: $relatorioPath" -ForegroundColor Cyan
Write-Host "👥 Perfis copiados com sucesso: $perfisCopiados" -ForegroundColor Yellow
