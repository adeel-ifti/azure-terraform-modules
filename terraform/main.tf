
module "vpc" {

  source        = "./modules/vpc"
  vpc_name      = "vpc-gke"
  subnet_name   = "subnet-gke"
  region        = var.region
  project_id    = var.project_id
  ip_cidr_range = "10.10.10.0/24"
  ip_pod_range  = "10.60.0.0/14"
  ip_svc_range  = "10.64.0.0/20"

}

// module "gke" {

//   source                     = "./modules/gke"
//   project_id                 = var.project_id
//   name                       = var.gke_cluster_name
//   region                     = var.region
//   network                    = module.vpc.network
//   subnetwork                 = module.vpc.subnetwork
//   ip_range_pods              = module.vpc.ip_range_pod_name
//   ip_range_services          = module.vpc.ip_range_svc_name
//   release_channel            = "STABLE"
//   http_load_balancing        = true
//   horizontal_pod_autoscaling = false
//   grant_registry_access      = true
//   remove_default_node_pool   = true
//   node_pools = [
//     {
//       name            = "default-node-pool"
//       machine_type    = var.gke_machine_type
//       local_ssd_count = 0
//       disk_size_gb    = 100
//       autoscaling     = false
//       disk_type       = "pd-standard"
//       image_type      = "COS"
//       auto_repair     = true
//       auto_upgrade    = true
//       preemptible     = false
//       node_count      = var.gke_initial_node_count
//       node_locations  = "${var.region}-a,${var.region}-b"
//     },
//   ]
//   node_pools_oauth_scopes = {
//     all = [
//       "https://www.googleapis.com/auth/devstorage.read_only",
//       "https://www.googleapis.com/auth/logging.write",
//       "https://www.googleapis.com/auth/monitoring",
//       "https://www.googleapis.com/auth/service.management.readonly",
//     ]
//   }

//   depends_on = [
//     module.vpc
//   ]
// }

// module "bigquery" {

//   source = "./modules/bigquery"
//   dataset_id = var.dataset_id
//   dataset_name = var.dataset_name
//   description       = "some description"
//   expiration        = var.expiration
//   project_id        = var.project_id
//   location          = "US"
//   tables            = var.tables
//   time_partitioning = var.time_partitioning
//   dataset_labels    = var.dataset_labels
// }

module "bigdata" {
  source        = "./modules/bigtable"
  bt_instance   = var.bt_instance
  bt_table      = var.bt_table
  app_profile   = var.bt_app_profile
  bt_iam_policy = var.bt_iam_policy
}

// module "bigdata-tf12" {
//   source        = "./modules/bigtable_tf12"
//   bt_instance   = var.bt_instance
//   bt_table      = var.bt_table
//   app_profile   = var.bt_app_profile
//   bt_iam_policy = var.bt_iam_policy
// }

module "redis" {
  source             = "./modules/memstore"
  project            = var.project_id
  region             = var.region
  memory_size_gb     = var.redis_memory_size_gb
  name               = var.redis_name
  display_name       = var.redis_display_name
  authorized_network = module.vpc.network
  redis_version      = var.redis_version
  labels             = var.redis_labels
  tier               = var.redis_tier
}