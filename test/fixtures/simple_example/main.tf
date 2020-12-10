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

# Delete the example groups if they exist. The groups might be left undeleted due
# to previously failed test runs.
resource "null_resource" "cleanup_groups" {
  provisioner "local-exec" {
    command = <<EOT
      if gcloud identity groups describe example-group@${var.domain} 2>&1 ; then
        gcloud identity groups delete example-group@${var.domain} --quiet
      fi

      if gcloud identity groups describe example-child-group@${var.domain} 2>&1 ; then
        gcloud identity groups delete example-child-group@${var.domain} --quiet
      fi
  EOT
  }
}

module "example" {
  source = "../../../examples/simple_example"

  project_id = var.project_id
  domain     = var.domain
  depends_on = [
    null_resource.cleanup_groups
  ]
}
