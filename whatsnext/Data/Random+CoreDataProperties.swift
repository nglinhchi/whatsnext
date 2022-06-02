//
//  Random+CoreDataProperties.swift
//  whatsnext
//
//  Created by Nguyen Linh Chi on 2/6/2022.
//
//

import Foundation
import CoreData


extension Random {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Random> {
        return NSFetchRequest<Random>(entityName: "Random")
    }

    @NSManaged public var name: String?
    @NSManaged public var completed: Bool

}

extension Random : Identifiable {

}
