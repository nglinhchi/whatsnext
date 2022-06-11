//
//  Journal+CoreDataClass.swift
//  whatsnext
//
//  Created by Nguyen Linh Chi on 11/6/2022.
//
//

import Foundation
import CoreData

@objc(Journal)
public class Journal: NSManagedObject {

    
    func stringToDate(string: String) -> Date{
        let fullFormatter = DateFormatter()
        fullFormatter.locale = Locale(identifier: "en_US")
        fullFormatter.dateFormat = "dd/MM/yyyy"
        return fullFormatter.date(from: string)!
    }
    
}
