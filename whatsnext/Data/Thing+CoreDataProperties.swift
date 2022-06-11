//
//  Thing+CoreDataProperties.swift
//  whatsnext
//
//  Created by Nguyen Linh Chi on 10/6/2022.
//
//

import Foundation
import CoreData


extension Thing {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Thing> {
        return NSFetchRequest<Thing>(entityName: "Thing")
    }

    @NSManaged public var id: String?
    @NSManaged public var category: String
    @NSManaged public var completed: Bool
    @NSManaged public var day: Date
    @NSManaged public var name: String
    @NSManaged public var notes: String
    @NSManaged public var time: Time

}

extension Thing : Identifiable {

}
