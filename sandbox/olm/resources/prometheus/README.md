## Instructions

If OLM is deployed like the `operatorhub` catalog, then deploy the prometheus operator using the following commands:
```bash
kc -n demo apply -f resources/prometheus/single-operatorgroup.yml
kc -n demo apply -f resources/prometheus/subscription.yml
```

- Git clone the dekorate project and build the example of Spring Boot Prometheus
```bash
git clone https://github.com/dekorateio/dekorate.git & cd dekorate/examples/spring-boot-with-prometheus-on-kubernetes-example
mvn clean install
```
- Build the project as a container image and push it on your registry
```bash
docker build -t cmoulliard/spring-boot-prometheus .
docker push cmoulliard/spring-boot-prometheus
```

- Deploy the Spring Boot Prometheus application on the cluster, its service and ingress route
```bash
kc apply -n demo -f resources/prometheus/01-dep.yml
kc apply -n demo -f resources/prometheus/02-svc.yml
kc apply -n demo -f resources/prometheus/04-ingress.yml
```

- Create a Prometheus instance and `ServiceMonitor`
```bash
kc apply -n demo -f resources/prometheus/05-prometheus.yml
kc apply -n demo -f resources/prometheus/03-servicemonitor.yml
```

03-servicemonitor.yml