 
//
//  ForgotPasswordScreen.js
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
//     http://www.fapache.org/licenses/LICENSE-2.0
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

import React, {useEffect, useState, useRef } from 'react'; 
import {
  StyleSheet,
  TextInput,
  View,
  Text,
  ScrollView,
  Image,
  Keyboard,
  TouchableOpacity,
  KeyboardAvoidingView,
} from 'react-native';
import AsyncStorage from '@react-native-community/async-storage';
import Loader from '../components/Loader'; 
import Configure, { CosyncApp } from '../config/Config'; 
import md5 from 'md5';
import * as CosyncJWT from '../managers/CosyncJWTManager'; 

const ForgotPasswordScreen = props => {
  
  let [userEmail, setUserEmail] = useState('');
  let [verifyCode, setVerifyCode] = useState(false); 
  let [loading, setLoading] = useState(false);
  let [errortext, setErrortext] = useState(''); 
  let [infotext, setInfotext] = useState('');
  let [resetCode, setResetCode] = useState('');
  let [userPassword, setUserPassword] = useState('');
  
  const ref_input_pwd = useRef();
  const ref_input_code = useRef();

  global.appId = Configure.Realm.appId; 
  AsyncStorage.setItem('appId', global.appId);  
   

  const validateEmail = (text) => {
   
    let reg = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
    if (reg.test(text) === false) return false;
    else return true;
  }

  
  const handleResetPassword = () => {
    setErrortext('');
    if (!userEmail) {
      alert('Please fill Email');
      return;
    }
    if (!validateEmail(userEmail)) {
      alert('Please fill a valid email');
      return;
    }

    

    setLoading(true);  
    if(verifyCode){
      handleSubmitVerifyCodePress()
    }
    else {

      
      CosyncJWT.forgotPassword(userEmail).then(result => {
        setLoading(false);
        console.log('CosyncJWT forgotPassword result  ', result);
        
        if(result) {
          setInfotext(`Please check your email for reset password ${global.appData.signupFlow}.`);

          if(global.appData.signupFlow == 'code') setVerifyCode(true);
        }
      }).catch(err => {
        setLoading(false);
        console.log('CosyncJWT forgotPassword err  ', err);
        setErrortext(err.message);
      }) 
    }
  };



  const handleSubmitVerifyCodePress = () => {

    if (!userEmail) {
      alert('Please fill Email');
      return;
    }
    if (!validateEmail(userEmail)) {
      alert('Please fill a valid email');
      return;
    }


    if (!userPassword) {
      alert('Please fill Password');
      return;
    }

    if (userPassword.length < 5) {
      alert('Password must be at least 5 charactor.');
      return false;
    } 
    
    if (!resetCode) {
      alert('Please fill code');
      return;
    }

    setLoading(true);   

    CosyncJWT.fetchData('/api/appuser/resetPassword', 'POST', {handle:userEmail, password:md5(userPassword), code:resetCode}).then(result => {
      setLoading(false); 
      console.log('resetPassword ', result);

      if(result === true){  
        alert('Please login with your new password');
        props.navigation.navigate('LoginScreen');
      }
      else{
        
        setErrortext(`Error: ${result.message}`);
      }
    }).catch(err => { 

      setLoading(false); 
      setErrortext(`Error: ${err.message}`);
    })
  }



  return (
    <View style={styles.mainBody}>
      <Loader loading={loading} />
      
      <ScrollView keyboardShouldPersistTaps="handled">

        <View style={{ marginTop: 100 }}>
          <KeyboardAvoidingView enabled>
            <View style={{ alignItems: 'center' }}>
              <Image
                source={require('../assets/cosynclogo.png')}
                style={{ 
                  height: 200,
                  resizeMode: 'contain',
                  margin: 30,
                }}
              />
            </View>
            <View style={styles.SectionStyle}>
              <TextInput
                style={styles.inputStyle}
                onChangeText={UserEmail => setUserEmail(UserEmail)} 
                placeholder="Enter Email" 
                autoCapitalize="none"
                keyboardType="email-address" 
                returnKeyType="next" 
                autoComplete= {'off'}
                onSubmitEditing={() => ref_input_pwd.current.focus()}
                blurOnSubmit={false}
                
              />
            </View>


            {infotext != '' ? (
              <Text style={styles.registerTextStyle}> {infotext} </Text>
            ) : null}
 
          
            {verifyCode ?<View> 

              <View style={styles.SectionStyle}>
                <TextInput
                  style={styles.inputStyle}
                  onChangeText={value => setUserPassword(value)} 
                  placeholder="Enter new password"
                  blurOnSubmit={false}
                  secureTextEntry={true} 
                  textContentType={'none'}
                  autoComplete= {'off'}
                  ref={ref_input_pwd}
                  onSubmitEditing={() => ref_input_code.current.focus()}
                /> 
              </View> 

              <View style={styles.SectionStyle}>
                <TextInput
                  style={styles.inputStyle}
                  onChangeText={value => setResetCode(value)} 
                  placeholder="Enter reset code"
                  keyboardType="numeric" 
                  returnKeyType="go" 
                  blurOnSubmit={false} 
                  textContentType={'none'}
                  autoComplete= {'off'}
                  ref={ref_input_code}
                  onSubmitEditing={() => Keyboard.dismiss, handleSubmitVerifyCodePress}
                /> 

              </View> 
            </View>: null}

            {errortext != '' ? (
              <Text style={styles.errorTextStyle}> {errortext} </Text>
            ) : null}


            <TouchableOpacity
                style={styles.buttonStyle}
                activeOpacity={0.5}
                onPress={handleResetPassword}>
                <Text style={styles.buttonTextStyle}>SUBMIT</Text>
              </TouchableOpacity>


            <Text
              style={styles.registerTextStyle}
              onPress={() => props.navigation.navigate('RegisterScreen')}>
              Create New Account
            </Text>
            { <Text
              style={styles.registerTextStyle}
              onPress={() => props.navigation.navigate('LoginScreen')}>
              Login
            </Text>}


          </KeyboardAvoidingView>
        </View>
      </ScrollView>
    </View>
  );
};
export default ForgotPasswordScreen;

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