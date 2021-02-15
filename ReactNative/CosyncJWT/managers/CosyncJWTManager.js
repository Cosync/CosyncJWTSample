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
import Request from '../components/Request'; 
import md5 from 'md5';



export const register = (firstName, lastName, handle, userPassword, code) => {
    return new Promise((resolve, reject) => { 

        let metaData = {
            name: {
                first: firstName,
                last: lastName
            },
            email: handle
        };


        let dataToSend = {
            handle: handle,
            code: code,
            password: md5(userPassword),
            metaData : JSON.stringify(metaData)
        }; 
        
        Request(`${Configure.CosyncApp.apiURL}/api/appuser/register`, dataToSend, {
            method: 'POST',
            headers: {
                'Content-Type' : 'application/x-www-form-urlencoded;charset=UTF-8',
                'app-token': Configure.CosyncApp.appToken
            },
             
        }, (progressEvent) => { 
            
           
        }).then((res) => { 
            
            try {
                
                let respone = JSON.parse(res._response); 
                if(res.status == 200 ) resolve(respone)
                else reject(respone)

            } catch (error) {
                reject(res._response)
            }
            

        }, (err) => reject(err) )
        
    })
}

export const signup = (firstName, lastName, handle, userPassword) => {
    return new Promise((resolve, reject) => { 

        let metaData = {
            name: {
                first: firstName,
                last: lastName
            },
            email: handle
        };


        let dataToSend = {
            handle: handle,
            password: md5(userPassword),
            metaData : JSON.stringify(metaData)
        }; 
        
        Request(`${Configure.CosyncApp.apiURL}/api/appuser/signup`, dataToSend, {
            method: 'POST',
            headers: {
                'Content-Type' : 'application/x-www-form-urlencoded;charset=UTF-8',
                'app-token': Configure.CosyncApp.appToken
            },
             
        }, (progressEvent) => { 
            
           
        }).then((res) => { 
            
            try {
                
                let respone = JSON.parse(res._response); 
                if(res.status == 200 ) resolve(respone)
                else reject(respone)

            } catch (error) {
                reject(res._response)
            }
            

        }, (err) => reject(err) )
        
    })
}
  
  export const completeSignup = (handle , code) => {
    return new Promise((resolve, reject) => { 
        let dataToSend = {
            handle: handle,
            code: code 
        }; 
        
        Request(`${Configure.CosyncApp.apiURL}/api/appuser/completeSignup`, dataToSend, {
            method: 'POST',
            headers: {
                'Content-Type' : 'application/x-www-form-urlencoded;charset=UTF-8',
                'app-token': Configure.CosyncApp.appToken
            },
             
        }, (progressEvent) => { 
            
           
        }).then((res) => { 
            try {

                let respone = JSON.parse(res._response); 
                if(res.status == 200 ) resolve(respone)
                else reject(respone)

            } catch (error) {
                reject(res._response)
            }
            

        }, (err) => reject(err) )
    })
  }
  
    export const login = (handle, userPassword) => {
        return new Promise((resolve, reject) => { 
    
            let dataToSend = {
                handle: handle,
                password: md5(userPassword)
            }; 
            
            Request(`${Configure.CosyncApp.apiURL}/api/appuser/login`, dataToSend, {
                method: 'POST',
                headers: {
                    'Content-Type' : 'application/x-www-form-urlencoded;charset=UTF-8',
                    'app-token': Configure.CosyncApp.appToken
                },
                
            }, (progressEvent) => { 
                
            
            }).then((res) => { 
                try {
                    
                    let respone = JSON.parse(res._response); 
                    if(res.status == 200 ) resolve(respone)
                    else reject(respone)

                } catch (error) {
                    reject(res._response)
                }
                

            }, (err) => reject(err) )
        
        })
    }


    export const forgotPassword = (handle) => {
        return new Promise((resolve, reject) => { 
    
            let dataToSend = {
                handle: handle 
            }; 
            
            Request(`${Configure.CosyncApp.apiURL}/api/appuser/forgotPassword`, dataToSend, {
                method: 'POST',
                headers: {
                    'Content-Type' : 'application/x-www-form-urlencoded;charset=UTF-8',
                    'app-token': Configure.CosyncApp.appToken
                },
                
            }, (progressEvent) => { 
                
            
            }).then((res) => { 
                try {
                    
                    let respone = JSON.parse(res._response); 
                    if(res.status == 200 ) resolve(respone)
                    else reject(respone)

                } catch (error) {
                    reject(res._response)
                }
                

            }, (err) => reject(err) )
        
        })
    }

    export const fetchData = (endpoint, method, data) => {
        return new Promise((resolve, reject) => {  
            let option = {
                method: method || 'GET',
                headers: {
                    'Accept': 'application/json',
                    'Content-Type': 'application/json',
                    'app-token': Configure.CosyncApp.appToken
                },
            };

            if(data) option.body = JSON.stringify(data);

            fetch(`${Configure.CosyncApp.apiURL}${endpoint}`, option)
            .then((response) => response.json())
            .then((json) => resolve(json))
            .catch((error) => reject(error)); 
        })
    }

    export const getCosyncApplicationData = () => {
        return new Promise((resolve, reject) => {  

            let dataToSend = {
                handle: 'handle' 
            }; 

            Request(`${Configure.CosyncApp.apiURL}/api/appuser/getApplication`,dataToSend, {
                method: 'POST',
                headers: {
                    'Content-Type' : 'application/x-www-form-urlencoded;charset=UTF-8',
                    'app-token': Configure.CosyncApp.appToken
                },
                
            }, (progressEvent) => { 
                
            
            }).then((res) => { 
                try {

                    let respone = JSON.parse(res._response); 
                    if(res.status == 200 ) resolve(respone)
                    else reject(respone)

                } catch (error) {
                    console.log(error);
                    reject(res._response)
                }
                

            }, (err) => {
                console.log(err);
                reject(err)
            })
        })
    }
    