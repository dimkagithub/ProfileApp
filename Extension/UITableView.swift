//
//  UITableView.swift
//  ProfileApp
//
//  Created by Дмитрий on 21.02.2025.
//

import UIKit

extension UITableView {
    
    func register<T: UITableViewCell>(cell: T.Type) {
        register(T.self, forCellReuseIdentifier: T.identifier)
    }
    
    func dequeueCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as! T
    }
}
