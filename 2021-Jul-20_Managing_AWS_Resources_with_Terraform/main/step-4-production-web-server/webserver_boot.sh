#!/bin/bash

SCRIPT=$(basename $0)

PROM_VERSION=2.28.1
PROM_NODE_EXP_VERSION=1.2.0
GRAFANA_VERSION=8.0.6
GRAFTERM_VERSION=0.2.0

INSTALL_PROMETHEUS_GRAFANA_INSTALL_DIR=/home/ubuntu/prometheus-grafana

START_WEBSERVER() {
    [ -d simple-webslides ] && rm -rf simple-webslides
    git clone https://github.com/mjbright/simple-webslides
    cd simple-webslides

    sed -i.bak "s/served from carbon/served from $(hostname -f)/" index.html
    python3 -m http.server --bind 0.0.0.0 80  >/var/webserver.log 2>&1 &
}

# -- install Prometheus/Grafana/Grafterm:
# Inspired by:
# https://medium.com/javarevisited/prometheus-grafana-setup-to-visualize-your-servers-924773b83f3f

## == Functions ================================================================

die() { echo "$0: $*" >&2; exit 1; }

INSTALL_PROMETHEUS_GRAFANA() {
    #sudo -i -u ubuntu bash -c 'id; pwd'

    mkdir -p $INSTALL_PROMETHEUS_GRAFANA_INSTALL_DIR
    cd       $INSTALL_PROMETHEUS_GRAFANA_INSTALL_DIR

    INSTALL_PROMETHEUS $PROM_VERSION
    INSTALL_PROMETHEUS_NODE_EXPORTER $PROM_NODE_EXP_VERSION
    INSTALL_GRAFANA $GRAFANA_VERSION
    INSTALL_GRAFTERM $GRAFTERM_VERSION
}

START_PROMETHEUS_GRAFANA() {
    ./prometheus     > $LOGDIR/prometheus.log 2>&1 &

    ./node_exporter  > $LOGDIR/prometheus-node_exporter.log 2>&1 &

    ./grafana-server > $LOGDIR/grafana-server.log 2>&1 &
}

## -- PROMETHEUS -----------------------------------------------------

INSTALL_PROMETHEUS() {
    local VERSION=$1
    echo "-- Instaling Prometheus version $VERSION to $PWD"

    wget -q https://github.com/prometheus/prometheus/releases/download/v${VERSION}/prometheus-${VERSION}.linux-amd64.tar.gz
    tar xf prometheus-${VERSION}.linux-amd64.tar.gz
    cp -a prometheus-${VERSION}.linux-amd64/prometheus     .
    cp -a prometheus-${VERSION}.linux-amd64/prometheus.yml .

    mv prometheus-${VERSION}.linux-amd64.tar.gz $ARCDIR/
    mv prometheus-${VERSION}.linux-amd64/       $TMPDIR/
}

## -- PROMETHEUS NODE EXPORTER -------

INSTALL_PROMETHEUS_NODE_EXPORTER() {
    local VERSION=$1
    echo "-- Instaling Prometheus node_exporter version $VERSION to $PWD"

    wget -q https://github.com/prometheus/node_exporter/releases/download/v${VERSION}/node_exporter-${VERSION}.linux-amd64.tar.gz
    tar xf node_exporter-${VERSION}.linux-amd64.tar.gz
    cp -a node_exporter-${VERSION}.linux-amd64/node_exporter .

    mv node_exporter-${VERSION}.linux-amd64.tar.gz $ARCDIR/
    mv node_exporter-${VERSION}.linux-amd64/       $TMPDIR/

    # Configure node_exporter in prometheus.yml:
    [ ! -f prometheus.yml.orig ] && cp -a prometheus.yml prometheus.yml.orig
    grep -q localhost:9100 prometheus.yml || 
        sed "s/'localhost:9090'/'localhost:9090','localhost:9100'/" < prometheus.yml.orig > prometheus.yml
}

## -- GRAFANA    -----------------------------------------------------

INSTALL_GRAFANA() {
    local VERSION=$1
    echo "-- Instaling Grafana version $VERSION to $PWD"

    wget -q https://dl.grafana.com/oss/release/grafana-${VERSION}.linux-amd64.tar.gz
    tar xf grafana-${VERSION}.linux-amd64.tar.gz
    cp -a grafana-${VERSION}/bin/grafana-cli    .
    cp -a grafana-${VERSION}/bin/grafana-server .
    cp -a grafana-${VERSION}/public             .
    cp -a grafana-${VERSION}/conf               .

    mv grafana-${VERSION}.linux-amd64.tar.gz  $ARCDIR/
    mv grafana-${VERSION}/                    $TMPDIR/
}

## -- GRAFTERM   ---------------------

INSTALL_GRAFTERM() {
    local VERSION=$1
    echo "-- Instaling Grafterm version $VERSION to $PWD"

    git clone https://github.com/slok/grafterm slok.grafterm
    cp -a slok.grafterm/dashboard-examples grafterm-dashboard-examples

    wget -q -O grafterm https://github.com/slok/grafterm/releases/download/v${GRAFTERM_VERSION}/grafterm-linux-amd64
    chmod +x grafterm
    CREATE_JSON

    cat > ~/grafterm.sh <<EOF
    cd $PWD

    ./grafterm -c grafterm_cpu_temp.json
EOF
    chmod +x ~/grafterm.sh

}

CREATE_JSON() {
    cat > grafterm_cpu_temp.json <<"EOF"
{
  "version": "v1",
  "datasources": {
    "ds": {
      "prometheus": {
        "address": "http://127.0.0.1:9090"
      }
    }
  },
  "dashboard": {
    "grid": {
      "maxWidth": 100
    },
    "widgets": [
      {
        "title": "Stack",
        "gridPos": { "w": 20 },
        "singlestat": {
          "unit": "bytes",
          "thresholds": [{ "color": "#22F1F1" }],
          "query": {
            "datasourceID": "prometheus",
            "expr": "sum(go_memstats_stack_inuse_bytes{job=\"{{.job}}\"})"
          }
        }
      },
      {
        "title": "CPU Temp",
        "gridpos": { "w": 80 },
        "graph": {
          "visualization": {
            "yAxis": {
              "unit": "none",
              "decimals": 2
            }
          },
          "queries": [
            {
              "datasourceID": "ds",
              "expr": "min(node_hwmon_temp_celsius)",
              "legend": "min_cpu_temp"
            },
            {
              "datasourceID": "ds",
              "expr": "max(node_hwmon_temp_celsius)",
              "legend": "max_cpu_temp"
            },
            {
              "datasourceID": "ds",
              "expr": "avg(node_hwmon_temp_celsius)",
              "legend": "cpu_temp"
            }
          ]
        }
      }
    ]
  }
}
EOF
}

## == Main ===============================================

if [ "$1" = "-log" ]; then
    shift
else
    # Running as root:

    START_WEBSERVER
    cp -a $0            /tmp/boot_install.sh
    chown ubuntu:ubuntu /tmp/boot_install.sh
    chmod +x            /tmp/boot_install.sh
    time sudo -i -u ubuntu bash -c "/tmp/boot_install.sh -log $* 2>&1" |
        tee /tmp/${SCRIPT}.log
    exit $?
fi

# Running as ubuntu:

LOGDIR=/tmp/logs
TMPDIR=/tmp/tmp
ARCDIR=/tmp/arc
mkdir -p $ARCDIR $TMPDIR $LOGDIR
chmod a+rwx $ARCDIR $TMPDIR $LOGDIR

INSTALL_PROMETHEUS_GRAFANA
START_PROMETHEUS_GRAFANA



