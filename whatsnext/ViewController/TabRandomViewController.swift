//
//  TabRandomViewController.swift
//  whatsnext
//
//  Created by Nguyen Linh Chi on 25/5/2022.
//

import UIKit
import CoreData

class TabRandomViewController: UIViewController, UITextFieldDelegate {
    
    // VARIABLES + CONSTANTS *******************************************
    static var models = [Random]()
    
    // reference to managed object context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    // UI ELEMENTS *******************************************************
    @IBOutlet weak var table: UITableView!
    
    // METHODS ***********************************************************
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        fetchRandom()
        print(TabRandomViewController.models.count)
        
        
    }
    
    
    
    func fetchRandom() {
        // fetch fata from core data to display in tableview
        do {
            TabRandomViewController.models = try context.fetch(Random.fetchRequest())
            self.table.reloadData()
        }
        catch {
            print(error)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    
    // BUTTONS **********************************************************
    
    
    @IBAction func addBTN(_ sender: Any) {
        if TabRandomViewController.models.count == 0 || !(TabRandomViewController.models[TabRandomViewController.models.count-1].name == "") {
            
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
            let row = TabRandomViewController.models.count-1
            let cell: RandomTableViewCell
            let indexPath = IndexPath(row: row, section: 0)
            table.scrollToRow(at: indexPath, at: .none, animated: true)
            cell = table.cellForRow(at: indexPath) as! RandomTableViewCell
            cell.nameTF.becomeFirstResponder()
        }
    }
}


// *********************************************************************************************************


extension TabRandomViewController: UITableViewDelegate {
    
    // SELECT A TASK --> SEE ITS DETAILS
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // delete action
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            let random = TabRandomViewController.models[indexPath.row]
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
        return TabRandomViewController.models.count
    }
    
    // LOAD DATA INTO THE ROW
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RandomTableViewCell
        
        // name
        cell.nameTF?.text = TabRandomViewController.models[indexPath.row].name
        cell.nameTF.borderStyle = .none
        
        // complete
        cell.nameTF.tag = indexPath.row
        cell.checkView.tag = indexPath.row
        TabRandomViewController.models[indexPath.row].completed ?
        cell.checkView.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal) :
        cell.checkView.setImage(UIImage(systemName: "circle"), for: .normal)
        
        cell.nameTF.delegate = self
        
        return cell
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        if let name = textField.text, name.isEmpty {
            // which row to remove
            let randomToRemove = TabRandomViewController.models[textField.tag]
            // remove it
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
            addBTN(self)
        }
        print(TabRandomViewController.models.count)
        return false
    }
    
}

// *********************************************************************************************************


class RandomTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    
    
    @IBOutlet weak var checkView: UIButton!
    @IBOutlet weak var nameTF: UITextField!
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBAction func checkBTN(_ sender: Any) {
        if let button = sender as? UIButton {
            
            let it = TabRandomViewController.models[button.tag]
            print("name: \(it.name!) completed: \(it.completed)")
            
            TabRandomViewController.models[button.tag].completed = !TabRandomViewController.models[button.tag].completed
            fetchRandom()
            
            TabRandomViewController.models[button.tag].completed ?
            checkView.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal) :
            checkView.setImage(UIImage(systemName: "circle"), for: .normal)
            
            print("name: \(it.name!) completed: \(it.completed)")
            
        }
    }
    
    func fetchRandom() {
        do {
            try self.context.save()
            TabRandomViewController.models = try context.fetch(Random.fetchRequest())
        }
        catch {
            print(error)
        }
    }
    
    @IBAction func nameBTN(_ sender: UITextField) {
        TabRandomViewController.models[sender.tag].name = nameTF.text!
        fetchRandom()
//        print(TabRandomViewController.models[sender.tag].name!)
    }
    
}
