//
//  ServiceViewController.swift
//  RoundUpFeature_StarlingBank
//
//  Created by Muhammad Shahrukh on 6/27/19.
//  Copyright © 2019 Muhammad Shahrukh. All rights reserved.
//

import UIKit

class Service {
    
    static let shared = Service()
    
    var accessToken = "Bearer slPxPtcb6fxr25SwrNh6t59kdAWB3Ce2KYEKs9EuvNNFv4LlmewYNCa6SJWBAcRe"
    var refreshToken = "Bearer xvJJf9hdzupdEZ4M4FhWcjJ5jBEGWUoczwiSe7WjNmnMqhT84hTPVCVlZKzK8s7h"
    let userAgent = "Muhammad Shahrukh"
    let clientId = "udPqv6TYYrJrXVlM3b8U"
    let clientSecret = "RjjEVEhzmlV1SWGpYGixyPXN2kSEvoxYbSsi48Fe"
    
    // Mark:- Refresh Token Method
    func refreshToken(completion: @escaping (HTTPURLResponse?, Error?)->()) {
        
        print("access tokens: \(accessToken)")
        
        let urlString = "https://api.starlingbank.com/oauth/access-token"
        guard let url = URL(string: urlString) else {return}
        
        let headers = ["Content-Type": "application/x-www-form-urlencoded",
                       "Authorization": accessToken, "User-Agent": userAgent]
        
        let parameters: [String: Any] = [
            "refresh_token": refreshToken,
            "client_id": clientId,
            "client_secret": clientSecret,
            "grant_type":  "refresh_token"
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "Post"
        request.allHTTPHeaderFields = headers
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [.prettyPrinted]) // pass dictionary to nsdata object and set it as request body
            print("successfully encoded to json")
        } catch let error {
            print("Failed to encode Parameters to Json",error.localizedDescription)
        }
        
