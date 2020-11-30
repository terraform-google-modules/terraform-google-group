/**
 * Copyright 2018 Google LLC
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

# Required if using User ADCs (Application Default Credentials) for Cloud Identity API.
# provider "google-beta" {
#   version = "~> 3.0"
#   user_project_override = true
#   billing_project       = var.project_id
# }

resource "google_service_account" "manager" {
  project      = var.project_id
  account_id   = "example-manager"
  display_name = "example-manager"
}

resource "google_service_account" "member" {
  project      = var.project_id
  account_id   = "example-member"
  display_name = "example-member"
}

module "child_group" {
  source = "../.."

  id           = "example-child-group@${var.domain}"
  display_name = "example-child-group"
  description  = "Example child group"
  domain       = var.domain
  managers     = ["${google_service_account.manager.account_id}@${var.project_id}.iam.gserviceaccount.com"]
  members      = ["${google_service_account.member.account_id}@${var.project_id}.iam.gserviceaccount.com"]
}

module "group" {
  source = "../.."

  id           = "example-group@${var.domain}"
  display_name = "example-group"
  description  = "Example group"
  domain       = var.domain
  members      = [module.child_group.id]
}
