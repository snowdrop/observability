# Observability

Scripts, documetation and examples on how to best deal with metrics, logs and tracing of [spring boot](https://spring.io/projects/spring-boot) Applications on [openshift](https://openshift.com).

## Metrics 

For metrics this project focuses on [prometheus](https://prometheus.io) and more specifically on using the [prometheus operator](https://github.com/coreos/prometheus-operator).
The [prometheus operator](https://github.com/coreos/prometheus-operator) provides of manifests for easy installation of the operator along with additional services like [grafana](https://grafana.com) etc.

These manifests are targeting vanilla [kubernetes](https://kubernetes.io) and will require some minor tunings in order to be applicable to [openshift](https://openshift.com).

The [install-kube-prometheus.sh](./scripts/install-kube-prometheus.sh) will take care of downloading, patching and applying those resources to openshift.

### Create ServiceMonitor for the application

In order to let prometheus scrape metrics for an application (using the operator) `ServiceMonitor` resource needs to be created.

    apiVersion: monitoring.coreos.com/v1
    kind: ServiceMonitor
    metadata:
      name: example-app
      labels:
        team: frontend
    spec:
      selector:
        matchLabels:
          app: example-app
      endpoints:
      - port: web
      
#### Create the ServiceMonitor using ap4k

To avoid hand crafting json/yaml files and manually matching labels, you can use [ap4k](https://github.com/ap4k/ap4k) in order to automatically generate a `ServiceMonitor` matching your application.
    
    import io.ap4k.openshift.annotation.OpenshiftApplication;
    import io.ap4k.prometheus.annotation.EnableServiceMonitor;

    @OpenshiftApplication
    @EnableServiceMonitor
    public class Main {
        public static void main(String[] args) {
          //Your code goes here
        }
    }
    
The example above should work out of the box, provided that the following dependencies are present:

    <dependency>
      <groupId>io.ap4k</groupId>
      <artifactId>openshift-spring-starter</artifactId>
      <version>${project.version}</version>
    </dependency>
    <dependency>
      <groupId>io.ap4k</groupId>
      <artifactId>prometheus-annotations</artifactId>
      <version>${project.version}</version>
    </dependency>
    
## Distributed Tracing

For distributed tracing this project focuses on [jaeger](https://www.jaegertracing.io) and also supports the use of the [jaeger operator](https://github.com/jaegertracing/jaeger-operator).

### Installing Jaeger via the Operator

To use the [jaeger operator](https://github.com/jaegertracing/jaeger-operator) on [openshift](https://openshift.com), simply run [install-jaeger-opertor.sh](./scripts/install/-jaeger-operator.sh).
Once the operator is installed, you can create a new jaeger using:

    oc create -f resources/simplest-jaeger.yml
    
Or if you want a [jaeger](https://www.jaegertracing.io) instance without the login screen:

    oc create -f resoureces/jaeger-nologin.yml
    
## Using the jaeger agent

To decouple the application from reaching out to jeager, one can use the [jaeger-agent](https://www.jaegertracing.io/docs/1.10/deployment/#agent) as a sidecar.
This can be performed:

- using the [jaeger operator](https://github.com/jaegertracing/jaeger-operator).
- manually

### Injecting the agent using the operator

To let the operator know in which pod the agent is meant to be injected use the following annotation `sidecar.jaegertracing.io/inject` with value `true`.

#### Sidecar inject using the operator and ap4k

To have [ap4k](https://github.com/ap4k/ap4k) add the annotation above where needed, you can use the `@EnableJaegerAgent` on the application:


    import io.ap4k.openshift.annotation.OpenshiftApplication;
    import io.ap4k.jaeger.annotation.EnableJaegerAgent;

    @OpenshiftApplication
    @EnableJaegerAgent(operatorEnabled=true)
    public class Main {
        public static void main(String[] args) {
          //Your code goes here
        }
    }
    
The example above should work out of the box, provided that the following dependencies are present:

    <dependency>
      <groupId>io.ap4k</groupId>
      <artifactId>openshift-spring-starter</artifactId>
      <version>${project.version}</version>
    </dependency>
    <dependency>
      <groupId>io.ap4k</groupId>
      <artifactId>jaeger-annotations</artifactId>
      <version>${project.version}</version>
    </dependency>
 
#### Sidecar inject with just ap4k

If for any reason the operator is not available, ap4k can inject the sidecar ahead of time (when generating the manifests).

    import io.ap4k.openshift.annotation.OpenshiftApplication;
    import io.ap4k.jaeger.annotation.EnableJaegerAgent;

    @OpenshiftApplication
    @EnableJaegerAgent
    public class Main {
        public static void main(String[] args) {
          //Your code goes here
        }
    }
 
 The only difference between the two approaches is the `operatorEnabled` property value.
(operatorEnabled=true)
