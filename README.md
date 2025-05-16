# BKPAutomaticUser

## Contexto

Em empresas que tem controle sobre sua rede, provavelmente o controle é feito através de usuarios no domínio corporativo.
Com isso, o suporte técnico de TI, sofre constantemente com a realização de backup's de máquinas com inúmeros usuarios cadastrado.


## Solução

Através de script em Powershell, foi realizado uma automação para realização de Backup's de usuarios que ja estiveram logado na máquina problemática.


## Arquivo de Backup

![image](https://github.com/user-attachments/assets/a49974cf-24b2-49d8-8ca1-68fcb200af4a)

O arquivo acima, realiza o backup automático das pastas: "Desktop", "Documents", "Downloads", "Pictures" e "Videos" dos perfis logados na máquina, além de imprimir um relatório que registra o nome dos perfis e o tamanho de cada. 

## Exibição em Powershell

![image](https://github.com/user-attachments/assets/b52d1f3b-2f81-4539-a4fb-ce0ebcb2c808)


## Relatório Gerado em txt

![image](https://github.com/user-attachments/assets/0b826d15-61ec-4571-bbeb-1d21d191d897)



# Contador

![image](https://github.com/user-attachments/assets/3b97343e-78c6-4911-96e8-c034ec556864)

O arquivo acima, conta a quantidade de usuários presentes na máquina, com isso, oferece suporte, caso precise verificar se a quantidade de usuarios na máquina, bate com a quantidade de usuários copiados pelo Script.

# Lembrete

O Script não copia aquivos locados antes do diretório "C:\Users".
