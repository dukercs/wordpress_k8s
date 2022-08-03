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
```console
git clone https://github.com/dukercs/wordpress_k8s.git
cd wordpress_k8s
```

## Build e push da imagem do wordpress dentro do subdir imagem <br />
docker login de acordo com seu registry <br />
```console
docker build -t dukercs/wordpress:1.10
docker push dukercs/wordpress:1.10
```
## Criar o ambiente com o kustomize<br />
```console
k apply -k ./
```
Ele criará os namespaces e a aplicação wordpress com a imagem feita<br />
Namespaces: wordpress e monitoramento <br />

No namespace wordpress fica a aplicação e no monitoramento colocaremos o stack do prometheus e grafana/loki

### Acessando a aplicação, pegue o ip externo que o seu cloud provider disponibilizou pois a configuração do serviço está loadBalancer<br />
```console
kubectl get svc --namespace wordpress
```
<hr />

## Instalar o loki com o stack da comunidade<br />
```console
helm repo add grafana https://grafana.github.io/helm-charts

helm repo update

helm upgrade --install loki --version 2.6.5 --namespace=monitoramento grafana/loki-stack --create-namespace
```

### Precisamos aguardar os pods do loki para isso podemos usar o k get pods ou esse hack para esperarmos<br />
```console
while [[ $(kubectl -n monitoramento get pods -l app=loki -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do echo "Esperando o pod ficar ready..." && sleep 1; done
```

## Instalar o prometheus com scraps adicionais e outro usuário no grafana esses valores estão no values.yaml<br />
```console
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

helm repo update

helm upgrade --install prometheus --version 36.2.0 --namespace monitoramento prometheus-community/kube-prometheus-stack -f values.yaml
```



## Acessando o grafana, como segurança achei melhor não deixar aberto o login então mantive a conf padrão, sende necessário montar uma porta local no pod<br />
```console 
kubectl port-forward deployment/prometheus-grafana 3000 --namespace monitoramento
```

### Abra seu navegador em <http://localhost:3000><br />
Usuário: dukercs<br />
Senha: prom-operator<br />
