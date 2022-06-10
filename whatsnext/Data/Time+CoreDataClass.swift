//
//  Time+CoreDataClass.swift
//  whatsnext
//
//  Created by Nguyen Linh Chi on 10/6/2022.
//
//

import Foundation
import CoreData

@objc(Time)
public class Time: NSManagedObject {
    
    
    func getTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        
        var time: String
        
        switch self.type {
        case "-":
            time = "-"
        case "exact":
            time = dateToString(date: exact!)
        case "start-end":
            let start = dateToString(date: start!)
            let end = dateToString(date: end!)
            time = "\(start) - \(end)"
        case "duration":
            time = duration!
        default:
            time = "-"
        }
        return time
    }
    
    func dateToString(date: Date) -> String {
        let timeFormatter = DateFormatter()
        timeFormatter.locale = Locale(identifier: "en_US")
        timeFormatter.dateFormat = "h:mm a"
        return timeFormatter.string(from: date)
    }

}
