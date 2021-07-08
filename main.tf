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

data "google_organization" "org" {
  count  = var.domain != "" ? 1 : 0
  domain = var.domain
}

locals {
  customer_id = var.domain != "" ? data.google_organization.org[0].directory_customer_id : var.customer_id
  type        = "default"
  label_keys = {
    "default" = "cloudidentity.googleapis.com/groups.discussion_forum"
    # Placeholders according to https://cloud.google.com/identity/docs/groups#group_properties.
    # Not supported by provider yet.
    "dynamic"  = "cloudidentity.googleapis.com/groups.dynamic"
    "security" = "cloudidentity.googleapis.com/groups.security"
    "external" = "system/groups/external"
  }
}

resource "google_cloud_identity_group" "group" {
  provider     = google-beta
  display_name = var.display_name
  description  = var.description

  parent = "customers/${local.customer_id}"

  initial_group_config = var.initial_group_config

  group_key {
    id = var.id
  }

  labels = {
    local.label_keys[local.type] = ""
  }
}

resource "google_cloud_identity_group_membership" "owners" {
  for_each = toset(var.owners)

  provider = google-beta
  group    = google_cloud_identity_group.group.id

  preferred_member_key { id = each.key }

  # MEMBER role must be specified. The order of roles should not be changed.
  roles { name = "OWNER" }
  roles { name = "MEMBER" }
}

resource "google_cloud_identity_group_membership" "managers" {
  for_each = toset(var.managers)

  provider = google-beta
  group    = google_cloud_identity_group.group.id

  preferred_member_key { id = each.key }

  # MEMBER role must be specified. The order of roles should not be changed.
  roles { name = "MEMBER" }
  roles { name = "MANAGER" }
}

resource "google_cloud_identity_group_membership" "members" {
  for_each = toset(var.members)

  provider = google-beta
  group    = google_cloud_identity_group.group.id

  preferred_member_key { id = each.key }
  roles { name = "MEMBER" }
}
