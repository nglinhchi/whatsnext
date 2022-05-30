//
//  Account.swift
//  whatsnext
//
//  Created by Nguyen Linh Chi on 27/4/2022.
//

import UIKit
import FirebaseFirestoreSwift

class Account: NSObject, Encodable, Decodable {
    
    @DocumentID var id: String?
    var username: String
    var password: String?
    var firstname: String?
    var lastname: String?
    
    
    init(username: String, password: String, firstname: String, lastname: String) {
        self.username = username
        self.password = password
        self.firstname = firstname
        self.lastname = lastname
    }
    
}
