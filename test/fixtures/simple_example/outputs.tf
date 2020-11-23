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

output "project_id" {
  description = "The ID of the project in which to provision resources and used for billing"
  value       = var.project_id
}

output "domain" {
  description = "Domain of the organization to create the group in"
  value       = var.domain
}

output "member_service_account_email" {
  description = "Email of the service account to grant the MEMBER role in the group"
  value       = var.member_service_account_email
}

output "manager_service_account_email" {
  description = "Email of the service account to grant the MANAGER role in the group"
  value       = var.manager_service_account_email
}
