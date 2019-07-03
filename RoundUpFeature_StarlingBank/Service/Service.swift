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
    
    let authKey = "Authorisation Token"
    let refreshKey = "Refresh Token"
    var authToken = "Bearer Jws4KhgqDS3D7dKS9ibiy797xLZ30B2jmarDBcKWSZJVjFnZU8orrf2GV63UCtCA"
    var refreshToken = "f2zCvcvne7pfVFMTuBSxpN1Sx7eazt9kbMqoBi3J0AGGB91AyhyEK6ycjsLAuZgz"
    let clientId = "c2fa026e-2ea0-4736-bced-3afc839aaaa4"
    
    init() {
        saveAuthTokenToUserDefaults(authToken: authToken)
        obtainAuthTokenFromUserDefaults()
    }
    
    func saveAuthTokenToUserDefaults(authToken: String) {
        UserDefaults.standard.set(authToken, forKey: authKey)
        UserDefaults.standard.set(refreshToken, forKey: refreshKey)
    }
    
    func obtainAuthTokenFromUserDefaults() {
        let accessToken = UserDefaults.standard.value(forKey: authKey) as? String
        let refreshToken = UserDefaults.standard.value(forKey: refreshKey) as? String
        self.authToken = accessToken ?? ""
        self.refreshToken = refreshToken ?? ""
    }
    
    func refreshToken(completion: @escaping (HTTPURLResponse?,Error?)->()) {
        
        print("access token: \(authToken)")
        
        let urlString = "https://api.starlingbank.com/oauth/access-token"
        guard let url = URL(string: urlString) else {return}
        
        let parameters: [String: Any] = [
            "refresh_token": refreshToken,
            "client_id": clientId,
            "grant_type":  "refresh_token"
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(authToken, forHTTPHeaderField: "Authorization")
        request.setValue("0", forHTTPHeaderField: "Content-Length")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            print("successfully encoded to json")
        } catch let error {
            print("Failed to encode Parameters to Json",error.localizedDescription)
        }
        
        
        generalAPICall(request: request, completion: completion)
        
    }
    
    
    func fetchUserAccount(completion: @escaping (UserAccount?,Error?)->()) {
            
            let urlString = "https://api-sandbox.starlingbank.com/api/v2/accounts"
            
            genericFetchAPICall(urlString: urlString, completion: completion)
            
        }
    
    func fetchUserAccountDetails(uid: String?, completion: @escaping (AccountDetails?,Error?) -> () ) {
        guard let uid = uid else {return}
        let urlString = "https://api-sandbox.starlingbank.com/api/v2/accounts/\(uid)/identifiers"
        genericFetchAPICall(urlString: urlString, completion: completion)
    }
    
    func fetchUserAccountBalance(uid: String?, completion: @escaping (Balance?,Error?) -> ()) {
        guard let uid = uid else {return}
        let urlString = "https://api-sandbox.starlingbank.com/api/v2/accounts/\(uid)/balance"
        genericFetchAPICall(urlString: urlString, completion: completion)
    }
    
    func fetchUserTransactions(uid: String?, completion: @escaping (Transactions?,Error?) -> ()) {
        
        guard let uid = uid else {return}
        let categoryUid = "af8f1230-d116-4a7c-981b-71161a7b610a"
        let urlString = "https://api-sandbox.starlingbank.com/api/v2/feed/account/\(uid)/category/\(categoryUid)"
       genericFetchAPICall(urlString: urlString, completion: completion)
        
    }
    
    func fetchUserSavingGoals(uid: String?, completion: @escaping(Goals?,Error?) -> ()) {
        
        guard let uid = uid else {return}
        let urlString = "https://api-sandbox.starlingbank.com/api/v2/account/\(uid)/savings-goals"
        genericFetchAPICall(urlString: urlString, completion: completion)
        
    }
    
    func fetchSavingGoalsPhoto(uid: String?, goalUid: String?, completion: @escaping (SavingsGoalPhoto?,Error?)->()) {
        
        guard let uid = uid else {return}
        guard let goalUid = goalUid else {return}
        
        let urlString = "https://api-sandbox.starlingbank.com/api/v2/account/\(uid)/savings-goals/\(goalUid)/photo"
        
        genericFetchAPICall(urlString: urlString, completion: completion)
    }
    

    // Mark:- Generic API Call that returns a decodable object of type T
        func genericFetchAPICall<T: Decodable> (urlString: String, completion: @escaping (T?,Error?) -> ()) {
            
            print("T is type: ", T.self)
            
            guard let url = URL(string: urlString) else {return}

            var request = URLRequest(url: url)
            request.httpMethod = "Get"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue(authToken, forHTTPHeaderField: "Authorization")
            request.setValue("0", forHTTPHeaderField: "Content-Length")
            
            let session = URLSession(configuration: URLSessionConfiguration.default)
            session.dataTask(with: request) { (data, resp, err) in
                
                if let err = err {
                    print("Failed to make the API call: ",err)
                    completion(nil, err)
                }
                
                guard let data = data else {return}
                
                print(String(data: data, encoding: .utf8) ?? "")
                
                do {
                    
                    let object = try JSONDecoder().decode(T.self, from: data)
                    //print(userAccount)
                    completion(object, nil)
                    
                } catch let jsonErr {
                    print("failed to decode json data",jsonErr)
                    completion(nil,jsonErr)
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
        guard let url = URL(string: urlString) else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "Put"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(authToken, forHTTPHeaderField: "Authorization")
        request.setValue("0", forHTTPHeaderField: "Content-Length")
        
        do {
            let httpBody = try JSONEncoder().encode(fundTransfer)
            request.httpBody = httpBody
        } catch {
            print("failed to encode object to json: ",error)
        }
        
       generalAPICall(request: request, completion: completion)
        
    }

    
    func createNewSavingGoal(uid: String?, newGoal: NewGoal?, completion: @escaping(HTTPURLResponse?, Error?) -> ()) {
        
        guard let uid = uid else {return}
        guard let newGoal = newGoal else {return}
        
        let urlString = "https://api-sandbox.starlingbank.com/api/v2/account/\(uid)/savings-goals"
        guard let url = URL(string: urlString) else {return}
   
        var request = URLRequest(url: url)
        request.httpMethod = "Put"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(authToken, forHTTPHeaderField: "Authorization")
        request.setValue("0", forHTTPHeaderField: "Content-Length")
        
        do {
            let httpBody = try JSONEncoder().encode(newGoal)
            request.httpBody = httpBody
        } catch {
            print("failed to encode object to json: ",error)
        }
        
        generalAPICall(request: request, completion: completion)
        
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
    
    func refreshToken2() {
        
        print("access token: \(authToken)")
        
        let urlString = "https://api.starlingbank.com/oauth/access-token"
        guard let url = URL(string: urlString) else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "Post"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(authToken, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                let response = response as? HTTPURLResponse,
                error == nil else {                                              // check for fundamental networking error
                    print("error", error ?? "Unknown error")
                    return
            }
            
            guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                print("Error: Status Code \(response.statusCode)")
                print("response = \(response)")
                return
            }
            
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
        }
        
        task.resume()
        
    }

}





