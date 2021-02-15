 //
//  Schema.js
//  CosyncJWT
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
//  Created by Tola Voeung.
//  Copyright © 2020 cosync. All rights reserved.
//
 

exports.CosyncAsset = {
    "name":"CosyncAsset",
    "primaryKey":"_id",
    "properties": {

        "_id":{ "type": "objectId", "indexed": true }, 
        "_partition": { "type": "string", "indexed": true },
        "uid":{ "type": "string", "indexed": true }, 
        "path":{ "type": "string", "default": ""},
        "expirationHours": { "type": "double", "default": 24},
        "expiration":{ "type": "date", "indexed": true, "optional": true },
        "contentType":{ "type": "string", "indexed": true},
        "size":{ "type": "int", "optional": true, "indexed": true }, 
        "caption": { "type": "string", "default": "" },
        "duration":{ "type": "int", "optional": true },
        "color": { "type": "string", "default":"#000000" },
        "xRes": { "type": "int", "default": 0 },
        "yRes": { "type": "int", "default": 0 },
        "containerId": { "type": "string", "indexed": true, "optional": true },
        "status":{ "type": "string", "default": "active", "indexed": true },
        "url":{ "type": "string", "optional": true },
        "urlSmall": { "type": "string", "optional": true },
        "urlMedium": { "type": "string", "optional": true },
        "urlLarge": { "type": "string", "optional": true },
        "urlVideoPreview": { "type": "string", "optional": true },
        "createdAt": { "type": "date" , "optional": true, "indexed": true },
        "updatedAt": { "type": "date" , "optional": true }  
    }
}; 

 

exports.CosyncAssetUpload = {
    "name":"CosyncAssetUpload", 
    "primaryKey":"_id",
    "properties": {
        "_id":{ "type": "objectId", "indexed": true }, 
        "_partition":{ "type": "string", "indexed": true }, 
        "uid":{ "type": "string", "indexed": true },  
        "sessionId":{ "type": "string", "indexed": true},   
        "extra":{ "type": "string", "default": ""},   
        "assetPartition":{ "type": "string", "default": "", "indexed": true },
        "filePath": { "type": "string", "default": "" },
        "path":{ "type": "string", "default": ""},
        "expirationHours": { "type": "double", "default": 24},
        "contentType":{ "type": "string", "optional": true}, 
        "size":{ "type": "int", "optional": true, "indexed": true },
        "duration":{ "type": "int", "optional": true },
        "color": { "type": "string", "default":"#000000" },
        "xRes": { "type": "int", "default": 0 },
        "yRes": { "type": "int", "default": 0 },
        "containerId": { "type": "string", "indexed": true, "optional": true },
        "caption": { "type": "string", "default": "" }, 
        "writeUrl":{ "type": "string", "optional": true},    
        "writeUrlSmall":{ "type": "string", "optional": true},   
        "writeUrlMedium":{ "type": "string", "optional": true},  
        "writeUrlLarge":{ "type": "string", "optional": true},   
        "writeUrlVideoPreview":{ "type": "string", "optional": true},
        "status":{ "type": "string", "default": "pending", "indexed": true }, 
        "createdAt": { "type": "date" , "optional": true, "indexed": true },
        "updatedAt": { "type": "date" , "optional": true } 
    }
}; 