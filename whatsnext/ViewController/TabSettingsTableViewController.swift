//
//  TabSettingsTableViewController.swift
//  whatsnext
//
//  Created by Nguyen Linh Chi on 26/5/2022.
//

import UIKit
import FirebaseAuth

class TabSettingsTableViewController: UITableViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var darkmodeCell: UITableViewCell!
    @IBOutlet weak var logoutCell: UITableViewCell!
    @IBOutlet weak var darkmodeSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
//        Task{
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
//        }
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
//                print(each)
                context.delete(each)
            }
//            print(try context.fetch(Random.fetchRequest()))
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
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

}
