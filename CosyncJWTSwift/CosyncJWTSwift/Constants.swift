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
    static let APP_TOKEN = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBJZCI6IjZlMmMwMThiNTQ4MDQwYWRhMDM1ZDllZWI4Y2ViMWJjIiwic2NvcGUiOiJhcHAiLCJpYXQiOjE1ODE1MjMyMzN9.SDQHfMpNxtib1qrtG4jLHQ1Fh6vFCJaWjAM1VIoeJ4gpbb3WjUDKOtDJH6W6vmgA_6oKq1gt4hDuvMkFxUa0MjnCdfKCQ7KvCdYylY50XqTiSNe1jV3SqK00dASfieVcZS2n0JCQYCgPqvlk9dklvrjml24teDssE5LXBMQv_KWjnwjvNURnet4VrpoT86vRtRUfFUj0LZImQLvyD3Ey3UM4q8uBld9MO2-Q9HoD-L4aTYxLx4i_TGbMysQqEpIHmtfpyOXM9s3TzhvkqQ3EYjjHkcwOWRONl-gZPid7tnY5n5RzA_2ZggJiFlQkxxLehWCo_w_JAUmfcynYi2le2g" // <- update this

    static let SUPERUSER_ACCESS_TOKEN = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOiJmMjQzODcwY2M4YmQ0ZmM3YTVmOWQ4ZmE3ZmZiNTNkMiIsImFwcElkIjoiNmUyYzAxOGI1NDgwNDBhZGEwMzVkOWVlYjhjZWIxYmMiLCJzY29wZSI6ImRldmVsb3BlciIsImlhdCI6MTU4MTUzMDA0Nn0.cRuJS8UwlRhP63vap_aoLxmc1so33J5Z9-cUhsbAaHPQvUu-JMRv-SuVUSBoNKiwJ0N2NHew9905s_5uGjUhPyUwozcju_BgrAAsacAYC0Xc6bNeaKyWYt9_F4SufnXLMJlB2wND-VZZ1ziiTfb6uOHWaqzzeupVr9uf9ZNGiv3QSGLINiK53EhmkuHUN5wV-ODG1BhddkZAJfXy-biKm-NsrpzyYOroV2pBOfDa3tkKUBqxBah1giVNDx3BAgfrUA1Quglmu06qaSZlqK_3CwmncSZCsCmR8ce-mdCKEW_7Z76DrCuP3uzr7DJY1Z2sPH16eRz2yjrz9AEJHmUMGw" // <- update this
    
    static let COSYNC_REST_ADDRESS = "https://rest.cosync.net"
    static let AUTH_URL  = URL(string: "https://\(MY_INSTANCE_ADDRESS)")!
    static let REALM_URL = URL(string: "realms://\(MY_INSTANCE_ADDRESS)/")!

}
