//
//  Location+CoreDataProperties.swift
//  
//
//  Created by Fırat GÜLEÇ on 7.10.2021.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var locCordinate: String?
    @NSManaged public var locCreateDate: Date?
    @NSManaged public var locImageName: String?
    @NSManaged public var locName: String?
    @NSManaged public var locNote: String?

}
