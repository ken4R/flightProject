//
//  MockedJsonData.swift
//  FlightCoreData
//
//  Created by Ken 4B on 21/07/2020.
//  Copyright © 2020 Ken 4B. All rights reserved.
//

import Foundation


class AirPortMockedRepo {
    static func loadJson() -> AirPortModel? {
        if let url = Bundle.main.url(forResource: "AirportMocked", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(AirPortModel.self, from: data)
                return jsonData
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
}
