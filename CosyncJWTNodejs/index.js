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



let md5 = require('md5');
let httpService = require("./services/httpService");
let service = process.argv[2];
let handle, passowrd, code, accessToken;

switch (service) {
    
    case 'login':
        handle = process.argv[3];
        passowrd = md5(process.argv[4]);
        httpService.login(handle, passowrd);

        break;

    case 'signup':
        handle = process.argv[3];
        httpService.signup(handle);
    
        break;

    case 'completeSignup':
        handle = process.argv[3];
        passowrd = md5(process.argv[4]);
        code = process.argv[5];

        httpService.completeSignup(handle, passowrd, code);
        break;

    case 'invite':
        accessToken = process.argv[3];
        handle = process.argv[4];
        httpService.invite(accessToken, handle);
        break;

    case 'register':
        handle = process.argv[3];
        passowrd = md5(process.argv[4]);
        code = process.argv[5];
        httpService.register(handle, passowrd, code);
        break;

    case 'user':
        accessToken = process.argv[3]; 
        httpService.getUser(accessToken);
        break;
    case 'forgotPassword':
        handle = process.argv[3]; 
        httpService.forgotPassword(handle);
        break;
    case 'resetPassword':
        handle = process.argv[3];
        passowrd = md5(process.argv[4]);
        code = process.argv[5];
        httpService.resetPassword(handle, passowrd, code);
        break;
    case 'changePassword':
        accessToken = process.argv[3];
        currentPassword = process.argv[4];
        newPassword = process.argv[4];
        httpService.resetPassword(handle, currentPassword, newPassword);
        break;
    case 'getApplication':
        
        httpService.getApplication();
        break;
}
 