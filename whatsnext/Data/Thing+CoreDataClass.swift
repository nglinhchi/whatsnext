//
//  Thing+CoreDataClass.swift
//  whatsnext
//
//  Created by Nguyen Linh Chi on 10/6/2022.
//
//

import Foundation
import CoreData

@objc(Thing)
public class Thing: NSManagedObject {
    
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: date)
    }

}
