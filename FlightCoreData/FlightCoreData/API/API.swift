//
//  API.swift
//  FlightCoreData
//
//  Created by Braham Youssef on 7/22/20.
//  Copyright © 2020 Ken 4B. All rights reserved.
//

import Foundation


class APIManager {
    
    
    private let baseUrl = "https://avwx.rest/api"
    
    private static var instance: APIManager!
    
    static var shared: APIManager {
        get{
            if(instance == nil){
                instance = APIManager()
            }
            return instance
        }
    }
    
    
    func getStation(delegate: APIWSDelegate){
        guard let url = URL(string: baseUrl + APIEndPoints.station.rawValue ) else { return}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            delegate.didFinishRequest(endPoint: .station, response: data)
        }
        
        task.resume()
    }
    
    
}

protocol APIWSDelegate {
    func didFinishRequest(endPoint: APIEndPoints, response: Data?)
}

enum APIEndPoints: String {
    case station = "/station/KJFK"
}
