# Sciebo RDS Chart Repo

Helm Chart Repository for the Sciebo RDS project.

The chart repository is available at [https://github.com/Sciebo-RDS/charts](https://github.com/Sciebo-RDS/charts).

## Working with the repo

Add the chart repo:

```bash
helm repo add sciebo-rds https://sciebo-rds.github.io/charts/
```

Verify it's available and search for charts:

```bash
helm repo list
helm search repo sciebo-rds
```

### Install the RDS

You can find detailed instructions on how to configure and deploy the RDS on the [Sciebo RDS docs](https://www.research-data-services.org/doc/getting-started/requirements/).
