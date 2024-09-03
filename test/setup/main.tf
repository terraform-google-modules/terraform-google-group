/**
 * Copyright 2019 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// Have to add the random ID here and pass the value to tests instead of directly
// generate a random ID in tests because for_each in the module will complain
// the random ID is not known until apply.
provider "random" {
}

resource "random_id" "random_group_suffix" {
  byte_length = 2
}

data "terraform_remote_state" "org" {
  backend = "gcs"
  config = {
    bucket = "cft-infra-test-tfstate"
    prefix = "state/org"
  }
}

data "google_organization" "org" {
  organization = "organizations/${var.org_id}"
}

resource "google_organization_iam_member" "sa_org" {
  for_each = toset([
    "roles/resourcemanager.organizationViewer"
  ])

  org_id = var.org_id
  role   = each.value
  member = "serviceAccount:${data.terraform_remote_state.org.outputs.ci_gsuite_sa_email}"
}

# Create a temporary project to host group member service accounts to pass to the examples.
module "project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 16.0"

  name              = "ci-group"
  random_project_id = "true"
  org_id            = var.org_id
  folder_id         = var.folder_id
  billing_account   = var.billing_account

  activate_apis = [
    "cloudresourcemanager.googleapis.com",
    "serviceusage.googleapis.com"
  ]
}

resource "google_project_iam_member" "sa_project" {
  for_each = toset([
    "roles/iam.serviceAccountAdmin"
  ])

  project = module.project.project_id
  role    = each.value
  member  = "serviceAccount:${data.terraform_remote_state.org.outputs.ci_gsuite_sa_email}"
}
