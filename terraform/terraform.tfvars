project_id             = "gcp-bigdata-demo-1"
gke_cluster_name       = "gke-bigdata-demo"
gke_machine_type       = "n1-standard-1"
region                 = "us-west1"
zone                   = "us-west1-a"
gke_initial_node_count = 2
dataset_id             = "foo"
dataset_name           = "bar"
expiration             = 3600000
dataset_labels = {
  env      = "dev"
  billable = "true"
  owner    = "janesmith"
}
time_partitioning = "DAY"



tables = [
  {
    table_id = "foo",
    schema   = "sample_bq_schema.json",
    labels = {
      env      = "dev"
      billable = "true"
      owner    = "joedoe"
    },
  },
]


bt_instance = [
  {
    name              = "bigtable-instance-1"
    delete_protection = true
    labels = {
      "env"        = "dev"
      "managed-by" = "terraform"
    }
    cluster = [
      {
        cluster_id   = "bigtable-instance-cluster-1"
        storage_type = "SSD"
        zone         = "europe-west2-a"
        num_nodes    = 3
        // kms_key_name = "projects/[project-id]/[region]/keyRings/key-ring-name/cryptoKeys/key-name"
      },
      {
        cluster_id   = "bigtable-instance-cluster-2"
        storage_type = "SSD"
        zone         = "europe-west2-b"
        num_nodes    = 3
        // kms_key_name = "projects/[project-id]/[region]/keyRings/key-ring-name/cryptoKeys/key-name"
      }
    ]
  }
]

bt_table = [
  {
    instance_name = "bigtable-instance-1"
    name          = "bt-table-1"
    split_keys    = ["KEY_RAND", "ASSET_NO", "N_ID"]
    column_family = [
      { family = "first-name" },
      { family = "last-name" }
    ]
  }
]

bt_app_profile = [
  {
    app_profile_id  = "bt-app-profile-single-cluster"
    instance        = "bigtable-instance-1"
    ignore_warnings = false
    single_cluster_routing = [
      {
        cluster_id                 = "bigtable-instance-cluster-1"
        allow_transactional_writes = "true"
      }
    ]
  }
]


bt_policy = [
  {
    instance_name = "bigtable-instance-1"
    table_name    = "bt-table-1"
    column_family = [
      { family = "first-name" },
      { family = "last-name" }
    ]

    max_age = [
      {
        days = "60"
      }
    ]

    max_version = [
      {
        number = "200"
      }
    ]
  }
]


// data "google_iam_policy" "user" {
//   binding {
//     role = "roles/bigtable.user"
//     members = [
//       "user:jane@example.com",
//     ]
//   }
// }

// bt_iam_policy = [
//   {
//     instance    = "bigtable-instance-1"
//     table       = "bt-table-1"
//     policy_data = data.google_iam_policy.admin.policy_data
//   }
// ]

redis_memory_size_gb    = "1"
redis_name              = "redis-instance-1"
redis_version           = "REDIS_4_0"
redis_display_name      = "redis instance"
redis_tier              = "STANDARD_HA"
reserved_ip_range       = "192.168.0.0/29"
transit_encryption_mode = "SERVER_AUTHENTICATION"
auth_enabled            = true
connect_mode            = "PRIVATE_SERVICE_ACCESS"

redis_labels = {
  "env"        = "dev"
  "managed-by" = "terraform"
}