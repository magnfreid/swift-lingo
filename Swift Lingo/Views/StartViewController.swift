//
//  ViewController.swift
//  Swift Lingo
//
//  Created by Magnus Freidenfelt on 2025-03-24.
//

import UIKit

final class StartViewController: UIViewController {
    
    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var highscoreButton: UIButton!
    
    @IBOutlet weak var settingsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addTapGestureToDismissKeyboard()
        
    }

    @IBAction func playButtonTapped(_ sender: UIButton) {
        
        if let name = nameTextField.text, !name.trimmingCharacters(in: .whitespaces).isEmpty {
            UserDefaultsManager.shared.savePlayerName(is: name)
            nameTextField.text = ""
            performSegue(withIdentifier: "navigateToGamePlay", sender: self)
        } else {
            shake(nameTextField)
            showAlert(title: "You're to fast!", message: "You need to enter a name to play")
        }

    }
    
    @IBAction func unwindToStartScreen(_ segue: UIStoryboardSegue) {
            if let endVC = segue.source as? EndViewController {
            }
        }
    
    
    
    @IBAction func trophyRoomTapped(_ sender: UIButton) {
        
        performSegue(withIdentifier: "room", sender: self)
    }
    
    

    
    
    @IBAction func showUserDefaults(_ sender: UIButton) {
        
        let name = UserDefaultsManager.shared.getPlayerName()
        let difficulty = UserDefaultsManager.shared.getDifficulty()
        let highScores = HighScoreManager.shared.getHighScores()
        
        let formatedToText = highScores.map {"\($0["name"] ?? ""): \($0["score"] ?? "")"}.joined(separator: "\n")
        
        let messageToShow = """
        👴🏻 Name: \(name)
        🎮 Diffuculty: \(difficulty)
        🏆 Highscore: \(highScores.isEmpty ? "No scores saved" : formatedToText)
        """
        
        let alert = UIAlertController(title: "Saved data", message: messageToShow, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
        
    }
    
    
    
    @IBAction func deleteUserDefaults(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Are you sure?", message: "Delete all UserDefaults", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            
            let allDefaults = UserDefaults.standard
            allDefaults.removeObject(forKey: "playerName")
            allDefaults.removeObject(forKey: "difficulty")
            allDefaults.removeObject(forKey: "highscores")
            
            let confirmDeletion = UIAlertController(title: "Deleted", message: "All data deleted", preferredStyle: .alert)
            confirmDeletion.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(confirmDeletion, animated: true)
        }))
        
        present(alert, animated: true)
        
        
    }
    
    
    
    
    
    
    
    
    
    
    

    
}

// MARK: - UI Setup
extension StartViewController {
    
    private func setupUI() {
        
        view.backgroundColor = .systemBackground
        
        nameTextField.delegate = self
        
        gameTitle.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        gameTitle.textColor = .label
        gameTitle.textAlignment = .center
        gameTitle.numberOfLines = 0
      
        
        nameTextField.borderStyle = .roundedRect
        nameTextField.backgroundColor = .secondarySystemBackground
        nameTextField.textColor = .label
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
            nameTextField.heightAnchor.constraint(equalToConstant: 35)
        ])
        
        
        let buttons = [playButton, highscoreButton, settingsButton]
        
        for button in buttons {
            
            button?.backgroundColor = .systemBlue
            button?.setTitleColor(.white, for: .normal)
            button?.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
            button?.layer.cornerRadius = 10
            button?.layer.shadowColor = UIColor.label.cgColor
            button?.layer.shadowOpacity = 0.15
            button?.layer.shadowOffset = CGSize(width: 0, height: 3)
            button?.layer.shadowRadius = 4
            button?.translatesAutoresizingMaskIntoConstraints = false
       
            NSLayoutConstraint.activate([
                button!.widthAnchor.constraint(equalToConstant: 200),
                button!.heightAnchor.constraint(equalToConstant: 40)
            ])
            
            
        }
        
        gameTitle.text = "Swift Lingo 🌏"
        nameTextField.placeholder = "Enter your name"
        playButton.setTitle("Play", for: .normal)
        highscoreButton.setTitle("HighScore", for: .normal)
        settingsButton.setTitle("Settings ⚙️", for: .normal)
        
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
        
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
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



//TODO: idéer och förbättringar
