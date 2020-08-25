////////////////////////////////////////////////////////////////////////////
//
// Copyright 2020 Cosync, Inc. All Rights Reserved.
// For questions about this license, you may write to mailto:info@cosync.io
//
//This program is free software: you can redistribute it and/or modify
//it under the terms of the GNU General Public License as published by
//the Cosync, Inc., either version 3 of the License, or
//(at your option) any later version.
//
//This program is distributed in the hope that it will be useful,
//but WITHOUT ANY WARRANTY; without even the implied warranty of
//MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//GNU General Public License for more details.
//
//You should have received a copy of the GNU General Public License
//along with this program.  If not, see <http://www.gnu.org/licenses/>.
//
////////////////////////////////////////////////////////////////////////////

/**
 * © 2020, Cosync, Inc. All Rights Reserved.
 * 
 * @author Tola VOEUNG
 * 
 * @Editor Tola VOEUNG  
 * For questions about this license, you may write to mailto:info@cosync.io
*/

const _ = require('lodash');
let request = require("request"); 
let config = require("../config");
let Realm = require('realm');
let Configstore = require("configstore");
let configstore = new Configstore(config.name);

class HttpService {

    
    constructor() {

    }

    render(result, err){
        console.log('<<<<<<<<<<HERE IS RESULT: >>>>>>>>>>>>>> \n');

        if(result) console.log(result);
        else console.log(err);

        console.log('\n<<<<<<<<<<END OF RESULT: >>>>>>>>>>>>>> \n');

        process.exit(0);
    }
  
    login(handle, md5Password) { 
        const options = {
            url: `${config.apiurl}api/appuser/login`,
            headers: {
              'app-token': config.appToken
            },
            form:{
                handle:handle,
                password: md5Password
            }
        };
        let that = this;
        console.log("cosync jwt Login....");
        request.post(options, function(err, httpResponse, body){ 
            if(body) {
                try { 
                    body = JSON.parse(body);

                    if(body.jwt) that.realmLogin(body);
                    else{
                        configstore.set('loginToken', body['login-token']), 
                        that.render(body, err); 
                    }

                    

                } catch (error) {
                    console.log("Whoop! something wet wrong: ", error);
                }
            }

           
        })
    };


    loginComplete(code) { 
      
        const options = {
            url: `${config.apiurl}api/appuser/loginComplete`,
            headers: {
              'app-token': config.appToken
            },
            form:{
                token: configstore.get('loginToken'), 
                code : code 
            }
        };
        let that = this;
        request.post(options, function(err,httpResponse, body){ 
            body = JSON.parse(body); 
            if(body.jwt) that.realmLogin(body);
        })
    };



    realmLogin(data){
        let jwtToken = data.jwt.split('"').join('');
        jwtToken = jwtToken.trim();

        if(data['access-token']){
            let accessToken = data['access-token'].split('"').join('');
            accessToken = accessToken.trim();
            configstore.set('accessToken', accessToken);
        } 

        const appConfig = {
            id: config.appId,
            timeout: 10000,
        };
    
        let realmApp = new Realm.App(appConfig);  

        const credentials = Realm.Credentials.custom(jwtToken);  
        console.log("Realm Login....");
        realmApp.logIn(credentials).then(user => { 
            
            let userId = user.identity || user.id;

            configstore.set("jwtToken", jwtToken); 
            configstore.set("uid", userId);  

            data.realmUserId = userId;

            this.render(data); 
        });
    }


    async signup(handle, password) { 
        
        let meteData = {};
        let appData = await this.getAppData();
        
        if(appData.metaData.length){
            _.forEach(appData.metaData, function(field) {
                let value = field.fieldName == 'email' ? handle : "test value";
                if(field.required) _.set(meteData, field.path, value)
            });
        } 
        
        const options = {
            url: `${config.apiurl}api/appuser/signup`,
            headers: {
              'app-token': config.appToken
            },
            form:{
                handle: handle,
                password: password,
                meteData: JSON.stringify(meteData)
            }
        };
        let that = this;
        request.post(options, function(err,httpResponse, body){ 
            that.render(body, err);
        })
    };


    completeSignup(handle, code) { 
      
        const options = {
            url: `${config.apiurl}api/appuser/completeSignup`,
            headers: {
              'app-token': config.appToken
            },
            form:{
                handle:handle, 
                code : code 
            }
        };
        let that = this;
        request.post(options, function(err,httpResponse, body){ 
            that.render(body, err);
        })
    };


    async invite(handle) { 

        let meteData = {};

        let appData = await this.getAppData();
 

        if(appData.metaData.length){
            _.forEach(appData.metaData, function(field) {
                let value = field.fieldName == 'email' ? handle : "test value";
                if(field.required) _.set(meteData, field.path, value)
            });
        }
      
        const options = {
            url: `${config.apiurl}api/appuser/invite`,
            headers: {
              'app-token': config.appToken,
              'access-token' : configstore.get('accessToken')
            },
            form:{
                handle: handle,  
                senderUserId: configstore.get('uid'),
                meteData: JSON.stringify(meteData)
            }
        };
        let that = this;
        request.post(options, function(err,httpResponse, body){ 
            that.render(body, err);
        })
    };



    register(handle, password, code) { 

        const options = {
            url: `${config.apiurl}api/appuser/register`,
            headers: {
              'app-token': config.appToken 
            },
            form:{
                handle: handle, 
                password: password,
                code: code
            }
        };
        let that = this;
        request.post(options, function(err,httpResponse, body){ 
            that.render(body, err);
        })
    };



    getUser(accessToken) { 

        const options = {
            url: `${config.apiurl}api/appuser/getUser`,
            headers: {
              'app-token': config.appToken,
              'access-token' : accessToken
            } 
        };
        let that = this;
        request.get(options, function(err,httpResponse, body){ 
            that.render(body, err);
        })
    };

    getAppData(){
         
        return new Promise((resovle, reject) => {

            const options = {
                url: `${config.apiurl}api/appuser/getApplication`,
                headers: {
                  'app-token': config.appToken 
                } 
            }; 

            request.get(options, function(err, httpResponse, body){  
                resovle(JSON.parse(body));
            })

        });
    }


    getApplication() {
      
        const options = {
            url: `${config.apiurl}api/appuser/getApplication`,
            headers: {
              'app-token': config.appToken 
            } 
        };
        let that = this;
        request.get(options, function(err,httpResponse, body){ 
            that.render(body, err);
        })
    };


    forgotPassword(handle) {  
      
        const options = {
            url: `${config.apiurl}api/appuser/forgotPassword`,
            headers: {
              'app-token': config.appToken 
            },
            form:{
                handle: handle 
            }
        };

        let that = this;
        request.post(options, function(err,httpResponse, body){ 
            that.render(body, err);
        })
    };


    resetPassword(handle, password, code) {  
      
        const options = {
            url: `${config.apiurl}api/appuser/resetPassword`,
            headers: {
              'app-token': config.appToken 
            },
            form:{
                handle: handle, 
                password: password,
                code: code
            }
        };

        let that = this;
        request.post(options, function(err,httpResponse, body){ 
            that.render(body, err);
        })
    };
  

    changePassword(accessToken, password, code) {  
      
        const options = {
            url: `${config.apiurl}api/appuser/changePassword`,
            headers: {
              'app-token': config.appToken,
              'access-token': accessToken
            },
            form:{ 
                password: password,
                code: code
            }
        };
        let that = this;
        request.post(options, function(err,httpResponse, body){ 
            that.render(body, err);
        })
    };
}

const instance = new HttpService()
module.exports = instance





