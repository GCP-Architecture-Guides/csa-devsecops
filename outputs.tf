##  Copyright 2023 Google LLC
##  
##  Licensed under the Apache License, Version 2.0 (the "License");
##  you may not use this file except in compliance with the License.
##  You may obtain a copy of the License at
##  
##      https://www.apache.org/licenses/LICENSE-2.0
##  
##  Unless required by applicable law or agreed to in writing, software
##  distributed under the License is distributed on an "AS IS" BASIS,
##  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
##  See the License for the specific language governing permissions and
##  limitations under the License.


##  This code creates demo environment for CSA - Application Development Architecture Pattern   ##
##  This demo code is not built for production workload ##


output "step1_follow_the_steps_to_register_service_account_for_Assured_OSS" {
  value     = module.app-dev._step1_follow_the_steps_to_register_service_account_for_OSS
}


output "step2_register_the_service_account_for_Assured_OSS" {
  value     = module.app-dev._step2_register_the_service_account_for_OSS
}


output "step3_execute_the_command_toget_workstation_HTTP_URL" {
  value = module.app-dev._step3_execute_the_command_toget_workstation_HTTP_URL
}


output "step4_workstation_https_access" {
  value = module.app-dev._step4_workstation_https_access
}
