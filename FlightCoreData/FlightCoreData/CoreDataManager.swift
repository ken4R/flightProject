//
//  CoreDataManager.swift
//  FlightCoreData
//
//  Created by Ken 4B on 21/07/2020.
//  Copyright © 2020 Ken 4B. All rights reserved.
//

import Foundation
import CoreData


class CoreDataManager: NSObject {
    
    /// SharedInstance Methode For The Singleton
    static let sharedInstance = CoreDataManager()
    
    /// applicationDocumentsDirectory
    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.appcoda.CoreDataDemo" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count - 1]
    }()
    
    
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "FlightCoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    
    /// save Context
    func saveContext() {
        let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension CoreDataManager {
    
    func insertStationData(station: AirPortModel) {
        let viewContext = CoreDataManager.sharedInstance.persistentContainer.viewContext
        let object: Airport = NSEntityDescription.insertNewObject(forEntityName: "Airport", into: viewContext) as! Airport
        object.setValue(station.city, forKey: "city")
        object.setValue(station.country, forKey: "country")
        object.setValue(station.elevationFt, forKey: "elevationFt")
        object.setValue(station.elevationM, forKey: "elevationM")
        object.setValue(station.iata, forKey: "iata")
        object.setValue(station.icao, forKey: "icao")
        object.setValue(station.latitude, forKey: "latitude")
        object.setValue(station.longitude, forKey: "longitude")
        object.setValue(station.name, forKey: "name")
        object.setValue(station.note, forKey: "note")
        object.setValue(station.state, forKey: "state")
        object.setValue(station.type, forKey: "type")
        object.setValue(station.website, forKey: "website")
        object.setValue(station.reporting, forKey: "reporting")
        if let runwayStation = station.runways {
            for runway in runwayStation {
                insertNewRunway(runway: runway, station: object)
            }
        }
        do {
            try viewContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    
    func insertNewRunway(runway: RunwayModel, station: Airport) {
        let viewContext = CoreDataManager.sharedInstance.persistentContainer.viewContext
        let object: Runway = NSEntityDescription.insertNewObject(forEntityName: "Runway", into: viewContext) as! Runway
        object.setValue(runway.lengthFt, forKey: "lengthFt")
        object.setValue(runway.widthFt, forKey: "widthFt")
        object.setValue(runway.ident1, forKey: "ident1")
        object.setValue(runway.ident2, forKey: "ident2")
        station.addToRunways(object)
        do {
            try viewContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    
    func checkIfItemExist(item: AirPortModel) -> Bool {
        let managedContext = CoreDataManager.sharedInstance.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Airport")
        fetchRequest.fetchLimit =  1
        if let name = item.name {
            fetchRequest.predicate = NSPredicate(format: "name == %@" , name)
            do {
                let count = try managedContext.count(for: fetchRequest)
                if count > 0 {
                    return true
                }else {
                    return false
                }
            }catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
                return false
            }
        }
        return false
        
    }
    
    func fetchAllStations() -> [Airport] {
        let viewContext = CoreDataManager.sharedInstance.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Airport")
        do {
            let requestResult = try viewContext.fetch(request) as? [Airport]
            return requestResult ?? []
        } catch {
            print("Failed to fetch contents: \(error)")
        }
        return []
    }
    
    func insertNewLog(log: Double, date: Date) {
        let viewContext = CoreDataManager.sharedInstance.persistentContainer.viewContext
        let object: FlightLog = NSEntityDescription.insertNewObject(forEntityName: "FlightLog", into: viewContext) as! FlightLog
        object.setValue(log, forKey: "flightTimeAmount")
        object.setValue(date, forKey: "createdAt")
        object.setValue(UUID(), forKey: "id")
            
        do {
            try viewContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    
    
    func fetchAllLogs() -> [FlightLog] {
        let viewContext = CoreDataManager.sharedInstance.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FlightLog")
        do {
            let requestResult = try viewContext.fetch(request) as? [FlightLog]
            return requestResult ?? []
        } catch {
            print("Failed to fetch contents: \(error)")
        }
        return []
    }

}
