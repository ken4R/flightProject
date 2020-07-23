//
//  FlightLog+CoreDataProperties.swift
//  FlightCoreData
//
//  Created by Braham Youssef on 7/23/20.
//  Copyright © 2020 Ken 4B. All rights reserved.
//
//

import Foundation
import CoreData


extension FlightLog {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FlightLog> {
        return NSFetchRequest<FlightLog>(entityName: "FlightLog")
    }

    @NSManaged public var flightTimeAmount: Double
    @NSManaged public var id: UUID?
    @NSManaged public var createdAt: Date?

}
