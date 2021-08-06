
# Step-4

Let's add some features to ready our server for production

- Use of the data.aws_ami data source to obtain the latest Ubuntu 20.04 cloud image

- Set the user_data field to point to a file webserver_boot.sh to initialize
  - Setup a website
  - Install Prometheus, Prometheus Node Exporter & Grafana for node monitoring

**Note:** Prometheus/Grafana step is incomplete requiring some manual steps to
- set admin password (other than default admin/admin)
- install a grafana dashboard for prometheus node exporter

