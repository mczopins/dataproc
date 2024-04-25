project_id  = "gcp-demos-workflows-29966"
cluster_name = "dev-cluster-1"
# Remember to enable the google private access if you do not use external_ip
network = "gcp-demos-internal-network"
region = "europe-central2"
zone = "europe-central2-a"
external_ip = "false"
iam_roles = {
  dataproc_admin  = { "role" : "roles/dataproc.admin"},
  dataproc_worker = { "role" : "roles/dataproc.worker"},
  storage_objectCreator = { "role" : "roles/storage.objectCreator"},
  storage_objectViewer = { "role" : "roles/storage.objectViewer"}
}