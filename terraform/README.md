# How to use this module

```yaml
bt_instance = [
  {
    name              = "bigtable-instance-1"
    delete_protection = true
    cluster = [
      {
        cluster_id   = "bigtable-instance-cluster-1"
        storage_type = "SSD"  //optional
        zone         = "europe-west2-a"
        num_nodes    = 3  //optional
        kms_key_name = "projects/[project-id]/[region]/keyRings/key-ring-name/cryptoKeys/key-name"
      },
      {
        cluster_id   = "bigtable-instance-cluster-2"
        storage_type = "SSD"
        zone         = "europe-west2-b"
        num_nodes    = 3
        kms_key_name = "projects/[project-id]/[region]/keyRings/key-ring-name/cryptoKeys/key-name"
      }
    ]
  }
]
```

```yaml
bt_table = [
  {
    instance_name = "bigtable-instance-1"
    name          = "bt-table-1"
    split_keys    = ["KEY_RAND", "ASSET_NO", "N_ID"]  //optional
    //optional
    column_family = [
      { family = "first name" },
      { family = "last name" }
    ]
  }
]

```

## Optional resources
### bigtable app profile - Single Cluster Routing
```yaml
app_profile = [
  {
    app_profile_id = "bt-app-profile-single-cluster"
    instance = "bigtable-instance-1"
    ignore_warnings = false

    single_cluster_routing = [
      {
        cluster_id = "bigtable-instance-cluster-1"
        allow_transactional_writes = "true"
      }
    ]
  }
]

```

NB : `multi_cluster_routing_use_any` and `single_cluster_routing` are mutually exclusive.  
if the first one is set, please define `app_profile` like the following :  
```yaml
app_profile = [
  {
    app_profile_id = ""
    multi_cluster_routing_use_any = "" //optional
    instance = "" //optional
    ignore_warnings = "" //optional - true or false
    project = "" //optional

    single_cluster_routing = []
  }
]
```

### google_bigtable_gc_policy resource
```yaml
bt_policy = [
  {
    instance_name = ""
    table_name = ""
    column_family = ""
    project = "" //optional
    mode = "" //optional
    
    max_age = [
      {
        days = "" //optional
      }
    ]
  
    max_version = [
      {
        number = "" //optional
      }
    ]
  }
]
```

### Bigtable IAM Policy Binding to table instance
```yaml
bt_iam_policy = [
  {
    project     = ""
    instance    = "bigtable-instance-1"
    table       = "bt-table-1"
    policy_data = ""

  }
]
```