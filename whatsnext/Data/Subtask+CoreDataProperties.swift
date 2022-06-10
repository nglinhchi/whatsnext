//
//  Subtask+CoreDataProperties.swift
//  whatsnext
//
//  Created by Nguyen Linh Chi on 10/6/2022.
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
    @NSManaged public var thingID: UUID

}

extension Subtask : Identifiable {

}
