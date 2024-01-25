resource "yandex_storage_object" "picture" {
  bucket     = "static-picture"
  key        = "3hero.jpg"
  source     = "../pic/pic.jpg"
  content_type = "image"
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  depends_on = [yandex_storage_bucket.static-picture]
}

#Create SA
resource "yandex_iam_service_account" "sa" {
  folder_id = var.folder_id
  name      = "bucket-sa"
}

# Grant permissions
resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
  role      = "storage.editor"
  folder_id = var.folder_id
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

# Create Static Access Keys
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa.id
  description        = "static access key for object storage"
}

# Use keys to create bucket
resource "yandex_storage_bucket" "static-picture" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = "static-picture"
  anonymous_access_flags {
    read = true
    list = false
  }

}