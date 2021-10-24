//
//  Locationdata+CoreDataProperties.swift
//  
//
//  Created by Fırat GÜLEÇ on 7.10.2021.
//
//

import Foundation
import CoreData


extension Locationdata {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Locationdata> {
        return NSFetchRequest<Locationdata>(entityName: "Locationdata")
    }

    @NSManaged public var cLat: Double?
    @NSManaged public var cLon: Double?
    @NSManaged public var createDate: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var imageName: String?
    @NSManaged public var locSub: String?
    @NSManaged public var locName: String?
    @NSManaged public var locNote: String?
    @NSManaged public var favorite: Bool?

}
