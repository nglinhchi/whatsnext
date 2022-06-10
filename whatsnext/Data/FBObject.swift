//
//  Thing.swift
//  whatsnext
//
//  Created by Nguyen Linh Chi on 11/6/2022.
//

import Foundation
import FirebaseFirestoreSwift

class FBThing: NSObject, Encodable, Decodable {
    @DocumentID var id: String?
    var category: String?
    var completed: Bool?
    var date: String?
    var name: String?
    var note: String?
    var userID: String?
}

class FBTime: NSObject, Encodable, Decodable {
    @DocumentID var id: String?
    var duaration: String?
    var end: String?
    var exact: String?
    var start: String?
    var type: String?
    var thingID: String?
}

class FBSubClass: NSObject, Encodable, Decodable {
    @DocumentID var id: String?
    var completed: Bool?
    var name: String?
    var thingID: String?
}

class FBRandom: NSObject, Encodable, Decodable {
    @DocumentID var id: String?
    var name: String?
    var completed: Bool?
    var userID: String?
}

class FBJournal: NSObject, Encodable, Decodable {
    @DocumentID var id: String?
    var date: String?
    var diary: String?
    var userID: String?
}

class FBUser: NSObject, Encodable, Decodable {
    @DocumentID var id: String?
    var userID: String?
    var firstName: String?
    var lastName: String?
}
