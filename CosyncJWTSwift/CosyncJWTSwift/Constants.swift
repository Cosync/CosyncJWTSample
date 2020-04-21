//
//  Constants.swift
//  COSYNC SWIFT SDK
//
//  Licensed to the Apache Software Foundation (ASF) under one
//  or more contributor license agreements.  See the NOTICE file
//  distributed with this work for additional information
//  regarding copyright ownership.  The ASF licenses this file
//  to you under the Apache License, Version 2.0 (the
//  "License"); you may not use this file except in compliance
//  with the License.  You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing,
//  software distributed under the License is distributed on an
//  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
//  KIND, either express or implied.  See the License for the
//  specific language governing permissions and limitations
//  under the License.
//
//  Created by Cosync, Inc on 1/24/20.
//
    

import Foundation

struct Constants {
    
    static let MY_INSTANCE_ADDRESS = "testapplication1.us2a.cloud.realm.io" // <- update this
    static let APP_TOKEN = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBJZCI6ImY0NzE1NTMxMzljMTRjNmViYjA3YjM0YzI2MDM3MjBjIiwic2NvcGUiOiJhcHAiLCJpYXQiOjE1ODc0MTg1MDJ9.T9RrU6F_NcuaxMGU0JPtraUPoIHoVBcQdTiFe7yH9uRKFJKVeJ6mea6Ou1S5yNShj_TdyvkZjIa1bjup-FnPwqkaADWHD8YBP3diQwvqqF5ZSNv5R088ykHNqcdxkZ42cZv1Q7En8g2WUUczt0rt0kMUkg9UPUkjfOtE9UUGEGrKbBuULk4Bg4cwX9QI_uGbZSQo1rDoKgZ_B01PEFdn4GK1fdLpbBcP2Q-q83RSDYlv3yE9eGKThZRRNp6-RFyl9KCxZvT2FEhAR432zoQ9XPgloG70VmQVKz6Qm8xPMsNw3-F4lmT8BxC2nIyOh8BT608O_ToiXmGsO3m67Xf40w" // <- update this

    static let SUPERUSER_ACCESS_TOKEN = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOiI0ZTY5MmNmNjMzMjE0NjYzOTIwMmVkYmM3NGZhOTAzMSIsImFwcElkIjoiZjQ3MTU1MzEzOWMxNGM2ZWJiMDdiMzRjMjYwMzcyMGMiLCJzY29wZSI6ImRldmVsb3BlciIsImlhdCI6MTU4NzQxODYyM30.2KEGkASUwmATQ57M5oVfAKD8AV4hrB6453Bn4jHZ5K4OUOkdeE3s3Pu1Fo964Iaj2_RQzjNdh1zpHQD2V_BOakfiIAIifYObscGX5IpIDzzhlM67t1wCPXY8xlPLT_d608CudZNEHPdNs6W713ne57h0PgqBRSvAHBDFAcoLEyD60SUYK1vMGgASPnG4_x43Ru1hO93uZPNppxJQpo1SffQwPQmB4Va2EHu1Ublau_OY7vsbT-AecfWMyIvx1VdPZ6Hva6v-Nn4SGTpj0BM0zUqjYxEqhb6d3hTvLxhCLN4-qUhE7BC3-mD3eFWrQG9nhxigcmY7mgLdQqJj_lrXsw" // <- update this
    
    static let COSYNC_REST_ADDRESS = "https://rest.cosync.net"
    static let AUTH_URL  = URL(string: "https://\(MY_INSTANCE_ADDRESS)")!
    static let REALM_URL = URL(string: "realms://\(MY_INSTANCE_ADDRESS)/")!

}
