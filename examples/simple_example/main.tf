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

provider "google-beta" {
  version = "~> 3.0"
  # Required if using User ADCs (Application Default Credentials) for Cloud Identity API.
  user_project_override = true
  billing_project       = var.project_id
}

module "child_group" {
  source = "../.."

  id           = "example-child-group@${var.domain}"
  display_name = "example-child-group"
  description  = "Example child group"
  domain       = var.domain
  managers     = [var.manager_service_account_email]
  members      = [var.member_service_account_email]
}

module "group" {
  source = "../.."

  id           = "example-group@${var.domain}"
  display_name = "example-group"
  description  = "Example group"
  domain       = var.domain
  members      = [module.child_group.id]
}
