//
//  MainViewDelegte.swift
//  ProfileApp
//
//  Created by Дмитрий on 21.02.2025.
//

import UIKit

protocol MainViewDelegate: AnyObject {
    
    func addChildButtonTapped(sender: UIButton)
    func deleteChildButtonTapped(sender: UIButton)
    func deleteAllChildButtonTapped(sender: UIButton)
}
