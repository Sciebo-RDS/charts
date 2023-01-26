# Sciebo RDS Helm Charts

ATTENTION:
currently this is WIP.

Productive helmcharts so far are in the "big" repo.

Please stand by. ;-)

This repo holds all charts for the sciebo rds microservices.

### Dependencies

This chart also use [jaeger](https://github.com/jaegertracing/helm-charts) and [redis-cluster](https://github.com/bitnami/charts/tree/master/bitnami/redis-cluster). Take a look to the corresponding repositories to find all options.

### Uninstall 

With the following command, you can remove the sciebo-rds system from your cluster.

```bash
helm uninstall sciebo-rds
```
