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
    
    static let MY_INSTANCE_ADDRESS = "cosynctest31.us1.cloud.realm.io" // <- update this
    static let APP_TOKEN = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBJZCI6Ijg5ODAxZjNkODBlZjQyZWNhZjMyMGQ2YzhiODJiYzc2Iiwic2NvcGUiOiJhcHAiLCJpYXQiOjE1ODg4NjI3NTJ9.FXgYMPUeb9YxAci_RC84x8JdibYUy357Fj_h3yZuRTok3H3Yy7GS05QHpNkx8hWcCmVq68gNb3fwl8rF6i_pHrYbObK9CEVHMKjTS1YPn6cQyPZeoHUnyXoP3bdMwGQi88hUCxYt01MGKu_mCat0WIEmEIeIBPOJnNXjU6_IUBQHhfE0CXp01o8YjBvZp-oH7vbGeZCnTLvIMN1I-dr2SvMjHjSfYtmXo5K-E0A0QpyY9VVoGaZRnhpLl67ZLDA8PmGAgjXdjipVpFGzsypS268paqZdYmy0AZFRXhfPu3lV2C4seWmeggNcbtC3GWZiiekyUiw_cB6yajJZZtJuVA" // <- update this
    static let SUPERUSER_ACCESS_TOKEN = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOiJhOGMxMzIyY2VmMDA0MDhmYWNiOTFiMTJiN2Y4MTM2MCIsImFwcElkIjoiODk4MDFmM2Q4MGVmNDJlY2FmMzIwZDZjOGI4MmJjNzYiLCJzY29wZSI6InN1cGVydXNlciIsImlhdCI6MTU4ODg3OTE3NH0.fPBkqSj0r7UF7HVGnqqJCDtA1OzUvnYwoZbcmVYWDWnzGXzO5H8zWqp02aqNuN_UZVWAlx2qVPbyZLr4pxErlk-2H8KLYHVM28i2p89I6t6n8-0UMZhnf5HAEYAYpd4LnnySFoI3VrXwUttp2ih-tGKwElk0fhjf8na8xTR648EFLCwHoLbVuAPnuMd4HNShrx5oRogQ07Lt6y2Ocv20le1TKjgU3KSxZ2OlC_0ASUDq7aNqAA2Os_b_yhoINvbTrBlc0iWt1bEciic_hVcHh8WsfA_2iGB2nK1DSw3ribnB7dUXUUHGqfguu2dGt4eJAAneEv3zut8C_mNK5XYwlA" // <- update this
    
    static let COSYNC_REST_ADDRESS = "https://rest-dev.cosync.net"
    static let AUTH_URL  = URL(string: "https://\(MY_INSTANCE_ADDRESS)")!
    static let REALM_URL = URL(string: "realms://\(MY_INSTANCE_ADDRESS)/")!

}
