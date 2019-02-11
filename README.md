# Observability

Scripts, documetation and examples on how to best deal with metrics, logs and tracing of [spring boot](https://spring.io/projects/spring-boot) Applications on [openshift](https://openshift.com).

## Metrics 

For metrics this project focuses on [prometheus](https://prometheus.io) and more specifically on using the [prometheus operator](https://github.com/coreos/prometheus-operator).
The [prometheus operator](https://github.com/coreos/prometheus-operator) provides of manifests for easy installation of the operator along with additional services like [grafana](https://grafana.com) etc.

These manifests are targeting vanilla [kubernetes](https://kubernetes.io) and will require some minor tunings in order to be applicable to [openshift](https://openshift.com).

The [install-kube-prometheus.sh](./scripts/install-kube-prometheus.sh) will take care of downloading, patching and applying those resources to openshift.


