//
//  Time.swift
//  whatsnext
//
//  Created by Nguyen Linh Chi on 12/5/2022.
//

import Foundation


class Time {
    
    var type: String = ""
    var exact = Date()
    var interval = DateInterval()
    var duration: String = ""
    
    
    init(type: String) {
        self.type = type
    }
    
    init(type: String, exact: Date) {
        self.type = type
        self.exact = exact
    }
    
    
    init(type: String, interval: DateInterval) {
        self.type = type
        self.interval = interval
    }
    
    
    init(type: String, duration: String) {
        self.type = type
        self.duration = duration
    }
    
    
    // @ convert date to string for display
    func getTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        
        var time: String
        
        switch self.type {
        case "-":
            time = "-"
        case "exact":
            time = "-"
        case "start-end":
            time = "-"
        case "duration":
            time = "-"
        default:
            time = "-"
        }
        return time
    }
    
    
}
