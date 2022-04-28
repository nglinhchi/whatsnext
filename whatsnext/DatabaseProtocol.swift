//
//  DatabaseController.swift
//  whatsnext
//
//  Created by Nguyen Linh Chi on 28/4/2022.
//


import Foundation

enum DatabaseChange {
    case add
    case remove
    case update
}

enum ListenerType {
    case account
    case all
}

protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType {get set}
    func onAccountChange (change: DatabaseChange, accounts: [Account])
}

protocol DatabaseProtocol: AnyObject {
    func cleanup()
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
    func addAccount(username: String, password: String) -> Account
}
