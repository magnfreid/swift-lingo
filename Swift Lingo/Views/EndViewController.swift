//
//  EndViewController.swift
//  Swift Lingo
//
//  Created by Simon Elander on 2025-03-24.
//

import UIKit

class EndViewController: UIViewController {
    @IBOutlet weak var scoreLabel: UILabel!
    
    var score = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scoreLabel.text = String(score)
    }
    

    
    @IBAction func playAgainButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "endToSettingsSegue", sender: nil)
    }
    
    @IBAction func toStartButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "unwindToStartScreen", sender: nil)
    }

}
