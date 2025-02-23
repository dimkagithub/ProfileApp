//
//  UITextField.swift
//  ProfileApp
//
//  Created by Дмитрий on 21.02.2025.
//

import UIKit

class CustomTextField: UITextField {
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        
        return false
    }
    
    override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        
        let originalRect = super.clearButtonRect(forBounds: bounds)
        return originalRect.offsetBy(dx: -10.0.fit, dy: .zero)
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        
        let bounds = super.textRect(forBounds: bounds)
        return bounds.inset(by: UIEdgeInsets(top: .zero, left: 20.0.fit, bottom: .zero, right: 20.0.fit))
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        
        let bounds = super.editingRect(forBounds: bounds)
        return bounds.inset(by: UIEdgeInsets(top: .zero, left: 20.0.fit, bottom: .zero, right: 20.0.fit))
    }
}
