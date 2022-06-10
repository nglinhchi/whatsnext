//
//  FirebaseController.swift
//  whatsnext
//
//  Created by Nguyen Linh Chi on 11/6/2022.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseFirestore
import AVFoundation

class FirebaseController: NSObject, FirebaseProtocol {
    
    var listeners = MulticastDelegate<DatabaseListener>()
    var authController: Auth
    var database: Firestore
    var currentUser: FirebaseAuth.User?
    var randoms: [FBRandom]
    var randomRef: CollectionReference?
    var journals: [FBJournal]
    var journalRef: CollectionReference?
    var things: [FBThing]
    var thingRef: CollectionReference?
    var subClasses: [FBSubClass]
    var subClassRef: CollectionReference?
    var times: [FBTime]
    var timeRef: CollectionReference?
    
    override init() {
        FirebaseApp.configure()
        authController = Auth.auth()
        database = Firestore.firestore()
        randoms = [FBRandom]()
        journals = [FBJournal]()
        things = [FBThing]()
        subClasses = [FBSubClass]()
        times = [FBTime]()
        super.init()
        
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
        print(userID)
        
        self.setupRandomListener()
        self.setupJournalListener()
        self.setUpSubClassListener()
        self.setUpTimeListener()
        self.setupThingListener()
    }
    
    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)
        if listener.listenerType == .random || listener.listenerType == .all {
            listener.onRandomChange(change: .update, randoms: randoms)
        }
        if listener.listenerType == .journal || listener.listenerType == .all {
            listener.onJournalChange(change: .update, journals: journals)
        }
        if listener.listenerType == .thing || listener.listenerType == .all {
            listener.onThingChange(change: .update, things: things)
        }
        if listener.listenerType == .subclass || listener.listenerType == .all {
            listener.onSubClassChange(change: .update, subClasses: subClasses)
        }
        if listener.listenerType == .time || listener.listenerType == .all {
            listener.onTimeChange(change: .update, times: times)
        }
    }
    
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }
    
    
    // Random Firebase set up ----------------------------------------------------------------------------------
    func setupRandomListener() {
        randomRef = database.collection("random")
        randomRef?.addSnapshotListener() {
            (querySnapshot, error) in
            guard let querySnapshot = querySnapshot else {
                print("Failed to fetch documents with error: \(String(describing: error))")
                return
            }
            self.parseRandomSnapshot(snapshot: querySnapshot)
        }
    }
    
    func parseRandomSnapshot(snapshot: QuerySnapshot) {
        snapshot.documentChanges.forEach { (change) in
            var parseRandom: FBRandom?
            do {
                parseRandom = try change.document.data(as: FBRandom.self)
            }
            catch {
                print("Unable to decode random")
                return
            }
            
            guard let random = parseRandom else {
                print("Document doesn't exist")
                return
            }
            
            if change.type == .added {
                randoms.insert(random, at: Int(change.newIndex))
            } else if change.type == .modified {
                randoms[Int(change.oldIndex)] = random
            } else if change.type == .removed {
                randoms.remove(at: Int(change.oldIndex))
            }
            
            listeners.invoke { (listener) in
                if listener.listenerType == ListenerType.random || listener.listenerType == ListenerType.all {
                    listener.onRandomChange(change: .update, randoms: randoms)
                }
            }
        }
    }
    
    func addRandom(name: String, completed: Bool) -> FBRandom {
        let random = FBRandom()
        random.name = name
        random.completed = completed
        random.userID = Auth.auth().currentUser?.uid
        print(Auth.auth().currentUser?.uid)
        let randomDictionary = [
            "name": random.name,
            "completed": random.completed,
            "userID": random.userID
        ] as [String : Any]
        
        print(randomRef)
        do  {
            if let randomRef = try randomRef?.addDocument(data: randomDictionary){
                random.id = randomRef.documentID
            }
        }catch{
            print("cannot serialize random")
        }
        return random
    }
    func deleteRandom(random: FBRandom) {
        if let randomID = random.id{
            randomRef?.document(randomID).delete()
        }
    }
    
    
    // Journal Firebase set up ----------------------------------------------------------------------------------
    
    func setupJournalListener() {
        journalRef = database.collection("journal")
        journalRef?.addSnapshotListener() {
            (querySnapshot, error) in
            guard let querySnapshot = querySnapshot else {
                print("Failed to fetch documents with error: \(String(describing: error))")
                return
            }
            self.parseJournalSnapshot(snapshot: querySnapshot)
        }
    }
    
    func parseJournalSnapshot(snapshot: QuerySnapshot) {
        snapshot.documentChanges.forEach { (change) in
            var parseJournal: FBJournal?
            do {
                parseJournal = try change.document.data(as: FBJournal.self)
            }
            catch {
                print("Unable to decode journal")
                return
            }
            
            guard let journal = parseJournal else {
                print("Document doesn't exist")
                return
            }
            
            if change.type == .added {
                journals.insert(journal, at: Int(change.newIndex))
            } else if change.type == .modified {
                journals[Int(change.oldIndex)] = journal
            } else if change.type == .removed {
                journals.remove(at: Int(change.oldIndex))
            }
            
            listeners.invoke { (listener) in
                if listener.listenerType == ListenerType.journal || listener.listenerType == ListenerType.all {
                    listener.onJournalChange(change: .update, journals: journals)
                }
            }
        }
    }
    
    func addJournal(date: String, diary: String) -> FBJournal {
        let journal = FBJournal()
        journal.date = date
        journal.diary = diary
        journal.userID = Auth.auth().currentUser?.uid
        print(Auth.auth().currentUser?.uid)
        let journalDictionary = [
            "date": journal.date,
            "diary": journal.diary,
            "userID": journal.userID
        ] as [String : Any]
        
        do  {
            if let journalRef = try journalRef?.addDocument(data: journalDictionary){
                journal.id = journalRef.documentID
            }
        }catch{
            print("cannot serialize random")
        }
        return journal
    }
    
    func deleteJournal(journal: FBJournal) {
        if let journalID = journal.id{
            journalRef?.document(journalID).delete()
        }
    }
    
    
    // Thing Firebase set up ----------------------------------------------------------------------------------
    func setupThingListener() {
        thingRef = database.collection("thing")
        thingRef?.addSnapshotListener() {
            (querySnapshot, error) in
            guard let querySnapshot = querySnapshot else {
                print("Failed to fetch documents with error: \(String(describing: error))")
                return
            }
            self.parseThingSnapshot(snapshot: querySnapshot)
        }
    }
    
    func parseThingSnapshot(snapshot: QuerySnapshot) {
        snapshot.documentChanges.forEach { (change) in
            var parseThing: FBThing?
            do {
                parseThing = try change.document.data(as: FBThing.self)
            }
            catch {
                print("Unable to decode journal")
                return
            }
            
            guard let thing = parseThing else {
                print("Document doesn't exist")
                return
            }
            
            if change.type == .added {
                things.insert(thing, at: Int(change.newIndex))
            } else if change.type == .modified {
                things[Int(change.oldIndex)] = thing
            } else if change.type == .removed {
                things.remove(at: Int(change.oldIndex))
            }
            
            listeners.invoke { (listener) in
                if listener.listenerType == ListenerType.thing || listener.listenerType == ListenerType.all {
                    listener.onThingChange(change: .update, things: things)
                }
            }
        }
    }
    
    func addThing(category: String, completed: Bool, date: String, name: String, note: String) -> FBThing {
        let thing = FBThing()
        thing.category = category
        thing.completed = completed
        thing.date = date
        thing.name = name
        thing.note = note
        thing.userID = Auth.auth().currentUser?.uid
        print(Auth.auth().currentUser?.uid)
        let thingDictionary = [
            "category": thing.category,
            "completed": thing.completed,
            "date": thing.date,
            "note": thing.note,
            "name": thing.name,
            "userID": thing.userID
        ] as [String : Any]
        
        do  {
            if let thingRef = try thingRef?.addDocument(data: thingDictionary){
                thing.id = thingRef.documentID
            }
        }catch{
            print("cannot serialize random")
        }
        return thing
    }
    
    func deleteThing(thing: FBThing) {
        if let thingID = thing.id{
            thingRef?.document(thingID).delete()
        }
    }
    

    // subClass Firebase set up ----------------------------------------------------------------------------------
    func setUpSubClassListener() {
        subClassRef = database.collection("subClass")
        subClassRef?.addSnapshotListener() {
            (querySnapshot, error) in
            guard let querySnapshot = querySnapshot else {
                print("Failed to fetch documents with error: \(String(describing: error))")
                return
            }
            self.parseSubClassSnapshot(snapshot: querySnapshot)
        }
    }
    
    
    func parseSubClassSnapshot(snapshot: QuerySnapshot) {
        snapshot.documentChanges.forEach { (change) in
            var parseSubClass: FBSubClass?
            do {
                parseSubClass = try change.document.data(as: FBSubClass.self)
            }
            catch {
                print("Unable to decode subClass")
                return
            }
            
            guard let subClass = parseSubClass else {
                print("Document doesn't exist")
                return
            }
            
            if change.type == .added {
                subClasses.insert(subClass, at: Int(change.newIndex))
            } else if change.type == .modified {
                subClasses[Int(change.oldIndex)] = subClass
            } else if change.type == .removed {
                subClasses.remove(at: Int(change.oldIndex))
            }
            
            listeners.invoke { (listener) in
                if listener.listenerType == ListenerType.subclass || listener.listenerType == ListenerType.all {
                    listener.onSubClassChange(change: .update, subClasses: subClasses)
                }
            }
        }
    }
    
    func addSubClass(completed: Bool, name: String, thingID: String) -> FBSubClass {
        let subClass = FBSubClass()
        subClass.thingID = thingID
        subClass.completed = completed
        subClass.name = name
        let subClassDictionary = [
            "completed": subClass.completed,
            "name": subClass.name,
            "thingID": subClass.thingID
        ] as [String : Any]
        
        do  {
            if let subClassRef = try subClassRef?.addDocument(data: subClassDictionary){
                subClass.id = subClassRef.documentID
            }
        }catch{
            print("cannot serialize random")
        }
        return subClass
    }
    
    func deleteSubClass(subClass: FBSubClass) {
        if let subClassID = subClass.id{
            subClassRef?.document(subClassID).delete()
        }
    }
        
    // Time firebase set up ----------------------------------------------------------------------------------
    func setUpTimeListener() {
        timeRef = database.collection("time")
        timeRef?.addSnapshotListener() {
            (querySnapshot, error) in
            guard let querySnapshot = querySnapshot else {
                print("Failed to fetch documents with error: \(String(describing: error))")
                return
            }
            self.parseTimeSnapshot(snapshot: querySnapshot)
        }
    }
    
    func parseTimeSnapshot(snapshot: QuerySnapshot) {
        snapshot.documentChanges.forEach { (change) in
            var parseTime: FBTime?
            do {
                parseTime = try change.document.data(as: FBTime.self)
            }
            catch {
                print("Unable to decode time")
                return
            }
            
            guard let time = parseTime else {
                print("Document doesn't exist")
                return
            }
            
            if change.type == .added {
                times.insert(time, at: Int(change.newIndex))
            } else if change.type == .modified {
                times[Int(change.oldIndex)] = time
            } else if change.type == .removed {
                times.remove(at: Int(change.oldIndex))
            }
            
            listeners.invoke { (listener) in
                if listener.listenerType == ListenerType.time || listener.listenerType == ListenerType.all {
                    listener.onTimeChange(change: .update, times: times)
                }
            }
        }
    }
    
    func addTime(duaration: String, end: String, exact: String, start: String, type: String, thingID: String) -> FBTime {
        let time = FBTime()
        time.thingID = thingID
        time.type = type
        time.duaration = duaration
        time.exact = exact
        time.end = end
        time.start = start
        let timeDictionary = [
            "start": time.start,
            "end": time.end,
            "exact": time.exact,
            "duaration": time.duaration,
            "type": time.type,
            "thingID": time.thingID
        ] as [String : Any]
        
        do  {
            if let timeRef = try timeRef?.addDocument(data: timeDictionary){
                time.id = timeRef.documentID
            }
        }catch{
            print("cannot serialize random")
        }
        return time
    }
    
}
