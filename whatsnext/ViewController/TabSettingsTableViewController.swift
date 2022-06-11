//
//  TabSettingsTableViewController.swift
//  whatsnext
//
//  Created by Nguyen Linh Chi on 26/5/2022.
//

import UIKit
import FirebaseAuth

class TabSettingsTableViewController: UITableViewController {

    // VARIABLES -------------------------------------------------------------------------------------
    
    // UTILS -----------------------------------------------------------------------------------------
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // UI ELEMENTS -----------------------------------------------------------------------------------
    @IBOutlet weak var darkmodeCell: UITableViewCell!
    @IBOutlet weak var logoutCell: UITableViewCell!
//    @IBOutlet weak var darkmodeSwitch: UISwitch!
    
    // GENERAL METHODS -------------------------------------------------------------------------------
    
    // VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: self.view.tintColor,
            .font: UIFont(name: "HelveticaNeue-Bold", size: 25)!
        ]
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath) == darkmodeCell {
            tableView.cellForRow(at: indexPath)!.selectionStyle = .none
        }
            tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView.cellForRow(at: indexPath) == logoutCell {
            // TODO log out - log in screen?
            signOut()
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        }
        catch {
            print("Log out error: \(error.localizedDescription)")
        }
        navigationController?.popViewController(animated: true)
        // clear coredata
        clearCoreData()
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "login") as? LogInViewController else {
                return
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func clearCoreData() {
        // time
        do {
            let all = try context.fetch(Time.fetchRequest())
            for each in all {
                context.delete(each)
            }
        }
        catch { print(error) }
        // subtask
        do {
            let all = try context.fetch(Subtask.fetchRequest())
            for each in all {
                context.delete(each)
            }
        }
        catch { print(error) }
        // thing
        do {
            let all = try context.fetch(Thing.fetchRequest())
            for each in all {
                context.delete(each)
            }
        }
        catch { print(error) }
        // random
        do {
            let all = try context.fetch(Random.fetchRequest())
            for each in all {
                context.delete(each)
            }
        }
        catch { print(error) }
        // journal
        do {
            let all = try context.fetch(Journal.fetchRequest())
            for each in all {
                context.delete(each)
            }
        }
        catch { print(error) }
        // save
        do {
            try context.save()
        }
        catch { print(error) }
    }
    
}
