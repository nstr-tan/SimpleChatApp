//
//  User.swift
//  SimpleChatApp
//
//  Created by Nestor Angelo Tan on 14/04/2017.
//  Copyright © 2017 NTan. All rights reserved.
//

import Foundation


class User {
    
    var username = ""
    var id = ""
    
    
    func login(username: String, password: String, completion: @escaping(_ success: Bool, _ message: String) -> Void) {
        
        let network = Network ()
        
        let postString = "username=\(username)&password=\(password)"
        let endPoint = "oauth/token"
        
        network.post(endpoint: endPoint, paramString: postString) { responseData in
            
            if let data = responseData as? Dictionary<String, Any> {
                
                // check if token and idexists
                if let token = data["token"] as? String, let userId = data["userId"] as? String {
                    
                    // set id
                    self.id = userId
                    
                    // set username
                    self.username = username
                    
                    // store token
                    KeychainService.saveToken(token: NSString(string:token))
                    
                    // return success
                    completion(true,"Success")
                    
                } else {
                    
                    // else return error
                    if let errorMessage = data["error"] as? String {
                        
                        completion(false,errorMessage)
                        
                    } else {
                        completion(false,"Server error occured.")
                    }

                }
                
            }
            else {
                // return server error occured
                completion(false,"Server error occured.")
            }
            
        }

    }
    
    func register(username: String, password: String, completion: @escaping(_ success: Bool, _ message: String) -> Void) {
        
        let network = Network ()
        
        let postString = "username=\(username)&password=\(password)"
        let endPoint = "users"
        
        network.post(endpoint: endPoint, paramString: postString) { responseData in
            
            if let data = responseData as? Dictionary<String, Any> {
                
                // check if id exists
                if let userId = data["_id"] as? String {
                    
                    // set id
                    self.id = userId
                    
                    // set username
                    self.username = username
                    
                    // return success
                    completion(true,"Success")
                    
                } else {
                    
                    // else return error
                    if let errorMessage = data["error"] as? String {
                        
                        completion(false,errorMessage)
                        
                    } else {
                        completion(false,"Server error occured.")
                    }
                    
                }
                
            }
            else {
                // return server error occured
                completion(false,"Server error occured.")
            }
            
        }
        
    }
}

