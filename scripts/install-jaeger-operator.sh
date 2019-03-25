#!/bin/bash

oc new-project observability
oc create -f https://raw.githubusercontent.com/jaegertracing/jaeger-operator/master/deploy/crds/jaegertracing_v1_jaeger_crd.yaml
oc create -f https://raw.githubusercontent.com/jaegertracing/jaeger-operator/master/deploy/service_account.yaml
oc create -f https://raw.githubusercontent.com/jaegertracing/jaeger-operator/master/deploy/role.yaml
oc create -f https://raw.githubusercontent.com/jaegertracing/jaeger-operator/master/deploy/role_binding.yaml
oc create -f https://raw.githubusercontent.com/jaegertracing/jaeger-operator/master/deploy/operator.yaml
