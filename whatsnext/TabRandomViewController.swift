//
//  TabRandomViewController.swift
//  whatsnext
//
//  Created by Nguyen Linh Chi on 25/5/2022.
//

import UIKit

class TabRandomViewController: UIViewController, UITextFieldDelegate {
    
    // VARIABLES + CONSTANTS *******************************************
    static var models = [Random]()
    
    
    // UI ELEMENTS *******************************************************
    @IBOutlet weak var table: UITableView!
    
    // METHODS ***********************************************************
    override func viewDidLoad() {
        super.viewDidLoad()
//        TabRandomViewController.models.append(Random(name: "123"))
//        TabRandomViewController.models.append(Random(name: "asd"))
        table.delegate = self
        table.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    
    // BUTTONS **********************************************************
    
    
    @IBAction func addBTN(_ sender: Any) {
        if TabRandomViewController.models.count == 0 || !(TabRandomViewController.models[TabRandomViewController.models.count-1].name == "") {
            TabRandomViewController.models.append(Random(name: ""))
            table.reloadData()
            let row = TabRandomViewController.models.count-1
            let cell: RandomTableViewCell
            let indexPath = IndexPath(row: row, section: 0)
            table.scrollToRow(at: indexPath, at: .none, animated: true)
            cell =  table.cellForRow(at: indexPath) as! RandomTableViewCell
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
        TabRandomViewController.models[indexPath.row].completed ?
        cell.checkView.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal) :
        cell.checkView.setImage(UIImage(systemName: "circle"), for: .normal)
        
        cell.nameTF.delegate = self
        
        return cell
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        
        if let name = textField.text, name.isEmpty {
            TabRandomViewController.models.remove(at: textField.tag)
            table.reloadData()
        } else {
            addBTN(self)
        }
        print(TabRandomViewController.models.count)
        
        for item in TabRandomViewController.models {
            print("item: \(item.name) and completed: \(item.completed)")
        }
        
        return false
    }
    
}

// *********************************************************************************************************


class RandomTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    
    
    @IBOutlet weak var checkView: UIButton!
    @IBOutlet weak var nameTF: UITextField!
    
    @IBAction func checkBTN(_ sender: Any) {
        if let button = sender as? UIButton {
            TabRandomViewController.models[button.tag].completed = !TabRandomViewController.models[button.tag].completed
            TabRandomViewController.models[button.tag].completed ?
            checkView.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal) :
            checkView.setImage(UIImage(systemName: "circle"), for: .normal)
        }
    }
    
    @IBAction func nameBTN(_ sender: UITextField) {
        TabRandomViewController.models[sender.tag].name = nameTF.text!
        print(TabRandomViewController.models[sender.tag].name)
    }

}
