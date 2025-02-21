//
//  UIView.swift
//  ProfileApp
//
//  Created by Дмитрий on 21.02.2025.
//

import UIKit

extension UIView {
    
    func pulsate(from: Float, to: Float, speed: Float, reverse: Bool, completion: @escaping() -> Void) {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.fromValue = from
        pulse.toValue = to
        pulse.speed = speed
        pulse.autoreverses = reverse
        layer.add(pulse, forKey: nil)
        isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(Int(Float(speed * 100)))) {
            self.isUserInteractionEnabled = true
            completion()
        }
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}
