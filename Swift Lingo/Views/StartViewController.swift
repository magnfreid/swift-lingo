//
//  ViewController.swift
//  Swift Lingo
//
//  Created by Magnus Freidenfelt on 2025-03-24.
//

import UIKit

final class StartViewController: UIViewController {
    
    // @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var highscoreButton: UIButton!
    
    @IBOutlet weak var settingsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addTapGestureToDismissKeyboard()
        ThemeManager.shared.setTheme(view: self.view)
        nameTextField.text = UserDefaultsManager.shared.getPlayerName()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        ThemeManager.shared.setTheme(view: self.view)
    }
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        
        guard let name = nameTextField.text, !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            shake(nameTextField)
            showStandardAlert(title: "You're to fast!", message: "You need to enter a name to play")
            return
        }
        
        let savedName = UserDefaultsManager.shared.getPlayerName()
        let hasBadgesData = BadgeManager.shared.hasBadgeData(for: name)
        let dogNames = ["woof", "hund", "dog"]
        
        if dogNames.contains(where: { $0.caseInsensitiveCompare(name) == .orderedSame}) && !BadgeManager.shared.hasBadge(badges: .woof, for: name) {
            
            UserDefaultsManager.shared.savePlayerName(is: name)
            BadgeManager.shared.addBadge(badge: .woof, for: name)
            
            showCustomAlert(title: "🐶 Woof Woof!", message: "🐕 You sniffed out the secret! \nYou've unlocked a hidden badge!", buttonTitle: "Woof!") {
                self.performSegue(withIdentifier: "navigateToGamePlay", sender: self)
            }
        }
        
        if name == savedName && hasBadgesData {
            performSegue(withIdentifier: "navigateToGamePlay", sender: self)
            return
        }
        UserDefaultsManager.shared.savePlayerName(is: name)
        
        if hasBadgesData {
            showStandardAlert(title: "Welcome Back", message: "Nice to se you again")
        } else {
            performSegue(withIdentifier: "navigateToGamePlay", sender: self)
        }
        
    }
    
    @IBAction func unwindToStartScreen(_ segue: UIStoryboardSegue) {
        if let endVC = segue.source as? EndViewController {
        }
    }
    
    
    @IBAction func navigateToTrophies(_ sender: UIButton) {
        performSegue(withIdentifier: "room", sender: self)
    }
    
    
    @IBAction func showUserDefaults(_ sender: UIButton) {
        
        let name = UserDefaultsManager.shared.getPlayerName()
        let difficulty = UserDefaultsManager.shared.getDifficulty()
        let highScores = HighScoreManager.shared.getHighScores()
        
        let formattedText = highScores.map {
            "\($0["name"] ?? ""): \($0["score"] ?? "")"
        }.joined(separator: "\n")
        
        
        let messageToShow = """
            👴🏻 Name: \(name)
            🎮 Diffuculty: \(difficulty)
            🏆 Highscore: \(highScores.isEmpty ? "No scores saved" : formattedText)
            """
        showStandardAlert(title: "Saved Data", message: messageToShow)
    }
    
    
    @IBAction func deleteUserDefaults(_ sender: UIButton) {
        
        showDialogAlert(title: "Are you sure?", message: "Delete all Data", confirmTitle: "Delete", cancelTitle: "Cancel") {
            UserDefaultsManager.shared.deleteAllData()
            self.showStandardAlert(title: "Deleted", message: "All data deleted")
        }
    }
    
}

// MARK: - UI Setup
extension StartViewController {
    
    private func setupUI() {
        
        //      view.backgroundColor = .systemBackground
        
        nameTextField.delegate = self
        
        //        gameTitle.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        //        gameTitle.textColor = .label
        //        gameTitle.textAlignment = .center
        //        gameTitle.numberOfLines = 0
        
        nameTextField.borderStyle = .roundedRect
        //    nameTextField.backgroundColor = .secondarySystemBackground
        // nameTextField.textColor = .label
        nameTextField.autocorrectionType = .no
        nameTextField.autocapitalizationType = .words
        nameTextField.clearButtonMode = .whileEditing
        nameTextField.adjustsFontSizeToFitWidth = true
        nameTextField.font = UIFont.preferredFont(forTextStyle: .body)
        nameTextField.layer.cornerRadius = 6
        nameTextField.layer.borderWidth = 0.5
        nameTextField.layer.borderColor = UIColor.separator.cgColor
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameTextField.widthAnchor.constraint(equalToConstant: 300),
            nameTextField.heightAnchor.constraint(equalToConstant: 35),
        ])
        
        //        let buttons = [playButton, highscoreButton, settingsButton]
        //
        //        for button in buttons {
        //
        //            button?.backgroundColor = .systemBlue
        //            button?.setTitleColor(.white, for: .normal)
        //            button?.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        //            button?.layer.cornerRadius = 10
        //            button?.layer.shadowColor = UIColor.label.cgColor
        //            button?.layer.shadowOpacity = 0.15
        //            button?.layer.shadowOffset = CGSize(width: 0, height: 3)
        //            button?.layer.shadowRadius = 4
        //            button?.translatesAutoresizingMaskIntoConstraints = false
        //
        //            NSLayoutConstraint.activate([
        //                button!.widthAnchor.constraint(equalToConstant: 200),
        //                button!.heightAnchor.constraint(equalToConstant: 40)
        //            ])
        //
        //
        //        }
        
        // gameTitle.text = "Swift Lingo 🌏"
        nameTextField.placeholder = "Enter your name"
        //        playButton.setTitle("Play", for: .normal)
        //        highscoreButton.setTitle("HighScore", for: .normal)
        //        settingsButton.setTitle("Settings ⚙️", for: .normal)
        
    }
    
    private func shake(_ view: UIView) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.duration = 0.4
        animation.values = [-8, 8, -6, 6, -4, 4, 0]
        view.layer.add(animation, forKey: "shake")
    }
    
    
}

// MARK: - UITextFieldDelegate
extension StartViewController: UITextFieldDelegate {
    
    private func addTapGestureToDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(
            target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