        //refreshAccessToken(request: request, completion: completion)
        generalAPICall(request: request, completion: completion)
        
    }
    
    // MARK:- All Get Methods
    func fetchUserAccount(completion: @escaping (UserAccount?, URLResponse?, Error?)->()) {
            
            let urlString = "https://api-sandbox.starlingbank.com/api/v2/accounts"
            
            genericGetAPICall(urlString: urlString, completion: completion)
            
        }
    
    func fetchUserAccountDetails(uid: String?, completion: @escaping (AccountDetails?, URLResponse?, Error?) -> () ) {
        guard let uid = uid else {return}
        let urlString = "https://api-sandbox.starlingbank.com/api/v2/accounts/\(uid)/identifiers"
        genericGetAPICall(urlString: urlString, completion: completion)
    }
    
    func fetchUserAccountBalance(uid: String?, completion: @escaping (Balance?, URLResponse?, Error?) -> ()) {
        guard let uid = uid else {return}
        let urlString = "https://api-sandbox.starlingbank.com/api/v2/accounts/\(uid)/balance"
        genericGetAPICall(urlString: urlString, completion: completion)
    }
    
    func fetchUserTransactions(uid: String?, categoryUid: String?, completion: @escaping (Transactions?, URLResponse?, Error?) -> ()) {
        
        guard let uid = uid else {return}
        guard let categoryUid = categoryUid else {return}
        let urlString = "https://api-sandbox.starlingbank.com/api/v2/feed/account/\(uid)/category/\(categoryUid)"
       genericGetAPICall(urlString: urlString, completion: completion)
        
    }
    
    func fetchUserSavingGoals(uid: String?, completion: @escaping(Goals?, URLResponse?, Error?) -> ()) {
        
        guard let uid = uid else {return}
        let urlString = "https://api-sandbox.starlingbank.com/api/v2/account/\(uid)/savings-goals"
        genericGetAPICall(urlString: urlString, completion: completion)
        
    }
    
    func fetchSavingGoalsPhoto(uid: String?, goalUid: String?, completion: @escaping (SavingsGoalPhoto?, URLResponse?, Error?)->()) {
        
        guard let uid = uid else {return}
        guard let goalUid = goalUid else {return}
        
        let urlString = "https://api-sandbox.starlingbank.com/api/v2/account/\(uid)/savings-goals/\(goalUid)/photo"
        
        genericGetAPICall(urlString: urlString, completion: completion)
    }

    // Mark:- Generic "GET" API Call that returns a decodable object of type T
        func genericGetAPICall<T: Decodable> (urlString: String, completion: @escaping (T?, URLResponse?, Error?) -> ()) {
            
            print("T is type: ", T.self)
            
            guard let url = URL(string: urlString) else {return}
            let headers = ["Content-Type": "application/json",
                           "Authorization": accessToken, "User-Agent": userAgent]

            var request = URLRequest(url: url)
            request.httpMethod = "Get"
            request.allHTTPHeaderFields = headers
            
            let session = URLSession(configuration: URLSessionConfiguration.default)
            session.dataTask(with: request) { (data, resp, err) in
                
                if let err = err {
                    print("Failed to make the API call: ",err)
                    completion(nil, resp, err)
                }
                
                if let resp = resp as? HTTPURLResponse {
                    
                    guard (200 ... 299) ~= resp.statusCode else {                    // check for http errors
                        print("Error: Status Code \(resp.statusCode)")
                        return
                    }
                    
                    print("Success: Status Code \(resp.statusCode)")
                }
                
                guard let data = data else {return}
                
                print(String(data: data, encoding: .utf8) ?? "")
                
                do {
                    
                    let object = try JSONDecoder().decode(T.self, from: data)
                    //print(userAccount)
                    completion(object, nil, nil)
                    
                } catch let jsonErr {
                    print("failed to decode json data",jsonErr)
                    completion(nil, nil, jsonErr)
                }
                
                }.resume() // fires off the request
            
        }
    
    func transferFundstoSavingGoal(uid: String?, goalUid: String?, amount: Amount?, completion: @escaping (HTTPURLResponse?,Error?) -> ()) {
        
        guard let uid = uid else {return}
        guard let goalUid = goalUid else {return}
        let transferUid = UUID().uuidString
        
        guard let amount = amount else {return}
        let fundTransfer = FundTransfer(amount: amount)
        
        let urlString = "https://api-sandbox.starlingbank.com/api/v2/account/\(uid)/savings-goals/\(goalUid)/add-money/\(transferUid)"
        
        genericPutAPICall(urlString: urlString, object: fundTransfer, completion: completion)
        
    }

    
    func createNewSavingGoal(uid: String?, newGoal: NewGoal?, completion: @escaping(HTTPURLResponse?, Error?) -> ()) {
        
        guard let uid = uid else {return}
        guard let newGoal = newGoal else {return}
        
        let urlString = "https://api-sandbox.starlingbank.com/api/v2/account/\(uid)/savings-goals"
        
        genericPutAPICall(urlString: urlString, object: newGoal, completion: completion)
        
    }
    
    func genericPutAPICall<T: Encodable> (urlString: String?, object: T?, completion: @escaping (HTTPURLResponse?, Error?)->()){
        
        guard let urlString = urlString else {return}
        guard let url = URL(string: urlString) else {return}
        guard let object = object else {return}
        
        let headers = ["Content-Type": "application/json",
                       "Authorization": accessToken, "User-Agent": userAgent]
        
        var request = URLRequest(url: url)
        request.httpMethod = "Put"
        request.allHTTPHeaderFields = headers
        
        do {
            let httpBody = try JSONEncoder().encode(object)
            request.httpBody = httpBody
        } catch {
            print("failed to encode object to json: ",error)
        }
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: request) { (data, resp, err) in
            
            if let err = err {
                //print(err)
                completion(nil,err)
                return
            }
            
            if let resp = resp as? HTTPURLResponse {
                //print(resp)
                completion(resp,nil)
            }
            
            }.resume()
        
    }
    
    
    func generalAPICall(request: URLRequest?, completion: @escaping (HTTPURLResponse?, Error?)->()){
        
        guard let request = request else {return}
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: request) { (data, resp, err) in
            
            if let err = err {
                //print(err)
                completion(nil,err)
                return
            }
            
            if let resp = resp as? HTTPURLResponse {
                //print(resp)
                completion(resp,nil)
            }
            
            }.resume()
        
    }
    
    // Extra refresh access token Function
    func refreshAccessToken(request: URLRequest?, completion: @escaping (HTTPURLResponse?, Error?)->()) {
        
        guard let request = request else {return}
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: request) { (data, resp, err) in
            
            if let resp = resp as? HTTPURLResponse  {
                
                completion(resp,nil)
                
                guard (200 ... 299) ~= resp.statusCode else { // check for http errors
                    print("Status Code: \(resp.statusCode)")
                    return }
                
                print(resp)
                
            }
            
            if let data = data {
                
                do {
                    
                    let object = try JSONDecoder().decode(RefreshToken.self, from: data)
                    self.accessToken = "Bearer \(object.accessToken)"
                    self.refreshToken = "Bearer \(object.refreshToken)"
                    
                } catch let jsonErr {
                    
                    print("failed to decode json data",jsonErr)
                    
                    completion(nil,jsonErr)
                    
                }
            }
            
        }.resume()
    }

    
}





