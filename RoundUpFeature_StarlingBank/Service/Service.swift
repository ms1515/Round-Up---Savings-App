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
    
    var accessToken = "Bearer eyJhbGciOiJQUzI1NiIsInppcCI6IkdaSVAifQ.H4sIAAAAAAAAAH1Uy5KbMBD8lS3Oqy0sBAZuueUH8gEjaWSrDBIlCSdbqfx7BBLGOFu5ubvn0TMj_LvQ3hd9AZMmEkf74QO4QZsLB3P7EHYs3gs_8xhxEkLS6sxjGJeElfxEuqZGwpgUJ96BqpSKwfhrKvpTU9bsTGnN3gsNIRFVW7cLAULY2YTvdpDofmgZazPJzlycS8KaqiEMkJGuLgVBSoHVSrZth7F2sDc0OaNmWFFaEgpAoxvGSVdGcyg5VVUn-amhMSOO9U0I9D5lVW3FKDu1pFJNFfuwirRdTUlVNhWnoFijzsvAwk64LCU5JdfVKjEwYu8Q5NuLED6nF0FLNEErje7ID9qHA5OBlC6a7FHq8ABJCQHEdcRH5I5_Oh3wDeZwtU77eDKijdR3LWcYUjCHAYzI1gQ4SYQ1wdkhNVqYrFmjtBshaGuIVUTNRvqH5B_dN5Bai9kHO24j4gg6Fx4wGjGXHqZp-HygNWoEIyFgL3HAWGKDWXM3DMsgk0OFDqN3_z8p2UjaNIDAuIGAF7fO8Zz4r5hT0YkrbNONGCC6gV5EuKoZr0NN8Im4SQnkIRLYg4ge4ZJnStr-kwQHxoPYHUaa8Hm49dslcaf2bgnvDRN-FBisiEd_Cl8JYpfrv7I5y1mlh81rMn-g1iiHAvUUDsAfpbRJD_d4HU8udvdx4LL1A7fWeWbSduJ9vyqxi1_U2sVUVFxRzgNKEsfevx6PIcQB5ynDCbavI_7tra-UWCef2h_Zre-R3fIDLo2I8PdXapIqUzP3wsWtLdffqj1za9TzE1kP8_pmij9_AcsyE6O3BQAA.Af_7pClPK6SYlERkgYMwC71GlhQri79mo8sxn9POP6RdWrfrlXz1S6IRjI-4x9u9sHl_PDX8xRPiSLg8uYjdFxeMe0iVLbea88VIKOUX9SPiAOw5R7JsXrR439VN5D_X2QnXurFgj4dwzbGAT0kGoUwNNf2uS2mBbmWztCoxg3uoPsWXLQTcYTOQWzBso7wv4p95agCTSvY80j2wuM0_9hILYSdynLsAhnXjXNXT041GyNQ9ieeiI5MvRto0-Smx-cwjQjbCGtCHlPIFuRqosbnSTQfL-IEMgVk2V7Q7qXWXDk6rg6lgBvxCX5uZibR1_aPfDgYyMOXoN21tlcLc9fkN1n42q_lnxInYnWDcw7AqCfzZV4sq3tnsgb7_oMLH3o4aaCqEJoSHm6VubvU9INzjozWZi2C34rvRpnxwp7NyBf89zRLy0KikhOY5mDqJ-sgopRmsR_8gPL8zzq4u6-Q-cSMYC3vkktsYDFkpRz5-WoNZV8-HrWBNc39sViSp4SzzOBibiqjd5N_rpdR7tbcsViy9NGDUZW6KTnDCUYdyDCumXgG6Wj19S0-W3YBvMUeVS19Bx72f7OLu-b2oEPKPAt0SsVxAeAMZBNMKqj-pDpPl7LiGsVZ9TX8cVGFifSdGsHdaHpXRY4VhLM0_0Fi6av5-r2h-KKQ5z_mMR3E"
    var refreshToken = "Bearer OY3R8aldgvYOvOyGhxpmszm1nCWLqLRD1ycP2xGlDOQdjOlSZDdRhQ9t1kCXxypk"
    let userAgent = "Muhammad Shahrukh"
    let clientId = "hHImUzRJiynSMpSEvCVe"
    let clientSecret = "tqmYxumZRsdKuA6SnP4ZVsHaTctcnw70btrdscXp"
    
    // MARK:- Refresh Token Method
    func refreshToken(completion: @escaping (Data?, HTTPURLResponse?, Error?)->()) {
                
        let urlString = "https://api-sandbox.starlingbank.com/oauth/access-token"
        guard let url = URL(string: urlString) else {return}
        
        let headers = ["Content-Type": "application/x-www-form-urlencoded"]
        
        let data : Data = "refresh_token=\(refreshToken)&client_id=\(clientId)&client_secret=\(clientSecret)&grant_type=refresh_token".data(using: .utf8)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "Post"
        request.allHTTPHeaderFields = headers
        request.httpBody = data

        /**
         You cannot send json data when the endpoint accepts x-www-form-urlencoded
         */
//        let body = [
//             "grant_type": "refresh_token",
//             "client_secret": clientSecret,
//             "client_id": clientId,
//             "refresh_token": refreshToken
//           ]
//        do {
//        request.httpBody = try JSONEncoder().encode(body)
//        } catch {
//            print("failed to encode object to json: ",error)
//        }
        
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
    
    func genericPostAPICall<T: Encodable> (urlString: String?, object: T?, completion: @escaping (HTTPURLResponse?, Error?)->()){
        
        guard let urlString = urlString else {return}
        guard let url = URL(string: urlString) else {return}
        guard let object = object else {return}
        
        let headers = ["Content-Type": "application/json",
                       "Authorization": accessToken, "User-Agent": userAgent]
        
        var request = URLRequest(url: url)
        request.httpMethod = "Post"
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
    
    
    

