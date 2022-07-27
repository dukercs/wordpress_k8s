# Wordpress_k8s
## Deploy wordpress e mariadb <br />
## Imagem Docker com exportadores para o prometheus do apache e mysql <br />
<br />
<br />
<hr />

## Necessário um .env.secret com as senhas do banco e a env do exporter usado no banco <br />
### Exemplo:<br /><i>
mysql_root=SENHAROOT<br />
DATA_SOURCE_NAME=root:SENHAROOT@(wordpress-mysql:3306)/<br /></i>
## Execução do projeto <br />
Necessário AKS e ACR já configurados conforme projeto <https://github.com/dukercs/aks/><br />
<br />

## Clone este repositório 
<i>git clone <https://github.com/dukercs/wordpress_k8s.git><br />
cd wordpress_k8s</i>

## Build e push da imagem do wordpress dentro do subdir imagem <br />
<i>docker login de acordo com seu registry <br />
docker build -t dukercs/wordpress:1.10 <br />
docker push dukercs/wordpress:1.10 <br /></i>

## Criar o ambiente com o kustomize<br />
<i> k apply -k ./ </i><br />
Ele criará os namespaces e a aplicação wordpress com a imagem feita<br />
Namespaces: wordpress e monitoramento <br />

No namespace wordpress fica a aplicação e no monitoramento colocaremos o stack do prometheus e grafana/loki

### Acessando a aplicação, pegue o ip externo que o seu cloud provider disponibilizou pois a configuração do serviço está loadBalancer<br />
<i>kubectl get svc --namespace wordpress</i><br />

<hr />

## Instalar o loki com o stack da comunidade<br />
<i>helm upgrade --install loki --version 2.6.5 --namespace=monitoramento grafana/loki-stack --create-namespace <br /></i>

### Precisamos aguardar os pods do loki para isso podemos usar o k get pods ou esse hack para esperarmos<br />
<i>while [[ $(kubectl -n monitoramento get pods -l app=loki -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do echo "Esperando o pod ficar ready..." && sleep 1; done</i><br />

## Instalar o prometheus com scraps adicionais e outro usuário no grafana esses valores estão no values.yaml<br />
<i>helm upgrade --install prometheus --version 36.2.0 --namespace monitoramento prometheus-community/kube-prometheus-stack -f values.yaml</i><br />

## Acessando o grafana, como segurança achei melhor não deixar aberto o login então mantive a conf padrão, sende necessário montar uma porta local no pod<br />
<i>kubectl port-forward deployment/prometheus-grafana 3000 --namespace monitoramento</i><br />

### Abra seu navegador em <http://localhost:3000><br />
Usuário: dukercs<br />
Senha: prom-operator<br />
