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
    
    static var accessToken = "Bearer eyJhbGciOiJQUzI1NiIsInppcCI6IkdaSVAifQ.H4sIAAAAAAAAAH1Uy5KbMBD8lS3OO1s8BDbccssP5AMGaWSrDBIlCSdbqfx7BBLGOFu5ubvn0TMj_DtTzmVdhpMCQaP5cB7toPSlR3374GbM3jM39yGi4FyU1akPYb0AlvcFtE1NwJjgRd-irKQMwfRryrqiyWt2OrV5-Z4p9JGo2qJeCOTczNp_N4Mg-0OJUJsJdur5KQfWVA0wJAZtnXOgskRWS3E-txRqe3MjnTJqFA3VZyjFuQRWsApCUAMlL2WVU3tCFCEjjPWNc3IuZlXnipWsOEMlmyr0WbLauoQqb6q-RMkaeVoG5maiZSnRKVxXq6BxpM4SircXwX9OL4ISpL2SiuyRH5TzByYBIWww2ZFQ_gGi4j3y60iPyB3_tMrTG87-aqxy4WSgtFB3JWYcYnCPA2qerHG0ArjR3pohNlqYpBktlR3RK6PBSJCzFu4huUf3DcTWfHbejNuINKJKhQcKRvSlw2kaPh9ojRpRC_TUCRoolNhg0uyN_DLIZEmSpeDd_U-KNqI2DcgpbMDTxa5zPCf-K6ZUsvyK23QjeQxusOMBrmrC61ATfhJtUgRpiAj2IFAjXtJMUdt_greoHfLdYaChn4dbt12SdmrvFvHeMOJHgcHwcPSn8JUAs1z_lU1Z1kg1bF6j-QO1RlnipCZ_AO4oxU06vIfrOLiY3ceBS9YP3FrnmYnbCff9qsQuflFrF2NRfiUxDyQgjL1_PY68DwPOU4ITbl9H-NtbXykYK57aH9mt75Hd8j0tjYC7-ys1CZmouXfchq0t19-qPXNr1PMTWQ_z-mayP38B3NpJXLcFAAA.aOwmYZdAgyIQ10O738qHua8R1aQWaCVSjc5VLy_MwBR43WZ5Bx9zbkQGwoYDmIyxip4vrQTXb8GdIrZn91-N9mZdZ8ZMnN-WZuAD7I8c7BSwe_mAyuwhJf3FoH0rJuC9g4Q0DabZZ5Cg9FZk2L0Zgidoa_R6ZaLMgR52_FKbCm__C0NpapcYrqIejkvIy5nt1mdmVycOt46DTcFhU88To9bO266ARragqSAEiK8ISjWX7GDIULSXT3vjwphXlD9WoDFL3uHA1C8z4L5NuRGemusy1g5FxS8bhjXBp-h1nEHaorDnDxrhe8W_xVImTsWixDGnU_wXnQvThyy0qfIkgKgCFhR19LKOCTnpofOjVv1Dxe00JJZKJb--UFtWDG1kaKJg18QIfBMr8khcDsDm5zb4cxsmdGu91AWfT0XZFUTmGHuH03PIg9jvzeVnc5WAU5-5NKOEHgC4R1XYrX0DSjt6z8splsUQkfrcVV5cWCCR1EsQDof516p3KMXgCrSufQdUpD0AW1cb8Fj97h6B_RmekrG1qZt4hB04CY2B3i-VK6qOpuXZL3dTFz-EYEVsJVjuLkA8zqst6V6addFrP84Yd_GGhdu0xnoyCpzGg-GSEPC3nG2nWLgPAaemoYiZajO7whFnFUAzO6c2R3zjrG4idvBbge3Z8XmmgaNnLro"
    var refreshToken = "bSFjOOzeNh9jfvOlUxR7fDlvChcuzI5BwauNHkQMSLWPKg6T8zWl9x7HtyPIhgaZ"
    let userAgent = "Muhammad Shahrukh"
    let clientId = "hHImUzRJiynSMpSEvCVe"
    let clientSecret = "tqmYxumZRsdKuA6SnP4ZVsHaTctcnw70btrdscXp"
    
    // MARK:- Refresh Token Method
    func refreshToken(completion: @escaping (Data?, HTTPURLResponse?, Error?)->()) {
                
        let urlString = "https://api-sandbox.starlingbank.com/oauth/access-token"
        guard let url = URL(string: urlString) else {return}
        
        let headers = ["Content-Type": "application/x-www-form-urlencoded"]
        
        let data : Data = "refresh_token=\(refreshToken))&client_id=\(clientId)&client_secret=\(clientSecret)&grant_type=refresh_token".data(using: .utf8)!
        
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
                           "Authorization": Service.accessToken, "User-Agent": userAgent]

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
                       "Authorization": Service.accessToken, "User-Agent": userAgent]
        
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
                       "Authorization": Service.accessToken, "User-Agent": userAgent]
        
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
                    
                    print("Failed Status Code: \(resp.statusCode)")
                    
                    completion(nil, resp, nil)
                    
                    if let respErr = data {
                        
                        print("Error data: ", String(data: respErr, encoding: .utf8) ?? "")
                        
                    }
                    
                    return }
                
                print("Success - Status Code: ", resp.statusCode)
                completion(nil, resp, nil)
                
                guard let data = data else {return}
                
                do {
                    
                    let object = try JSONDecoder().decode(RefreshToken.self, from: data)
                    Service.accessToken = "Bearer \(object.accessToken)"
                    self.refreshToken = "\(object.refreshToken)"
                    
                } catch let jsonErr {
                    
                    print("failed to decode json data",jsonErr)
                    
                }
            }
            }.resume()
        
    }

}
    
    
    

