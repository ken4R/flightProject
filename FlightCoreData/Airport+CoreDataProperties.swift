//
//  Airport+CoreDataProperties.swift
//  FlightCoreData
//
//  Created by Braham Youssef on 7/23/20.
//  Copyright © 2020 Ken 4B. All rights reserved.
//
//

import Foundation
import CoreData


extension Airport {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Airport> {
        return NSFetchRequest<Airport>(entityName: "Airport")
    }

    @NSManaged public var city: String?
    @NSManaged public var country: String?
    @NSManaged public var elevationFt: String?
    @NSManaged public var elevationM: String?
    @NSManaged public var iata: String?
    @NSManaged public var icao: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String?
    @NSManaged public var note: String?
    @NSManaged public var state: String?
    @NSManaged public var type: String?
    @NSManaged public var website: String?
    @NSManaged public var reporting: Bool
    @NSManaged public var runways: NSSet?

}

// MARK: Generated accessors for runways
extension Airport {

    @objc(addRunwaysObject:)
    @NSManaged public func addToRunways(_ value: Runway)

    @objc(removeRunwaysObject:)
    @NSManaged public func removeFromRunways(_ value: Runway)

    @objc(addRunways:)
    @NSManaged public func addToRunways(_ values: NSSet)

    @objc(removeRunways:)
    @NSManaged public func removeFromRunways(_ values: NSSet)

}
