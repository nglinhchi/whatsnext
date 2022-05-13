//
//  ItemDetailsViewController.swift
//  whatsnext
//
//  Created by Nguyen Linh Chi on 11/5/2022.
//

import UIKit

class ItemDetailsViewController: UIViewController {

    
    
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var categoryTag: UILabel!
    @IBOutlet weak var timeTag: UILabel!
    @IBOutlet weak var subtaskListTableView: UITableView!
    
    
    var item: Item?
    
    public var completion: ((Item) -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        taskNameLabel.text = item?.name
        dateLabel.text = dateFormatter.string(from: item!.day)
        categoryTag.text = item?.category
        timeTag.text = item?.time.getTime()
    }
    
    
    
    @IBAction func discardBTN(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    

}
