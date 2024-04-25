variable "project_id" {
  type        = string
  description = "ID of the Google Project"
}

variable "account_id" {
  type        = string
  description = "Default Service Account ID for Dataproc"
  default     = "dataproc"
}

variable "iam_roles" {
  type = map(any)
}

variable "region" {
  type        = string
  description = "Default Region"
  default     = "europe-central2"
}

variable "zone" {
  type        = string
  description = "Default Zone"
  default     = "europe-central2-a"
}

variable "network" {
  type        = string
  description = "Default network"
  default     = "gcp-demos-internal-network"
}

variable "cluster_name" {
  type        = string
  description = "Name of the cluster"
  default     = "dev-cluster-1"
}

variable "machine_type" {
  type        = string
  description = "Machine Type"
  default     = "e2-micro"
}

variable "staging_bucket" {
  type        = string
  description = "Staging bucket"
  default     = "dataproc-staging-bucket"
}

variable "image_version" {
  type        = string
  description = "Image version for cluster nodes"
  default     = "2.0.35-debian10"
}

variable "external_ip"{
  type        = bool
}
