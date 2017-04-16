//
//  SocketManager.swift
//  SimpleChatApp
//
//  Created by Nestor Angelo Tan on 15/04/2017.
//  Copyright © 2017 NTan. All rights reserved.
//

import Foundation
class ChatSocket {
    
    private var socketClient: SocketIOClient
    
    // Instance - Singleton
    init (token: String) {
        
        self.socketClient = SocketIOClient(socketURL: URL(string:Network.baseURL)!,config: [.connectParams(["token":token])])
      
        
      
    }
    
    // Send
    func sendMessage(messageString: String) {
        
        if(messageString.characters.count > 0) {
            self.socketClient.emit("message", messageString)
        }
    }

    // Listen to Reply
    func listenMessages (completion: @escaping(_ message: Array<Message>) -> Void) {
        
        // add handlers / listeners
        self.socketClient.on("message") {data, ack in
           
            var messageArray: Array<Message> = []
            
            // handle from get messages
            if let messages =  data[0] as? Array<Any> {
                
                for object in messages{
                    
                    if let messageData = object as? Dictionary<String, Any> {
                        
                        // create message object
                        let message = Message(messageData: messageData)
                        messageArray.append(message)
                    }
                }
            }
            
            // handle from send message
            if let messageData = data[0] as? Dictionary<String, Any> {
                
                let message = Message(messageData: messageData)
                messageArray.append(message)
            }
            
            // completion return messagesArray
            completion(messageArray)
        }
        
    }

    // Disconnect
    func disconnect() {
        
        // remove handlers and disconnect
        self.socketClient.removeAllHandlers()
        self.socketClient.disconnect()
    }
    
    // connect
    func connect (completion: @escaping() -> Void) {
        
        self.socketClient.on("connect") {data, ack in
            print("socket connected")
            
            self.socketClient.emit("get messages")
            
            self.socketClient.on("error") {data, ack in
                print(data)
            }
            
            completion()
            
        }
        self.socketClient.connect()
    }

}
