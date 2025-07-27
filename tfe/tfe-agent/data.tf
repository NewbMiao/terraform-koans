# eg use ACK of Alibaba Cloud, or use local k8s cluster for development
# data "alicloud_cs_managed_kubernetes_clusters" "cluster" {
#   name_regex     = "ack-tfc-agent"
#   enable_details = true
# }
# data "alicloud_cs_cluster_credential" "cluster_credential" {
#   cluster_id = data.alicloud_cs_managed_kubernetes_clusters.cluster.clusters[0].id
# }
