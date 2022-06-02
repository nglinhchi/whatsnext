//
//  Item.swift
//  whatsnext
//
//  Created by Nguyen Linh Chi on 12/5/2022.
//

import Foundation


struct Item {
    var name: String
    var category: String
    var day: Date
    var time: Time
    var notes: String
    var subtasks: [Subtask] // need to add boolean for completed
    var completed: Bool  
}


struct Subtask {
    var name: String
    var completed: Bool
}
