//
//  FIrebaseController.swift
//  whatsnext
//
//  Created by Nguyen Linh Chi on 28/4/2022.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift
import FirebaseAuth

class FirebaseController: NSObject, DatabaseProtocol {
    
    
    var listeners = MulticastDelegate<DatabaseListener>()
    var listenerType: ListenerType = .account
    var accounts: [Account]
    var authController: Auth
    var database: Firestore
    var accountRef: CollectionReference?
    var currentUser: FirebaseAuth.User?
    
    
    override init() {
        FirebaseApp.configure()
        authController = Auth.auth()
        database = Firestore.firestore()
        accounts = [Account]()
        super.init()
        Task {
            do {
                let authDataResult = try await authController.signInAnonymously()
                currentUser = authDataResult.user }
            catch {
                fatalError("Firebase Authentication Failed with Error\(String(describing: error))")
            }
            self.setupAccountListener()
       }
    }
    

    
    func setupAccountListener() {
        accountRef = database.collection("accounts")
        accountRef?.addSnapshotListener() {
            (querySnapshot, error) in
            guard let querySnapshot = querySnapshot else {
                print("failed to fetch documents with error: \(String(describing: error))")
                return
            }
            self.parseAccountSnapshot(snapshot: querySnapshot)
        }
    }
    
    
    
    func parseAccountSnapshot(snapshot: QuerySnapshot) {
        snapshot.documentChanges.forEach { (change) in
            var parseUser: Account?
            do {
                parseUser = try change.document.data(as: Account.self)
            }
            catch {
                print("unable to decode here, is the hero malformed?")
                return
            }
            
            guard let user = parseUser else {
                print("Document doesn't exist")
                return
            }
            
            if change.type == .added {
                accounts.insert(user, at: Int(change.newIndex))
            }
            else if change.type == .modified {
                accounts[Int(change.oldIndex)] = user
            }
            else if change.type == .removed {
                accounts.remove(at: Int(change.oldIndex))
            }
            listeners.invoke { (listener) in
                if listener.listenerType == ListenerType.account || listener.listenerType == ListenerType.all {
                    listener.onAccountChange(change: .update, accounts: accounts)
                }
            }
        }
    }
    
    
    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)
        
        if listener.listenerType == .account || listener.listenerType == .all {
            listener.onAccountChange(change: .update, accounts: accounts)
        }
    }
    
    
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }
    
    
    func cleanup() {}
    
    
    func addAccount(username: String, password: String, firstname: String, lastname: String) -> Account {
//        let account = Account()
//        account.username = username
//        account.password = password
//        account.firstname = firstname
//        account.lastname = lastname
//        do {
//            if let accountRef = try accountRef?.addDocument(from: account) {
//                account.id = accountRef.documentID }
//            }
//        catch {
//            print("failed to serialise account")
//        }
//        return account
        return Account(username: username, password: password, firstname: firstname, lastname: lastname)
    }
    
    
}
