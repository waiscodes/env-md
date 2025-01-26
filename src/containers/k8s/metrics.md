# Metrics & Service Monitors

To keep track of the health of your services you can setup a [monitoring.coreos.com/v1.ServiceMonitor](https://prometheus-operator.dev/docs/api-reference/api/#monitoring.coreos.com/v1.ServiceMonitor) resource.

This resource defines a service that will be monitored, and what endpoints, authentication, interval, etc to use.

## Creating your first ServiceMonitor

To create a ServiceMonitor you need to create a `ServiceMonitor` resource.

```yaml
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: my-service-monitor
  namespace: my-app
spec:
  selector:
    matchLabels:
      app: my-app
  endpoints:
    - port: http
      interval: 30s
      path: /metrics
```

The above service monitor will monitor the `http` port on the `my-app` namespace, and will scrape the `/metrics` endpoint every 30 seconds.

## Service Implementation

On the side of your service you will need to expose an http endpoint (generally `/metrics`) that returns the metrics in a format that Prometheus can scrape.

An example of what this output might look like is:

```yaml
# HELP my_metric_1 A metric
# TYPE my_metric_1 gauge
my_metric_1 1.0
```
