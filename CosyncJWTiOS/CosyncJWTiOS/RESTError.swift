//
//  RESTError.swift
//  CosyncJWTiOS
//
//  Created by Richard Krueger on 8/10/20.
//  Copyright © 2020 cosync. All rights reserved.
//

import Foundation

enum RESTError: Error {
    case invalidAppToken                // 400
    case appNoLongerExist               // 401
    case appSuspended                   // 402
    case missingParameter               // 403
    case accountSuspended               // 404
    case invalidAccessToken             // 405
    case appInviteNotSupported          // 406
    case appSignupNotSupported          // 407
    case appGoogle2FactorNotSupported   // 408
    case appPhone2FactorNotSupported    // 409
    case appUserPhoneNotVerified        // 410
    case expiredSignupCode              // 411
    case internalServerError            // 500
    case invalidLoginCredentials        // 600
    case handleAlreadyRegistered        // 601
    case invalidData                    // 602
    case emailDoesNotExist              // 603
    case invalidMetaData                // 604
    
    case invalidPassword
    
    var message: String {
        switch self {
        case .invalidAppToken:
            return "invalid app token"
        case .appNoLongerExist:
            return "app no longer exists"
        case .appSuspended:
            return "app is suspended"
        case .missingParameter:
            return "missing parameter"
        case .accountSuspended:
            return "user account is suspended"
        case .invalidAccessToken:
            return "invalid access token"
        case .appInviteNotSupported:
            return "app does not support invite"
        case .appSignupNotSupported:
            return "app does not support signup"
        case .appGoogle2FactorNotSupported:
            return "app does not support google two-factor verification"
        case .appPhone2FactorNotSupported:
            return "app does not support phone two-factor verification"
        case .appUserPhoneNotVerified:
            return "user does not have verified phone number"
        case .expiredSignupCode:
            return "expired signup code"
        case .internalServerError:
            return "internal server error"
        case .invalidLoginCredentials:
            return "invalid login credentials"
        case .handleAlreadyRegistered:
            return "handle already registered"
        case .invalidData:
            return "invalid data"
        case .emailDoesNotExist:
            return "email does not exist"
        case .invalidMetaData:
            return "invalid metadata"
        case .invalidPassword:
            return "invalid Password"
        }
    }
    
    static func checkResponse(data: Data?, response: URLResponse?, error: Error?) -> RESTError? {
        
        if error != nil {
            return RESTError.internalServerError
        }
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode == 200 {
                return nil
            }
            else if httpResponse.statusCode == 400 {
                if let content = data {
                    if let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] {
                        if let code = json["code"] as? Int {
                            switch code {

                            case 400:
                                return RESTError.invalidAppToken
                            case 401:
                                return RESTError.appNoLongerExist
                            case 402:
                                return RESTError.appSuspended
                            case 403:
                                return RESTError.missingParameter
                            case 404:
                                return RESTError.accountSuspended
                            case 405:
                                return RESTError.invalidAccessToken
                            case 406:
                                return RESTError.appInviteNotSupported
                            case 407:
                                return RESTError.appSignupNotSupported
                            case 408:
                                return RESTError.appGoogle2FactorNotSupported
                            case 409:
                                return RESTError.appPhone2FactorNotSupported
                            case 410:
                                return RESTError.appUserPhoneNotVerified
                            case 411:
                                return RESTError.expiredSignupCode
                            case 500:
                                return RESTError.internalServerError
                            case 600:
                                return RESTError.invalidLoginCredentials
                            case 601:
                                return RESTError.handleAlreadyRegistered
                            case 602:
                                return RESTError.invalidData
                            case 603:
                                return RESTError.emailDoesNotExist
                            case 604:
                                return RESTError.invalidMetaData
                            default:
                                return RESTError.internalServerError
                            }
                        } else {
                            return RESTError.internalServerError
                        }
                    } else {
                        return RESTError.internalServerError
                    }
                } else {
                    return RESTError.internalServerError
                }
            } else if httpResponse.statusCode == 500 {
                return RESTError.internalServerError
            }
        }
        return RESTError.internalServerError
    }
}
