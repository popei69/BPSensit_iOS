//
//  SensitWebManager.swift
//  Sensit
//
//  Created by Benoit PASQUIER on 28/02/2016.
//  Copyright © 2016 Benoit Pasquier. All rights reserved.
//

import UIKit
import AFNetworking
import AFOAuth2Manager

protocol SensitManagerDelegate {
    
    func sensitDidAuthenticate(response: AnyObject?)
    func sensitDidFailAuthenticate(error: NSError)
    func sensitGetDevices(devices: [[String: AnyObject]])
}

extension SensitManagerDelegate {
    
    func sensitDidAuthenticate(response: AnyObject?) { }
    func sensitDidFailAuthenticate(error: NSError) { }
    func sensitGetDevices(devices: [[String: AnyObject]]) { }
}

class SensitWebManager: NSObject {
    
    let urlString = "api.sensit.io"
    let secure = "https://"
    let unsecure = "http://"
    
    let endpoint = "https://api.sensit.io/v2"
    
    let clientId = "XXXXXXXXXX"
    let clientSecret = "XXXXXXXXXX"
    let redirectUrl = "http://api.benoitpasquier.fr/sensit/api.php"
    
    var authCode = ""
    var accessToken = ""
    var tokenType = ""
    var refreshToken = ""
    var expireIn : Int = 0
    var scope = ""
    
    var credential : AFOAuthCredential?
    
    static let sharedManager = SensitWebManager()
    
    var delegate : SensitManagerDelegate?
    
    func requestApplicationToken() {
        
        let sessionManager = AFHTTPRequestOperationManager(baseURL: NSURL(string: urlString))
        sessionManager.requestSerializer = AFJSONRequestSerializer()
        sessionManager.responseSerializer = AFJSONResponseSerializer()
        
        sessionManager.requestSerializer.setAuthorizationHeaderFieldWithUsername(clientId, password: clientSecret)
        
        sessionManager.POST(urlString + "/oauth/token?grant_type=client_credentials", parameters: nil, success: { (operation, response) -> Void in
            print(response)
            }) { (operation, error) -> Void in
                print(error)
        }
        
//        sessionManager.POST(urlString + "/oauth/token?grant_type=client_credentials", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response :AnyObject?) -> Void in
//            
//            print(response)
//            
//            }) { (task: NSURLSessionDataTask?, error : NSError) -> Void in
//                
//            print(error)
//        }
    }
    
    
    func getUserTokenUrl() -> NSURL? {
        
        return NSURL(string: "http://www.sensit.io/oauth/authorize?client_id="+clientId+"&response_type=code&redirect_uri=" + redirectUrl )
    }
    
    func requestUserToken(authCode : String) {
        
        let sessionManager = AFHTTPRequestOperationManager(baseURL: NSURL(string: secure + urlString))
        sessionManager.requestSerializer = AFJSONRequestSerializer()
        sessionManager.responseSerializer = AFJSONResponseSerializer()
        
        sessionManager.requestSerializer.setAuthorizationHeaderFieldWithUsername(clientId, password: clientSecret)
        
        sessionManager.POST(secure + urlString + "/oauth/token?grant_type=authorization_code&code=" + authCode + "&client_id="+clientId+"&redirect_uri="+redirectUrl , parameters: nil, success: { (operation, response) -> Void in
            
            print(response)
            
            if let resp = response as? [String : AnyObject] {
                
                if let accessToken = resp["access_token"] as? String {
                    self.accessToken = accessToken
                }
                
                if let refreshToken = resp["refresh_token"] as? String {
                    self.refreshToken = refreshToken
                }
                
                if let tokenType = resp["token_type"] as? String {
                    self.tokenType = tokenType;
                }
                
                if let expireIn = resp["expires_in"] as? Int {
                    self.expireIn = expireIn
                }
            }
            
            if let delegate = self.delegate {
                
                delegate.sensitDidAuthenticate(response)
            }
            
            }) { (operation, error) -> Void in
                
                print(error)
                
                if let delegate = self.delegate {
                    delegate.sensitDidFailAuthenticate(error)
                }
        }
    }
    
    func requestUserTokenAuth(authCode : String) {
        if let url = NSURL(string: endpoint) {
            let sessionManager = AFOAuth2Manager(baseURL: url, clientID: clientId, secret: clientSecret)
            
            sessionManager.requestSerializer = AFJSONRequestSerializer()
            sessionManager.responseSerializer = AFJSONResponseSerializer()
            
            sessionManager.requestSerializer.setAuthorizationHeaderFieldWithUsername(clientId, password: clientSecret)
            
            sessionManager.authenticateUsingOAuthWithURLString("/oauth/token?grant_type=authorization_code&code=" + authCode + "&client_id="+clientId+"&redirect_uri="+redirectUrl, code: authCode, redirectURI: redirectUrl, success: { (credential) -> Void in
                
                print("Token: " + credential.accessToken)
                self.credential = credential
                
                if let delegate = self.delegate {
                    delegate.sensitDidAuthenticate(nil)
                }
                
                }, failure: { (error) -> Void in
                    print(error)
                    
                    if let delegate = self.delegate {
                        delegate.sensitDidFailAuthenticate(error)
                    }
            })
        }
    }
    
    func getDevices() {
        
//        let sessionManager = AFHTTPRequestOperationManager(baseURL: NSURL(string: secure + urlString))
        let sessionManager = AFHTTPRequestOperationManager(baseURL: NSURL(string: endpoint))
        sessionManager.requestSerializer = AFJSONRequestSerializer()
        sessionManager.responseSerializer = AFJSONResponseSerializer()
        
//        sessionManager.responseSerializer.acceptableContentTypes?.insert("text/html")
        
        if let credential = self.credential {
            sessionManager.requestSerializer.setAuthorizationHeaderFieldWithCredential(credential)
        }
        
        sessionManager.GET("/devices?access_token=" + self.credential!.accessToken, parameters: nil, success: { (operation, response) -> Void in
            // get devices
            
            if let devices = response as? [[String : AnyObject]], let delegate = self.delegate{
                
                delegate.sensitGetDevices(devices)
            }
            
            }) { (operation, error) -> Void in
                
                if let tmpOperation = operation {
                    print(tmpOperation.responseString)
                }
                print(error)
        }
    }

}
