//
//  HighViewController.swift
//  Swift Lingo
//
//  Created by Simon Elander on 2025-03-24.
//

import UIKit

class HighViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let shared = HighScoreManager.shared.saveUserHighScore(score: 100)
        print("Spelare \(shared.name) fick \(shared.score)")
    }
}
