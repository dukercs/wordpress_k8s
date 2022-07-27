# wordpress_k8s
## Deploy wordpress e mariadb <br />
Imagem dockerfile com exportadores para o prometheus <br />
## Necessário um .env.secret com as senhas do banco e a env do exporter usado no banco <br />
### Exemplo:<br /><i>
mysql_root=SENHAROOT<br />
DATA_SOURCE_NAME=root:SENHAROOT@(wordpress-mysql:3306)/<br /></i>
## Execução do projeto <br />
Necessário AKS e ACR já configurados conforme projeto <https://github.com/dukercs/aks/>
