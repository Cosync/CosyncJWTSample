//
//  RealmManager.js
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
import Configure from '../config/Config'  
import AsyncStorage from '@react-native-community/async-storage';

 

    
export const fetchData = (endpoint) => {
    return new Promise((resolve, reject) => {  
        let option = {
            method: 'GET',
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json' 
            }
        }; 

        if(global.userData && global.userData['access-token']) option.headers['access-token'] = global.userData['access-token'];
        else option.headers['app-token'] = Configure.CosyncApp.appToken;

        fetch(`${Configure.CosyncApp.apiURL}${endpoint}`, option)
        .then((response) => response.json())
        .then((json) => resolve(json))
        .catch((error) => reject(error)); 
    
        
    })
}


export const postData = (endpoint, data) => {
    return new Promise((resolve, reject) => {  
        let option = {
            method: 'POST',
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json' 
            }
        };

        if(data) option.body = JSON.stringify(data);  

        if(global.userData && global.userData['access-token']) option.headers['access-token'] = global.userData['access-token'];
        else option.headers['app-token'] = Configure.CosyncApp.appToken;

        fetch(`${Configure.CosyncApp.apiURL}${endpoint}`, option)
        .then((response) => response.json())
        .then((json) => resolve(json))
        .catch((error) => reject(error)); 
    
        
    })
}

export const getCosyncApplicationData = () => {
    return new Promise((resolve, reject) => {  

        let option = {
            method: 'GET',
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json',
                'app-token': Configure.CosyncApp.appToken
            },
        };  

        fetch(`${Configure.CosyncApp.apiURL}/api/appuser/getApplication`, option)
        .then((response) => response.json())
        .then((json) => resolve(json))
        .catch((error) => reject(error));  

    })
}
