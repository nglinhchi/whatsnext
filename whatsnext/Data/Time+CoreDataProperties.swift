//
//  Time+CoreDataProperties.swift
//  whatsnext
//
//  Created by Nguyen Linh Chi on 11/6/2022.
//
//

import Foundation
import CoreData


extension Time {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Time> {
        return NSFetchRequest<Time>(entityName: "Time")
    }

    @NSManaged public var duration: String?
    @NSManaged public var end: Date?
    @NSManaged public var exact: Date?
    @NSManaged public var start: Date?
    @NSManaged public var type: String
    @NSManaged public var id: String?
    @NSManaged public var thing: Thing?

}

extension Time : Identifiable {

}
