//
//  Alerts.swift
//  Swift Lingo
//
//  Created by Nicholas Samuelsson Jeria on 2025-03-29.
//

import Foundation
import UIKit

extension UIViewController {
    
//    Simple alert with title, message and optional completion
    func showStandardAlert(title: String, message: String, buttonText: String = "OK", completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonText, style: .default, handler: { _ in
            completion?()
        }))
        present(alert, animated: true)
        
    }
    
    //Shows yes/no confirmation dialog
    func showDialogAlert(title: String, message: String, confirmTitle: String = "OK", cancelTitle: String = "Cancel", onConFirm: @escaping () -> Void){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel))
        alert.addAction(UIAlertAction(title: confirmTitle, style: .destructive, handler: { _ in
            onConFirm()
        }))
        present(alert, animated: true)
    }
    
    //Shows an alert for an unlocked badge
    func showUnlockedBadgeAlert(badge: Badges, completion: @escaping () -> Void) {
        let alert = UIAlertController(title: "🎖️ Badge Unlocked", message: badge.rawValue, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion()
        }))
        present(alert, animated: true)
    }
    
    // Shows custom alert with buttonTitle
    func showCustomAlert(title: String, message: String, buttonTitle: String, handler: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default) { _ in
            handler()
        })
        present(alert, animated: true)
    }
    
}
