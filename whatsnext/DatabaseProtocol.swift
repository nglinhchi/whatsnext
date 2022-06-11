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
    case random
    case all
    case journal
    case thing
    case time
    case subclass
}

protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType {get set}
    func onRandomChange(change: DatabaseChange, randoms: [FBRandom])
    func onJournalChange(change: DatabaseChange, journals: [FBJournal])
    func onThingChange(change: DatabaseChange, things: [FBThing])
    func onTimeChange(change: DatabaseChange, times: [FBTime])
    func onSubClassChange(change: DatabaseChange, subClasses: [FBSubClass])
//    func onAccountChange (change: DatabaseChange, accounts: [Account])
}

protocol DatabaseProtocol: AnyObject {
    func cleanup()
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
//    func addAccount(username: String, password: String, firstname: String, lastname: String) -> Account
}
protocol FirebaseProtocol: AnyObject{
    
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)

    func getAllRandom()
    func addRandom(name: String, completed: Bool) -> FBRandom
    func deleteRandom(id: String)
    func editRandom(id: String, completed: Bool, name: String)
    
    func addJournal(date: String, diary: String) -> FBJournal
    func deleteJournal(journal: FBJournal)
    
    func getAllThing() -> [FBThing]
    func addThing(category: String, completed: Bool, date: String, name: String, note: String) -> FBThing
    func deleteThing(thing: FBThing)
    
    func addTime(duaration: String, end: String, exact: String, start: String, type: String, thingID: String) -> FBTime
 
    func addSubClass(completed: Bool, name: String, thingID: String) -> FBSubClass
    func deleteSubClass(subClass: FBSubClass)
    
}
