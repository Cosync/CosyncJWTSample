//
//  Request.js
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


const Request = (url, dataToSend, opts={}, onProgress) => {

    return new Promise( (res, rej)=>{ 

        if(dataToSend){
            var formBody = [];
            for (var key in dataToSend) {
                var encodedKey = encodeURIComponent(key);
                var encodedValue = encodeURIComponent(dataToSend[key]);
                formBody.push(encodedKey + '=' + encodedValue);
            } 
            
            opts.body = formBody.join('&'); 
        }
        

        var xhr = new XMLHttpRequest();
        
        xhr.open(opts.method || 'get', url);

        for (var k in opts.headers||{}){
            xhr.setRequestHeader(k, opts.headers[k]);
        }
        xhr.responseType = 'json';
        xhr.onload = e => res(e.target);
        xhr.onerror = rej;

        if (xhr.upload && onProgress)  xhr.upload.onprogress = onProgress; // event.loaded / event.total * 100 ; //event.lengthComputable

        xhr.send(opts.body);
    });
}

export default Request