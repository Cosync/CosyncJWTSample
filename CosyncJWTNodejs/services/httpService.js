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


let request = require("request"); 
let config = require("../config");
let Realm = require('realm');

class HttpService {

    
    constructor() {

    }

    render(result, err){
        console.log('<<<<<<<<<<HERE IS RESULT: >>>>>>>>>>>>>> \n');

        if(result) console.log(result);
        else console.log(err);

        console.log('\n<<<<<<<<<<END OF RESULT: >>>>>>>>>>>>>> \n');
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
        request.post(options, function(err, httpResponse, body){ 
            if(body) {
                try { 
                
                    let data = JSON.parse(body);
                    let users = Realm.Sync.User.all;
            
                    for(const key in users) {
                        const user = users[key];
                        if(user) user.logout();
                    }

                    const credentials = Realm.Sync.Credentials.jwt(data.jwt);
                    let url = config.realm;
                    url = url.split('https://').join('');
                    url = url.split('http://').join('');

                    console.log("Connecting to realm => ", url);
                    
                    Realm.Sync.User.login(`https://${url}`, credentials) 
                    .then(user => {
                        console.log("Realm Login! user = ", user.identity);
                    });

                } catch (error) {
                    console.log("Whoop! something wet wrong");
                }
            }

            that.render(body, err);
        })
    };


    signup(handle) { 
        
        const options = {
            url: `${config.apiurl}api/appuser/signup`,
            headers: {
              'app-token': config.appToken
            },
            form:{
                handle:handle 
            }
        };
        let that = this;
        request.post(options, function(err,httpResponse, body){ 
            that.render(body, err);
        })
    };


    completeSignup(handle, md5Password, code) {

        
        let onboardingData = {
            'rule':'testRule'
        };
      
        const options = {
            url: `${config.apiurl}api/appuser/completeSignup`,
            headers: {
              'app-token': config.appToken
            },
            form:{
                handle:handle,
                password: md5Password,
                code : code,
                onboardingData: JSON.stringify(onboardingData)
            }
        };
        let that = this;
        request.post(options, function(err,httpResponse, body){ 
            that.render(body, err);
        })
    };


    invite(accessToken, handle) { 
        let inviteData = {
            'rule':'testRule'
        };
      
        const options = {
            url: `${config.apiurl}api/appuser/invite`,
            headers: {
              'app-token': config.appToken,
              'access-token' : accessToken
            },
            form:{
                handle: handle, 
                inviteData: JSON.stringify(inviteData)
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





