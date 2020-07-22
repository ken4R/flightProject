//
//  Runway+CoreDataProperties.swift
//  FlightCoreData
//
//  Created by Braham Youssef on 7/22/20.
//  Copyright © 2020 Ken 4B. All rights reserved.
//
//

import Foundation
import CoreData


extension Runway {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Runway> {
        return NSFetchRequest<Runway>(entityName: "Runway")
    }

    @NSManaged public var lengthFt: Double
    @NSManaged public var widthFt: Double
    @NSManaged public var ident1: String?
    @NSManaged public var ident2: String?

}
