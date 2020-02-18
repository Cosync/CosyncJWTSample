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
    // **** Realm Cloud Users:
    // **** Replace MY_INSTANCE_ADDRESS with the hostname of your cloud instance
    // **** e.g., "mycoolapp.us1.cloud.realm.io"
    // ****
    // ****
    // **** ROS On-Premises Users
    // **** Replace the AUTH_URL and REALM_URL strings with the fully qualified versions of
    // **** address of your ROS server, e.g.: "http://127.0.0.1:9080" and "realm://127.0.0.1:9080"
    
    static let MY_INSTANCE_ADDRESS = "cosyncjwt2.us1a.cloud.realm.io" // <- update this
    static let APP_TOKEN = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBJZCI6IjU2MjY1MzJlN2M1MzQ2ZGU4YjM3YjgzZDNkM2U3ZWJmIiwic2NvcGUiOiJhcHAiLCJpYXQiOjE1ODE2OTM5NDF9.C4H4UJWN70EXfYMDM7CF5mpz740GKJIlKnL3h1loyHmNlmX1MQCITk6ESk7Rtba52_TJtxMaOJiAKzwFMYvVc3NQj3MWLTRcYI77qxMEV8R7tghbrA-wc3kbIl7Ww--9YyAwbKiGjWU-E0VwxA7wMhCefJwEmqKozIY864R-txTC_8FWFd4dlY1minFeMUB_W63hI16jWC29-YA7TE24ZwpjNWz90A1uAjUAyQpGJzWW7I0UB9DpU8hZNXt8jKC55lI0p2KQ5c9-6qRdpCeJr-EYykA1c3KKETApGwCnxrDXxx7E5dc3q1BFAYJhqacfKkhmBuoxJlMFn7BYeon7jQ" // <- update this

    static let SUPERUSER_ACCESS_TOKEN = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOiJhOTVlNTI3N2U1MTY0NjY2YTU0MGFiMzE5NGQxNzY3YiIsImFwcElkIjoiNTYyNjUzMmU3YzUzNDZkZThiMzdiODNkM2QzZTdlYmYiLCJzY29wZSI6ImRldmVsb3BlciIsImlhdCI6MTU4MjA0Mzg1Nn0.TW2W6AaKWokVS5tsm9OaqWBn2hCKD2XdQKUYcFt8LXdb34GSneQkqvTBHSWz6eF7UI-WfjjNMywkfaIW8YuOGgbfnr-BPin2UzDAORQuyeXtB5Mi8ozX33dSx9qqNPpkT7LCvGzg3zQEvdPiCIKnkTxkL1kSAuw-OfdYYqQ0YvFa5nqMORXd58Ji1XT89NQMe0X0Kfwt8DXpg_gTceLI3GHULib8j847ixK22haGrx6mevFuq3FoTBZT6KW4VxNzPp6UOYvY39FWzwczlwDY-5uS3IMNqnvrjGgFk1oD4Ks6V6WQw4ZJQeSkFrjjN-SbUaTlp_zxt3M_vIxeEqWF7w" // <- update this
    
    static let COSYNC_REST_ADDRESS = "https://rest.cosync.net"
    static let AUTH_URL  = URL(string: "https://\(MY_INSTANCE_ADDRESS)")!
    static let REALM_URL = URL(string: "realms://\(MY_INSTANCE_ADDRESS)/")!

}
