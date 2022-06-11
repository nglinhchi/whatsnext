//
//  Subtask+CoreDataProperties.swift
//  whatsnext
//
//  Created by Nguyen Linh Chi on 11/6/2022.
//
//

import Foundation
import CoreData


extension Subtask {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Subtask> {
        return NSFetchRequest<Subtask>(entityName: "Subtask")
    }

    @NSManaged public var completed: Bool
    @NSManaged public var name: String
    @NSManaged public var thingID: String?
    @NSManaged public var id: String?

}

extension Subtask : Identifiable {

}
