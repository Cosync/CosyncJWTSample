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
    static let APP_TOKEN = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBJZCI6ImU3NDEzOTk1ZTU5NjRmOWFhOTM2YmQxZjVlZDk4OGIwIiwic2NvcGUiOiJhcHAiLCJpYXQiOjE1ODA5MTI3ODJ9.iyRgsVDs3eIyendjLkncMkwk5Mz4508cugjoBUe5Me4r_4J0F2wcHavKwneYPNFGT4VlsG-5VqTONz_QIKl20X9PrZeUWtED28_l8VS_Q-u-xy2lDTx42D-CAjdcas-GDtvOxJasALZ94VRGVTk8MAgbsFiG7sE0Gavd6H-KtUrIqJSS_u2a399YGMF7D9gC0aXzc6EE9Arsk7g3bEVNvsRyrF5AXTmmxQS-4njfC-gaJrLqOz3o2V4iH_LcLbJQW8FXpSD0gQk-DjxlVMOdy11_e66W9XA_TdLxl_jcJvSE8y-0SZC3MQKdKRs0Qi7R3DO_uUz81EoNcGCCQmpGgw" // <- update this

    static let SUPERUSER_ACCESS_TOKEN = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOiIzMzFlM2NlZmNlMjQ0ZDAxOTg4NDAxYzc0NWM5NDRjMSIsImFwcElkIjoiZTc0MTM5OTVlNTk2NGY5YWE5MzZiZDFmNWVkOTg4YjAiLCJzY29wZSI6ImRldmVsb3BlciIsImlhdCI6MTU4MTQzODIzMn0.X0vufSdCgzTRu8uRj3IR209W3b7CCwgJ9Kpl7E626XjZyCupPZp8OLy17-IYFmA8TIIeZEKtz_5vtlLaPYXqH5uNUYxxVeVPyGhBXGvZfbqw2UDB0qdsdXfA0fOT8wLw2P2XBLjp-M0qR6fo9L17j1tvJy42Wmt2oQRxyEc25rThWqE0RLzHNLGKPM6lVskxzllKxNpgETpEhY17EZckMI1UX-C3av5JzXOE-5QxPxqinZDmHNWXnVVtokod-YQ3doulyvK3m9mUFaey0WWGBqO9-BIiR_9DQ65AFuQuh4Uy3uSIsRh05Mg1bNBlKT2o4dWZTABqIPVRL5hoHevUqQ" // <- update this
    
    static let COSYNC_REST_ADDRESS = "https://rest.cosync.net"
    static let AUTH_URL  = URL(string: "https://\(MY_INSTANCE_ADDRESS)")!
    static let REALM_URL = URL(string: "realms://\(MY_INSTANCE_ADDRESS)/")!

}
