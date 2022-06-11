//
//  TabRandomViewController.swift
//  whatsnext
//
//  Created by Nguyen Linh Chi on 25/5/2022.
//

import UIKit
import CoreData
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestoreSwift

class TabRandomViewController: UIViewController, UITextFieldDelegate {
    
    // VARIABLES -------------------------------------------------------------------------------------
    static var randoms = [Random]()
    var userRandom = [FBRandom()]
    
    // UTILS -----------------------------------------------------------------------------------------
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    weak var databaseController: FirebaseProtocol?
    var listenerType: ListenerType = .random
    static var firebase: [FBRandom] = []
    
    // UI ELEMENTS -----------------------------------------------------------------------------------
    @IBOutlet weak var tableView: UITableView!
    
    // GENERAL METHODS -------------------------------------------------------------------------------
    
    
    func loadEverything() {
        userRandom = []
         for random in LogInViewController.firebaseRandom{
            if( Auth.auth().currentUser?.uid == random.userID){
                userRandom.append(random)
            }
        }
        fetchRandom()
        if TabRandomViewController.randoms.isEmpty{
            for each in userRandom {
                let id = each.id
                let name = each.name
                let completed = each.completed
                let coreRandom = Random(context: context)
                coreRandom.id = id
                coreRandom.name = name!
                coreRandom.completed = completed!
            }
            do { try context.save() }
            catch { print(error) }
            fetchRandom()
        }
    }
    
    // VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseController = appDelegate?.databaseFirebase
        tableView.delegate = self
        tableView.dataSource = self
        loadEverything()
//        firebaseToCoredata()
//        fetchRandom()
    }

    // FIREBASE ---------------------------------------------------------------------------------------
    
//    func firebaseToCoredata() {
//
//
//        let firebaseList = TabRandomViewController.firebase
////        let firebaseList = (databaseController?.getAllRandom())!
//        for each in firebaseList {
//            let id = each.id
//            let name = each.name
//            let completed = each.completed
////            print("\(id) || \(name) || \(completed)")
//
//            let coreRandom = Random(context: context)
//            coreRandom.id = id
//            coreRandom.name = name!
//            coreRandom.completed = completed!
//        }
//        do { try context.save() }
//        catch { print(error) }
//    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        databaseController?.removeListener(listener: self)
    }
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
//        databaseController?.addListener(listener: self)
        TabRandomViewController.firebase = []
        
        
    }
    
    // CRUD - RANDOM ----------------------------------------------------------------------------------
    
    // FETCH RANDOMS INTO VIEW
    func fetchRandom() {
        do {
            TabRandomViewController.randoms = try context.fetch(Random.fetchRequest())
            TabRandomViewController.randoms.sort(by: { $0.completed && !$1.completed })
            for each in TabRandomViewController.randoms {
//                print("ID \(each.id ?? "no-id") | name \(each.name)")
            }
            self.tableView.reloadData()
        }
        catch { print(error) }
    }
    
    // CREATE RANDOM
    @IBAction func addBTN(_ sender: Any) {
        if TabRandomViewController.randoms.count == 0 || !(TabRandomViewController.randoms[TabRandomViewController.randoms.count-1].name == "") {
            
            // create new random
            let random = Random(context: self.context)
            random.name = ""
            random.completed = false
            // save the data
            do {
                try self.context.save()
            }
            catch {
                print(error)
            }
            // reload data
            self.fetchRandom()
            
            // move cursor to next text field
            let row = TabRandomViewController.randoms.count-1
            let cell: RandomTableViewCell
            let indexPath = IndexPath(row: row, section: 0)
            tableView.scrollToRow(at: indexPath, at: .none, animated: true)
            cell = tableView.cellForRow(at: indexPath) as! RandomTableViewCell
            cell.nameTF.becomeFirstResponder()
        }
    }
}


// *********************************************************************************************************


extension TabRandomViewController: UITableViewDelegate {
    
    // DO NOTHING
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // DELETE RANDOM
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            let random = TabRandomViewController.randoms[indexPath.row]
            self.databaseController?.deleteRandom(id: random.id!)
            self.context.delete(random)
            do {
                try self.context.save()
            }
            catch {
                print(error)
            }
            
            self.fetchRandom()
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    
}



extension TabRandomViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TabRandomViewController.randoms.count
    }
    
    // DISPLAY RANDOMS
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RandomTableViewCell
        
        // name
        cell.nameTF?.text = TabRandomViewController.randoms[indexPath.row].name
        cell.nameTF.borderStyle = .none
        
        // complete
        cell.nameTF.tag = indexPath.row
        cell.checkView.tag = indexPath.row
        TabRandomViewController.randoms[indexPath.row].completed ?
        cell.checkView.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal) :
        cell.checkView.setImage(UIImage(systemName: "circle"), for: .normal)
        
        cell.nameTF.delegate = self
        
        return cell
    }
    
    // AUTO-ADD FEATURE
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        if let name = textField.text, name.isEmpty {
            // which row to remove
            let randomToRemove = TabRandomViewController.randoms[textField.tag]
            // remove it
            if let id = randomToRemove.id {
                databaseController?.deleteRandom(id: id) // firebase
            }
            self.context.delete(randomToRemove)
            // save it
            do {
                try self.context.save()
            }
            catch {
                print(error)
            }
            // re-fetch
            self.fetchRandom()
        } else {
                let existing = TabRandomViewController.randoms[textField.tag]
            if let id = existing.id {
                databaseController?.editRandom(id: id, completed: existing.completed, name: textField.text!) // update name
            } else {
                TabRandomViewController.randoms[textField.tag].id = databaseController?.addRandom(name: textField.text!, completed: false).id // add to firebase
            }
            // add to coredata
            addBTN(self)
        }
        return false
    }
    
}

// *********************************************************************************************************


class RandomTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    
    
    @IBOutlet weak var checkView: UIButton!
    @IBOutlet weak var nameTF: UITextField!
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    weak var databaseController: FirebaseProtocol?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // TOGGLE RANDOM.COMPLETED
    @IBAction func checkBTN(_ sender: Any) {
        if let button = sender as? UIButton {
            // toggle completed
            databaseController = appDelegate?.databaseFirebase
            let random = TabRandomViewController.randoms[button.tag]
            databaseController?.editRandom(id: random.id!, completed: !random.completed, name: random.name)
            TabRandomViewController.randoms[button.tag].completed = !TabRandomViewController.randoms[button.tag].completed
            fetchRandom()
            
            // change tick view acccordingly
            TabRandomViewController.randoms[button.tag].completed ?
            checkView.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal) :
            checkView.setImage(UIImage(systemName: "circle"), for: .normal)
        }
    }
    
    func fetchRandom() {
        do {
            try self.context.save()
//            TabRandomViewController.models = try context.fetch(Random.fetchRequest())
        }
        catch {
            print(error)
        }
    }
    
    @IBAction func nameBTN(_ sender: UITextField) {
        TabRandomViewController.randoms[sender.tag].name = nameTF.text!
        fetchRandom()
    }
    
}
