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

output "id" {
  value       = google_cloud_identity_group.group.group_key[0].id
  description = "ID of the group. For Google-managed entities, the ID is the email address the group"
}

output "resource_name" {
  value       = google_cloud_identity_group.group.name
  description = "Resource name of the group in the format: groups/{group_id}, where group_id is the unique ID assigned to the group."
}
