//
//  Journal+CoreDataProperties.swift
//  whatsnext
//
//  Created by Nguyen Linh Chi on 10/6/2022.
//
//

import Foundation
import CoreData


extension Journal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Journal> {
        return NSFetchRequest<Journal>(entityName: "Journal")
    }

    @NSManaged public var day: Date
    @NSManaged public var diary: String

}

extension Journal : Identifiable {

}
