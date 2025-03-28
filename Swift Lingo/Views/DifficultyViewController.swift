//
//  GameViewController.swift
//  Swift Lingo
//
//  Created by Simon Elander on 2025-03-24.
//

import UIKit

class DifficultyViewController: UIViewController {

  
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var easyButton: UIButton!
    @IBOutlet weak var mediumButton: UIButton!
    @IBOutlet weak var hardButton: UIButton!
    @IBOutlet weak var extremeButton: UIButton!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        ThemeManager.shared.setTheme(view: self.view)
    }

    
    
    
    @IBAction func easyDifficultyButton(_ sender: UIButton) {
        
        UserDefaultsManager.shared.saveDifficulty(choosen: "easy")
        GameManager.shared.setTurnTime(seconds: 6)
        GameManager.shared.setTurnAmount(turns: 2)
        GameManager.shared.loadWords(words: GameManager.shared.fetchWordsEasy())
        navigateToGame()
        
    }
    
    @IBAction func mediumDifficultyButton(_ sender: UIButton) {
        
        UserDefaultsManager.shared.saveDifficulty(choosen: "medium")
        GameManager.shared.setTurnTime(seconds: 8)
        GameManager.shared.setTurnAmount(turns: 10)
        GameManager.shared.loadWords(words: GameManager.shared.fetchWordsMedium())
        navigateToGame()
    }
    
    
    @IBAction func hardDifficultyButton(_ sender: UIButton) {
        
        UserDefaultsManager.shared.saveDifficulty(choosen: "hard")
        GameManager.shared.setTurnTime(seconds: 8)
        GameManager.shared.setTurnAmount(turns: 10)
        GameManager.shared.loadWords(words: GameManager.shared.fetchWordsHard())
        navigateToGame()
    }
    
    
    @IBAction func extremeDifficultyButton(_ sender: UIButton) {
        
        UserDefaultsManager.shared.saveDifficulty(choosen: "extreme")
        GameManager.shared.setTurnTime(seconds: 12)
        GameManager.shared.setTurnAmount(turns: 10)
        GameManager.shared.loadWords(words: GameManager.shared.fetchWordsExtreme())
        navigateToGame()
    }
    
    
    private func navigateToGame() {
        performSegue(withIdentifier: "navigateToGame", sender: self)
    }
}

extension DifficultyViewController {
    
    private func setupUI() {
        
        titleLabel.font = UIFont.systemFont(ofSize: 36, weight: .bold)
       // titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        let buttons = [easyButton, mediumButton, hardButton, extremeButton]
        
        for button in buttons {
            button?.setTitleColor(.white, for: .normal)
            button?.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
            button?.layer.cornerRadius = 10
            button?.layer.shadowColor = UIColor.label.cgColor
            button?.layer.shadowOpacity = 0.15
            button?.layer.shadowOffset = CGSize(width: 0, height: 4)
            button?.layer.shadowRadius = 5
            button?.translatesAutoresizingMaskIntoConstraints = false
       
            NSLayoutConstraint.activate([
                button!.widthAnchor.constraint(equalToConstant: 300),
                button!.heightAnchor.constraint(equalToConstant: 40)
            ])
        }
        
        easyButton.backgroundColor = .systemGreen
        mediumButton.backgroundColor = .orange
        hardButton.backgroundColor = .systemPink
        extremeButton.backgroundColor = .systemRed
        
        titleLabel.text = "Select difficulty"
        easyButton.setTitle("Easy", for: .normal)
        mediumButton.setTitle("Medium", for: .normal)
        hardButton.setTitle("Hard", for: .normal)
        extremeButton.setTitle("Time to meet your maker 💀⚠️", for: .normal)
        //eller regrets have no mercy 💀⚠️
    }
    
    
    
}
