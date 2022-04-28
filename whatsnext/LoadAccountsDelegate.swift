//
//  LoadAccountsDelegate.swift
//  whatsnext
//
//  Created by Nguyen Linh Chi on 28/4/2022.
//

import Foundation

protocol LoadAccountsDelegate: AnyObject {
    
    func loadAccounts (_ accounts: [Account]) -> Bool

}
