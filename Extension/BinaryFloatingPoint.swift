//
//  BinaryFloatingPoint.swift
//  ProfileApp
//
//  Created by Дмитрий on 24.02.2025.
//

import UIKit

extension BinaryFloatingPoint {
    
    var fit: Self {
        return (self / 393) * Self(UIScreen.main.bounds.width)
    }
}
