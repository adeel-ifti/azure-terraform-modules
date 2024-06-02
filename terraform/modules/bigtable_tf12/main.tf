resource "google_bigtable_instance" "bt_instance" {
  count               = length(var.bt_instance)
  name                = lookup(var.bt_instance[count.index], "name")
  display_name        = lookup(var.bt_instance[count.index], "display_name", null)
  deletion_protection = lookup(var.bt_instance[count.index], "delete_protection", true)
  labels              = lookup(var.bt_instance[count.index], "labels", null)

  dynamic "cluster" {
    for_each = lookup(var.bt_instance[count.index], "cluster")
    content {
      cluster_id   = lookup(cluster.value, "cluster_id")
      zone         = lookup(cluster.value, "zone", null)
      num_nodes    = lookup(cluster.value, "num_nodes", null)
      storage_type = lookup(cluster.value, "storage_type", null)
      kms_key_name = lookup(cluster.value, "kms_key_name", null)
    }
  }
}

resource "google_bigtable_table" "ggl_bt_table" {
  count         = length(var.bt_instance) == 0 ? 0 : length(var.bt_table)
  instance_name = element(google_bigtable_instance.bt_instance.*.name, index(google_bigtable_instance.bt_instance.*.name, lookup(var.bt_table[count.index], "instance_name")))
  name          = lookup(var.bt_table[count.index], "name")
  split_keys    = lookup(var.bt_table[count.index], "split_keys", null)

  dynamic "column_family" {
    for_each = lookup(var.bt_table[count.index], "column_family")
    content {
      family = lookup(column_family.value, "family", null)
    }
  }
}

resource "google_bigtable_app_profile" "bt_app_profile" {
  count                         = length(var.app_profile)
  app_profile_id                = lookup(var.app_profile[count.index], "app_profile_id")
  multi_cluster_routing_use_any = lookup(var.app_profile[count.index], "multi_cluster_routing_use_any", null)
  instance                      = lookup(var.app_profile[count.index], "instance", null)
  ignore_warnings               = lookup(var.app_profile[count.index], "ignore_warnings", null)
  project                       = lookup(var.app_profile[count.index], "project", null)

  dynamic "single_cluster_routing" {
    for_each = lookup(var.app_profile[count.index], "single_cluster_routing")
    content {
      cluster_id                 = lookup(single_cluster_routing.value, "cluster_id", null)
      allow_transactional_writes = lookup(single_cluster_routing.value, "allow_transactional_writes", null)
    }
  }
}

resource "google_bigtable_table_iam_policy" "bt_iam_policy" {
  count       = length(var.bt_iam_policy)
  project     = lookup(var.bt_iam_policy[count.index], "project", null)
  instance    = lookup(var.bt_iam_policy[count.index], "instance", null)
  table       = lookup(var.bt_iam_policy[count.index], "table", null)
  policy_data = lookup(var.bt_iam_policy[count.index], "policy_data", null)
}

resource "google_bigtable_gc_policy" "bt_gc_policy" {
  count         = length(var.bt_policy)
  column_family = lookup(var.bt_policy[count.index], "column_family")
  instance_name = element(google_bigtable_instance.bt_instance.*.name, lookup(var.bt_policy[count.index], "instance_name"))
  table         = element(google_bigtable_table.ggl_bt_table.*.name, lookup(var.bt_policy[count.index], "table_name"))
  project       = lookup(var.bt_policy[count.index], "project", null)
  mode          = lookup(var.bt_policy[count.index], "mode", null)

  dynamic "max_age" {
    for_each = lookup(var.bt_policy[count.index], "max_age")
    content {
      days = lookup(max_age.value, "days", null)
    }
  }

  dynamic "max_version" {
    for_each = lookup(var.bt_policy[count.index], "max_version")
    content {
      number = lookup(max_version.value, "number", null)
    }
  }
}