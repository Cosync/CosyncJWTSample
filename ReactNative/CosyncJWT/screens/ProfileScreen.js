 
//
//  ProfileScreen.js
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

import React, { useEffect, useState, useRef } from 'react'; 
import {
  StyleSheet, 
  View,
  Text,
  TextInput,
  TouchableOpacity
 
} from 'react-native';
import AsyncStorage from '@react-native-community/async-storage';
import Loader from '../components/Loader'; 
import Configure from '../config/Config';  
import * as CosyncJWT from '../managers/CosyncJWTManager'; 

const ProfileScreen = props => { 
  let [loading, setLoading] = useState(false);
  let [userEmail, setUserEmail] = useState('');
  let [errortext, setErrortext] = useState('');
  let [infotext, setInfotext] = useState('');

  global.appId = Configure.Realm.appId; 
  AsyncStorage.setItem('appId', global.appId);  

 
  useEffect(() => {
    CosyncJWT.getCosyncApplicationData().then(result => { 
      global.appData = result;
    });
  }, []);



  const handleInvite = () => { 

    setLoading(true);   
    setErrortext('');
    setInfotext('');

    if(!global.appData.invitationEnabled){
      setErrortext(`This app doesn't allow invitation.`); 
      return;
    }

    if(global.appData.metaDataInvite.length){
      setErrortext(`metaDataInvite`); 
    }

    CosyncJWT.postData('/api/appuser/invite', {handle:userEmail, senderUserId:global.userData.realmUserId}).then(result => {

      setLoading(false);   

      if(result == true){
        setInfotext('Success')
      } 
      else{ 
        setErrortext(`Error: ${result.message}`);
      }
    }).catch(err => {
      setLoading(false); 
      console.log(err);
      setErrortext(`Error: ${err.message}`);
    })
    
  };



  return (
    <View style={styles.mainBody}>
      <Loader loading={loading} /> 
      <Text> Invite Someone </Text>
      <View style={styles.SectionStyle}>
     
            <TextInput
              style={styles.inputStyle}
              onChangeText={value => setUserEmail(value)} 
              placeholder="Enter Email to invite"
              autoCapitalize="none" 
              autoCorrect={false}
              keyboardType="email-address" 
              returnKeyType="next" 
              onSubmitEditing={() => handleInvite}
              blurOnSubmit={false}
              
            />
      </View>

      {infotext != '' ? (
              <Text style={styles.registerTextStyle}> {infotext} </Text>
      ) : null} 


      {errortext != '' ? (
            <Text style={styles.errorTextStyle}> {errortext} </Text>
      ) : null}

      <TouchableOpacity
            style={styles.buttonStyle}
            activeOpacity={0.5}
            onPress={handleInvite}>
            <Text style={styles.buttonTextStyle}>Invite</Text>
      </TouchableOpacity>


    </View>
  );
};
export default ProfileScreen;

const styles = StyleSheet.create({
  mainBody: {
    flex: 1,
    justifyContent: 'center',
    backgroundColor: '#fff',
  },
  SectionStyle: {
    flexDirection: 'row',
    height: 40,
    marginTop: 20,
    marginLeft: 35,
    marginRight: 35,
    margin: 10,
  },
  buttonStyle: {
    backgroundColor: '#4638ab',
    borderWidth: 0,
    color: '#FFFFFF',
    borderColor: '#7DE24E',
    height: 40,
    alignItems: 'center',
    borderRadius: 30,
    marginLeft: 35,
    marginRight: 35,
    marginTop: 20,
    marginBottom: 20,
  },
  buttonTextStyle: {
    color: 'white',
    paddingVertical: 10,
    fontSize: 16,
  },
  inputStyle: {
    flex: 1,
    color: '#4638ab',
    paddingLeft: 15,
    paddingRight: 15,
    borderWidth: 1,
    borderRadius: 30,
    borderColor: '#4638ab',
  },
  registerTextStyle: {
    color: '#4638ab',
    textAlign: 'center',
    fontWeight: 'bold',
    fontSize: 14,
  },
  errorTextStyle: {
    color: 'red',
    textAlign: 'center',
    fontSize: 14,
  },
});