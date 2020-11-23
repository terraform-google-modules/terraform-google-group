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

data "terraform_remote_state" "org" {
  backend = "gcs"
  config = {
    bucket = "cft-infra-test-tfstate"
    prefix = "state/org"
  }
}

data "google_organization" "org" {
  organization = "organizations/${data.terraform_remote_state.org.outputs.org_id}"
}

resource "google_organization_iam_member" "sa_org" {
  for_each = toset([
    "roles/resourcemanager.organizationViewer"
  ])

  org_id = data.terraform_remote_state.org.outputs.org_id
  role   = each.value
  member = "serviceAccount:${data.terraform_remote_state.org.outputs.ci_gsuite_sa_email}"
}
