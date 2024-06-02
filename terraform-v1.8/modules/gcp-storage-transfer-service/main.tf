
resource "google_storage_transfer_job" "azure_to_gcp_service" {
  description = "Service used to transfer data from Azure to GCS"
  project     = var.project_id 

  transfer_spec {
    
    azure_blob_storage_data_source {
      storage_account = var.azure_storage_account #TODO: Set Azure Storage Account
      container = var.azure_container_name #TODO: Set Azure Container Name
      path = var.azure_file_path #TODO: Set Azure file path
      azure_crendentials {
        sas_token = var.azure_sas_token #TODO: Set Azure SAS Token
      }
    }
    gcs_data_sink {
      bucket_name = var.azure_to_gcs_bucket_name #TODO: Set GCS Bucket Name
      path        = var.azure_to_gcs_file_path #TODO: Set GCS file path
    }
  }

  schedule {
    #TODO: Configure dates and frecuency
    schedule_start_date {
      year  = 2018
      month = 10
      day   = 1
    }
    schedule_end_date {
      year  = 2019
      month = 1
      day   = 15
    }
    start_time_of_day {
      hours   = 23
      minutes = 30
      seconds = 0
      nanos   = 0
    }
    repeat_interval = "604800s"
  }

}