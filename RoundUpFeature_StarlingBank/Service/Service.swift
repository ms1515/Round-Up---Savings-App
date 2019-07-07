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
    
    var accessToken = "Bearer xfuoBYwY4PJR0vYP3Ps2oxx1ocRGYXcLkefsXNAVk1g2vv0K8iBD2kTwJ6l3PnP4"
    var refreshToken = "Bearer w0EEKweogoWrru7uKgAx2XKvjTc0R340iwuWdNPVAL2v4780xcalucwciZaupq15"
    let userAgent = "Muhammad Shahrukh"
    let clientId = "udPqv6TYYrJrXVlM3b8U"
    let clientSecret = "RjjEVEhzmlV1SWGpYGixyPXN2kSEvoxYbSsi48Fe"
    
    // MARK:- Refresh Token Method
    func refreshToken(completion: @escaping (Data?, HTTPURLResponse?, Error?)->()) {
        
        print("access token: \(accessToken)")
        
        let urlString = "https://api.starlingbank.com/oauth/access-token"
        guard let url = URL(string: urlString) else {return}
        
        let headers = ["Content-Type": "application/x-www-form-urlencoded"]
        
        let data : Data = "refresh_token=\(refreshToken)&client_id=\(clientId)&client_secret=\(clientSecret)&grant_type=refresh_token".data(using: .utf8)!
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "Post"
        request.allHTTPHeaderFields = headers
        request.httpBody = data
        
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

    // MARK:- Generic "GET" API Call that returns a decodable object of type T
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
                    completion(nil, nil, err)
                }
                
                if let resp = resp as? HTTPURLResponse {
                    
                    guard (200 ... 299) ~= resp.statusCode else {                    // check for http errors
                        print("Error: Status Code \(resp.statusCode)")
                        completion(nil,resp,nil)
                        return
                    }
                    
                    print("Success: Status Code \(resp.statusCode)")
                
                guard let data = data else {return}
                
                print(String(data: data, encoding: .utf8) ?? "")
                
                do {
                    
                    let object = try JSONDecoder().decode(T.self, from: data)
                    completion(object, resp, nil)
                    
                } catch let jsonErr {
                    print("failed to decode json data",jsonErr)
                    completion(nil, resp, jsonErr)
                }
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
    
    
    func generalAPICall(request: URLRequest?, completion: @escaping (Data?, HTTPURLResponse?, Error?)->()) {
        
        guard let request = request else {return}
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: request) { (data, resp, err) in
            
            if let err = err {
                completion(nil, nil, err)
                return
            }
            
            if let resp = resp as? HTTPURLResponse {

                guard (200 ... 299) ~= resp.statusCode else { // check for http errors
                    
                    print("Status Code: \(resp.statusCode)")
                    
                    completion(nil, resp, nil)
                    
                    if let respErr = data {
                        
                        print(String(data: respErr, encoding: .utf8) ?? "")
                        
                    }
                    
                    return }
                
                completion(nil, resp, nil)
                guard let data = data else {return}
                
                do {
                    
                    let object = try JSONDecoder().decode(RefreshToken.self, from: data)
                    self.accessToken = "Bearer \(object.accessToken)"
                    self.refreshToken = "Bearer \(object.refreshToken)"
                    
                    
                } catch let jsonErr {
                    
                    print("failed to decode json data",jsonErr)
                    
                }
            }
            
            }.resume()
        
    }
    
}

    
    // MARK: Extra functions for refreshing the token
 /*
    func refreshAccessToken() {
        
        let urlString = "https://api.starlingbank.com/oauth/access-token"
        guard let url = URL(string: urlString) else {return}
        
        let headers = ["Content-Type": "application/x-www-form-urlencoded"]
        
        let headers2 = ["Accept" : "application/json", "Content-Type": "application/x-www-form-urlencoded",
                       "Authorization": accessToken, "User-Agent": userAgent]
        
        let parameters: [String: Any] = [
            
            "refresh_token": refreshToken,
            "client_id": clientId,
            "client_secret": clientSecret,
            "grant_type":  "refresh_token"
            
        ]
        
        let postData = NSMutableData(data: "refresh_token=\(refreshToken)".data(using: .utf8)!)
        postData.append("&client_id=\(clientId)".data(using: .utf8)!)
        postData.append("&client_secret=\(clientSecret)".data(using: .utf8)!)
        postData.append("&grant_type=refresh_token".data(using: .utf8)!)
        
        let data : Data = "refresh_token=\(refreshToken)&client_id=\(clientId)&client_secret=\(clientSecret)&grant_type=refresh_token".data(using: .utf8)!
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "Post"
        request.allHTTPHeaderFields = headers
        request.httpBody = Data(data)
        
        /*
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [.prettyPrinted]) // pass dictionary to nsdata object and set it as request body
            print("successfully encoded to json")
        } catch let error {
            print("Failed to encode Parameters to Json",error.localizedDescription)
        }*/
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { (data, resp, err) in
            
            if let resp = resp as? HTTPURLResponse  {
                
                guard (200 ... 299) ~= resp.statusCode else { // check for http errors
                    
                    print("Status Code: \(resp.statusCode)")
                    
                
                if let respErr = data {
                    
                    print(String(data: respErr, encoding: .utf8) ?? "")
                    
                    }
                    
                    return }
                
                guard let data = data else {return}
                    
                    do {
                        
                        let object = try JSONDecoder().decode(RefreshToken.self, from: data)
                        self.accessToken = "Bearer \(object.accessToken)"
                        self.refreshToken = "Bearer \(object.refreshToken)"
                        
                        
                    } catch let jsonErr {
                        
                        print("failed to decode json data",jsonErr)
                        
                    }
                }
                
                
        }; dataTask.resume()
        }
    
    
    // MARK:- Final Method for refresh access token
    func finalRefreshToken() {
        
        guard let url = URL(string: "https://api.starlingbank.com/oauth/access-token") else {
            return
        }
    
        let data : Data = "refresh_token=\(refreshToken)&client_id=\(clientId)&client_secret=\(clientSecret)&grant_type=refresh_token".data(using: .utf8)!
        
        var request : URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type");
        request.setValue(NSLocalizedString("lang", comment: ""), forHTTPHeaderField:"Accept-Language");
        request.httpBody = data
        
        print("one called")
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        // vs let session = URLSession.shared
        // make the request
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) in
            
            if let error = error
            {
                print(error)
            }
            else if let response = response {
                print("her in resposne")
                
            }else if let data = data
            {
                print("here in data")
                print(data)
            }
            
            DispatchQueue.main.async { // Correct
                
                guard let responseData = data else {
                    print("Error: did not receive data")
                    return
                }
                
                let decoder = JSONDecoder()
                print(String(data: responseData, encoding: .utf8))
                do {
                    //  let todo = try decoder.decode(T.self, from: responseData)
                    //  NSAssertionHandler(.success(todo))
                } catch {
                    print("error trying to convert data to JSON")
                    //print(error)
                    //  NSAssertionHandler(.failure(error))
                }
            }
        })
        
        task.resume()
    
    } */






