#/bin/bash 

TMPDIR=$(mktemp -d /tmp/prometheus.XXXXXXXXX)

echo "Using temporary directory $TMPDIR."
pushd $TMPDIR

OPERATOR_VERSION="v0.28.0"
echo "Cloning git@github.com:coreos/prometheus-operator.git / Version: ${OPERATOR_VERSION}"
git clone --branch ${OPERATOR_VERSION} git@github.com:coreos/prometheus-operator.git

pushd prometheus-operator
ls contrib/kube-prometheus/manifests/* | while read manifest; do echo "Removing runAsUser: 65534 or 1000 from $manifest"; sed -i '/runAsUser:[ ]*\(65534\|1000\)/d' $manifest;done
ls contrib/kube-prometheus/manifests/* | while read manifest; do echo "Removing fsGroup: 2000 from $manifest"; sed -i '/fsGroup:[ ]*2000/d' $manifest;done

# This suffers from a race condition so lets install resources one by one and add some sleep
ls contrib/kube-prometheus/manifests/* | while read manifest; do echo "Installing $manifest"; oc create -f $manifest; sleep 1;done

popd
popd
