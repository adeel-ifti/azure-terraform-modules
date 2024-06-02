module "gcp-storage-transfer-sts" {
  source                   = "./modules/gcp-storage-transfer-service"
  project_id               = "prj-gli-hub-cicd-dev-1"
  azure_storage_account    = "asdfdssss"
  azure_container_name     = "asdfdssss"
  azure_file_path          = "asdfdssss"
  azure_sas_token          = "asdfdssss"
  azure_to_gcs_file_path   = "asdfdssss"
  azure_to_gcs_bucket_name = "asdfdssss"

}