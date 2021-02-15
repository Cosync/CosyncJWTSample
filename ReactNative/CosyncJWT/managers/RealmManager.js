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
import Realm from "realm"; 
import Schema from '../config/Schema';
import Configure from '../config/Config' 
 


export const login = (jwt) => {
  return new Promise((resolve, reject) => { 

    const appConfig = {
      id:  Configure.Realm.appId,
      timeout: 10000,
    };

    closeAllRealm(); 
 
    const app = new Realm.App(appConfig);  
    const credentials = Realm.Credentials.jwt(jwt);
      
    app.logIn(credentials).then(user => { 
      global.user = user; 

      global.privatePartition = `user_id=${global.user.id}`;
       
      resolve(user);

    }).catch(err => {
      console.log('realm logIn error: ', err);
      reject(err);
    }) 
  })
}

const closeAllRealm = () => {
  
  try {
    for (const key in  global.realmPartition) {
      const realm =  global.realmPartition[key]; 
      if(realm) realm.close(); 
    }
  } catch (error) {
        
  } 

  global.realmPartition = {};

}


export const openRealm = () => {

  return new Promise((resolve, reject) => {

    if(global.realm && global.realmPrivate){
      resolve(global)
      return;
    }

    let configPublic = {
      schema:  [Schema.CosyncAsset],
      sync: {
        user: global.user,
        partitionValue: Configure.Realm.publicPartition
      }
    }; 

    let configPrivate = {
      schema:  [Schema.CosyncAsset, Schema.CosyncAssetUpload],
      sync: {
        user: global.user,
        partitionValue: global.privatePartition,
      }
    };  
      
    try {

      Realm.open(configPublic).then(realm => {
        global.realm = realm; 

        Realm.open(configPrivate).then(priRealm => {
          global.realmPrivate = priRealm;
          resolve({realm: realm, realmPrivate: priRealm}); 
  
        })

      }).catch(err => {
        reject(err);
      })
      
    } catch (error) { 
      reject(error);
    }
    
  })
}



export const openRealmPartition = (partitionValue, reopen) => {

  return new Promise((resolve, reject) => {
    
    if(global.realmPartition[partitionValue]){
      if(!reopen){
        resolve(global.realmPartition[partitionValue]);
        return;
      }  
      
    } 

    let configPartition = {
      schema:  [Schema.CosyncAsset, Schema.CosyncAssetUpload],
      sync: {
        user: global.user,
        partitionValue: partitionValue
      }
    };  
      
    try {

      if(global.realmPartition[partitionValue]) global.realmPartition[partitionValue].close();
       
      Realm.open(configPartition).then(realm => { 
        global.realmPartition[partitionValue] = realm;
        resolve(realm); 
      }).catch(err => {
        console.error(err)
        reject(err); 
      })
      
    } catch (error) { 
      console.error(err)
      reject(error);
    }
    
  })
}

 


