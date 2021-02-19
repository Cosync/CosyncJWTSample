 
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
  Switch,
  View,
  Text,
  TextInput,
  TouchableOpacity
 
} from 'react-native'; 
 
import Clipboard from '@react-native-clipboard/clipboard';
import Loader from '../components/Loader'; 
import Configure from '../config/Config';  
import * as CosyncJWT from '../managers/CosyncJWTManager'; 

const ProfileScreen = props => { 
  let [loading, setLoading] = useState(false);
  let [userEmail, setUserEmail] = useState('');
  let [userPhone, setUserPhone] = useState(''); 
  let [userPhoneCode, setUserPhoneCode] = useState(''); 
  let [isVerifyPhone, setVerifyPhone] = useState(false);
  let [isGoogleTwoFactor, setGoogleTwoFactor] = useState(false); 
  let [googleSecretKey, setGoogleSecretKey] = useState(''); 

  global.appId = Configure.Realm.appId;   
 
  useEffect(() => {
    CosyncJWT.getCosyncApplicationData().then(result => { 
      global.appData = result;

      console.log("global.userData.data ", global.userData.data);
      let twoFactor = global.userData.data ? global.userData.data.twoFactorGoogleVerification : false;
      setGoogleTwoFactor(twoFactor);
    });
  }, []);


  const validateEmail = (text) => {
  
    let reg = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
    if (reg.test(text) === false) return false;
    else return true;
  }


  const handleInvite = () => { 
 

    if(!global.appData.invitationEnabled){
      setErrortext(`This app doesn't allow invitation.`); 
      return;
    }

    if(!userEmail || !validateEmail(userEmail)){
      alert(`Please enter valid email.`); 
      return;
    }

    
    CosyncJWT.postData('/api/appuser/invite', {handle:userEmail, senderUserId:global.userData.realmUser.id}).then(result => { 

      if(result == true){
        alert('Success');
      } 
      else{ 
        alert(`Error: ${result.message}`);
      }
    }).catch(err => {
       
       
      alert(`Error: ${err.message}`);
    })
    
  };


  const handleAddPhone = () => {  

    if(isVerifyPhone){  
      if(!userPhoneCode){
        alert(`Please enter code number.`); 
        return;
      }


      CosyncJWT.postData('/api/appuser/verifyPhone', {code:userPhoneCode}).then(result => { 

        if(result == true){
          setVerifyPhone(false);

          alert('Success')
        } 
        else{ 
          alert(`Error: ${result.message}`);
        }
      }).catch(err => {
        setLoading(false); 
        
        alert(`Error: ${err.message}`);
      })
      

      return;
    }


    if(!userPhone){
      alert(`Please enter phone number.`); 
      return;
    }
    
 
    
    CosyncJWT.postData('/api/appuser/setPhone', {phone:userPhone}).then(result => { 

      if(result == true){
        alert('Success')
      } 
      else{ 
        alert(`Error: ${result.message}`);
      }
    }).catch(err => {
      setLoading(false); 
      
      alert(`Error: ${err.message}`);
    })
    
  }; 


  const copyGoogleSecret = ()=> Clipboard.setString(googleSecretKey)


  const handleAddGoogleTwoFactor = () => {  
 
    setGoogleTwoFactor(previousState => !previousState);
    //setGoogleTwoFactor(!isGoogleTwoFactor);

    console.log('handleAddGoogleTwoFactor isGoogleTwoFactor ', isGoogleTwoFactor);

    let isTwoFactor = !isGoogleTwoFactor;
    setGoogleSecretKey(''); 

    CosyncJWT.postData('/api/appuser/setTwoFactorGoogleVerification', {twoFactor: isTwoFactor}).then(result => {  
      


      if(result == true || result.googleSecretKey){

        global.userData.data.twoFactorGoogleVerification = isTwoFactor;

        if(isTwoFactor){
          console.log('handleAddGoogleTwoFactor googleSecretKey ', result.googleSecretKey);
          
          if(result.googleSecretKey){
            alert('Please check your email for Google Two Factor');
            setGoogleSecretKey(result.googleSecretKey); 
          } 
          else alert('Turn off Google Two Factor');
         
        } 
      } 
      else{ 
        setGoogleTwoFactor(previousState => !previousState);
        alert(`Error: ${result.message}`);
      }
    }).catch(err => {
      setLoading(false); 
      setGoogleTwoFactor(previousState => !previousState);
      alert(`Error: ${err.message}`);
    })
    
  }; 


  return (
    <View style={styles.mainBody}>
      <Loader loading={loading} />  

      <View style={styles.viewSection}>
        <Text style={styles.registerTextStyle}> Invite Someone </Text>
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

       

        <TouchableOpacity
              style={styles.buttonStyle}
              activeOpacity={0.5}
              onPress={handleInvite}>
              <Text style={styles.buttonTextStyle}>Invite</Text>
        </TouchableOpacity>
      </View>


      <View style={styles.viewSection}>
        <Text style={styles.registerTextStyle}> Add Phone </Text>
        <View style={styles.SectionStyle}>
      
              <TextInput
                style={styles.inputStyle}
                onChangeText={value => setUserPhone(value)} 
                placeholder="Enter your phone number"
                autoCapitalize="none" 
                autoCorrect={false} 
                returnKeyType="next" 
                onSubmitEditing={() => handleAddPhone}
                blurOnSubmit={false}
                
              />
        </View> 

        {isVerifyPhone ?
         <View style={styles.SectionStyle}>
      
          <TextInput
            style={styles.inputStyle}
            onChangeText={value => setUserPhoneCode(value)} 
            placeholder="Enter verify code"
            autoCapitalize="none" 
            autoCorrect={false} 
            returnKeyType="next" 
            onSubmitEditing={() => handleAddPhone}
            blurOnSubmit={false}
            
          />
          </View>  : null}
       
          <TouchableOpacity
              style={styles.buttonStyle}
              activeOpacity={0.5}
              onPress={handleAddPhone}>
              <Text style={styles.buttonTextStyle}>Submit</Text>
          </TouchableOpacity>

      </View>


      <View style={styles.viewSection}>
        <Text style={styles.registerTextStyle}> Add Google Two Factor </Text>  

        <Switch
           
          trackColor={{ false: "#767577", true: "#81b0ff" }}
          thumbColor={isGoogleTwoFactor ? "#4638ab" : "#f4f3f4"}
          ios_backgroundColor="#3e3e3e"
          onValueChange={handleAddGoogleTwoFactor}
          value={isGoogleTwoFactor}
        /> 

        {googleSecretKey != "" ?  <TouchableOpacity onPress={copyGoogleSecret}>
          <Text>Click here to copy Google Secret Key</Text>
        </TouchableOpacity> : null}

      </View>


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
  
  viewSection: {  
    marginTop: 20, 
    marginBottom: 20,
    alignItems: "center",
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
    width: 120,
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