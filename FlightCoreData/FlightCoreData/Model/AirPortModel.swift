//
//  AirPortModel.swift
//  FlightCoreData
//
//  Created by Ken 4B on 21/07/2020.
//  Copyright © 2020 Ken 4B. All rights reserved.
//

import Foundation

// MARK: - AirPort
struct AirPort: Codable {
    let city, country: String?
    let elevationFt, elevationM: Int?
    let iata, icao: String?
    let latitude, longitude: Double?
    let name, note: String?
    let reporting: Bool?
    let runways: [Runway]?
    let state, type: String?
    let website: String?
    let wiki: String?
    
    enum CodingKeys: String, CodingKey {
        case city, country
        case elevationFt
        case elevationM
        case iata, icao, latitude, longitude, name, note, reporting, runways, state, type, website, wiki
    }
}

// MARK: - Runway
struct Runway: Codable {
    let lengthFt, widthFt: Int?
    let ident1, ident2: String?
    
    enum CodingKeys: String, CodingKey {
        case lengthFt
        case widthFt
        case ident1, ident2
    }
}
