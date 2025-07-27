provider "alicloud" {}
# Enable this block after the ACK cluster is created
provider "kubernetes" {
  host                   = data.alicloud_cs_managed_kubernetes_clusters.cluster.clusters[0].connections.api_server_internet
  client_certificate     = base64decode(data.alicloud_cs_cluster_credential.cluster_credential.certificate_authority.client_cert)
  client_key             = base64decode(data.alicloud_cs_cluster_credential.cluster_credential.certificate_authority.client_key)
  cluster_ca_certificate = base64decode(data.alicloud_cs_cluster_credential.cluster_credential.certificate_authority.cluster_cert)
}

# Enable this block after the ACK cluster is created
provider "helm" {
  kubernetes {
    host                   = data.alicloud_cs_managed_kubernetes_clusters.cluster.clusters[0].connections.api_server_internet
    client_certificate     = base64decode(data.alicloud_cs_cluster_credential.cluster_credential.certificate_authority.client_cert)
    client_key             = base64decode(data.alicloud_cs_cluster_credential.cluster_credential.certificate_authority.client_key)
    cluster_ca_certificate = base64decode(data.alicloud_cs_cluster_credential.cluster_credential.certificate_authority.cluster_cert)
  }
}
