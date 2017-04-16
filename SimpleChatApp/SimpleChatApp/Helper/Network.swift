//
//  Network.swift
//  SimpleChatApp
//
//  Created by Nestor Angelo Tan on 14/04/2017.
//  Copyright © 2017 NTan. All rights reserved.
//

import Foundation


class Network {
    
    
    static let baseURL = "https://mysimplechatapp.herokuapp.com/" //"http://localhost:3000/"
    
    
    // Post request
    func post(endpoint: String, paramString: String,  completion: @escaping(_ responseData: Any) -> Void) {
        
        let url = "\(Network.baseURL)\(endpoint)"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        
        let postString = paramString
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          
            guard let data = data, error == nil else {
                print("error=\(String(describing: error))")
                completion(error!)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                
                let invalidCode = ["error":"Invalid status code"]
                
                completion(invalidCode)
            }
            
            do {
                let responseData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                
                completion(responseData!)
            }
            catch {
                
                print(error.localizedDescription)
                completion(error)
            }
            
            
            
        }
        
        task.resume()
    }
    
    // Get request
    func get(endpoint: String, paramString: String) {
        
        let url = "\(Network.baseURL)\(endpoint)"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        
        let postString = paramString
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                 print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
        }
        
        task.resume()
    }
    
}
