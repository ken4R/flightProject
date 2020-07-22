//
//  API.swift
//  FlightCoreData
//
//  Created by Braham Youssef on 7/22/20.
//  Copyright © 2020 Ken 4B. All rights reserved.
//

import Foundation


class APIManager {
    
    
    private let baseUrl = "https://avwx.rest/api/station/ident?format=json"
    
    private static var instance: APIManager!
    
    static var shared: APIManager {
        get{
            if(instance == nil){
                instance = APIManager()
            }
            return instance
        }
    }
    
    func register(params: [String: String], delegate: APIWSDelegate) {
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params)
        let url = URL(string: baseUrl + APIEndPoints.register.rawValue)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                if let mCode = responseJSON["Code"] as? String{
                    if mCode == "OK" {
                        delegate.didFinishRequest(endPoint: APIEndPoints.register, message: "", error: nil, userInfo: responseJSON)
                    }else{
                        if let errorMsg = responseJSON["Message"] as? String {
                            DispatchQueue.main.async {
                                delegate.didFinishRequest(endPoint: APIEndPoints.register, message: "", error: errorMsg, userInfo: nil)
                            }
                        }
                    }
                }
            }
        }
        
        task.resume()
    }
    
    func getStation() {
        guard let url = URL(string: baseUrl ) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("", forHTTPHeaderField: "Authorization:Token")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
            }
        }
        
        task.resume()
    }
    
    
}

protocol APIWSDelegate {
    func didFinishRequest(endPoint: APIEndPoints, message: String, error: String?, userInfo: [String: Any]?)
}

enum APIEndPoints: String {
    case register = "/account/register"
    case login = "/account/mlogin"
    case forgotPassword = "/account/emailforgot"
}
