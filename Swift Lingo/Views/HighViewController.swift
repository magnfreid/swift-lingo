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






//TODO: Gör om som i settings, inbädda denna i en nav controller, custom knapp etc etc, ändra namn på klassen, gör den till final



//📱 2. Visa badges med TableView
