//
//  UIViewController+displayMessage.swift
//  whatsnext
//
//  Created by Nguyen Linh Chi on 28/4/2022.
//

import UIKit
 
extension UIViewController {
    func displayMessage(title: String, message: String) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
    }
}
