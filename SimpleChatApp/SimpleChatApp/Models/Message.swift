//
//  Message.swift
//  SimpleChatApp
//
//  Created by Nestor Angelo Tan on 14/04/2017.
//  Copyright © 2017 NTan. All rights reserved.
//

import Foundation

class Message {
    
    var id = ""
    var userId = ""
    var username = ""
    var content = ""
    
    init (messageData: Dictionary<String, Any>) {
        
        // check message id
        if let id = messageData["_id"] as? String {
            self.id = id
        }
        
        // message content
        if let content = messageData["body"] as? String {
            self.content = content
        }
        
        if let user = messageData["user"] as? Dictionary<String, String> {
            
            if let userId = user["_id"] {
                self.userId = userId
            }
            
            if let username = user["username"] {
                self.username = username
            }
        }
    }
    
}
