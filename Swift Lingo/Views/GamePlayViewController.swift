//
//  GamePlayViewController.swift
//  Swift Lingo
//
//  Created by Nicholas Samuelsson Jeria on 2025-03-25.
//

import UIKit

class GamePlayViewController: UIViewController {
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var textFieldAnswer: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var wrongLabel: UILabel!
    
    let gameManager = GameManager.shared
    
    let endScreenSegueId = "toEndScreenSegue"
    
    var score = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        gameManager.delegate = self
        gameManager.startTurn()
        ThemeManager.shared.setTheme(view: self.view)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textFieldAnswer.becomeFirstResponder()
    }



    private func setupUI() {
        
        //TODO: finslipa på designen. 2.0
        
        wordLabel.textAlignment = .center
        wordLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        
        textFieldAnswer.delegate = self
        textFieldAnswer.placeholder = "Guess the word"
        scoreLabel.text = "Score: \(score)"
        timerLabel.text = "00:00"
        wordLabel.text = "Loading..."
        
        textFieldAnswer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textFieldAnswer.widthAnchor.constraint(equalToConstant: 300),
            textFieldAnswer.heightAnchor.constraint(equalToConstant: 50),
            
        ])
        
    }
    
}

// MARK: - UITextFieldDelegate
extension GamePlayViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("Tapped")
        guard let guessed = textFieldAnswer.text,
            !guessed.trimmingCharacters(in: .whitespaces).isEmpty
        else {
            return false
        }
        gameManager.answerQuestion(answer: guessed)
        return false
    }
}

// MARK: - GameManagerDelegate
extension GamePlayViewController: GameManagerDelegate {
    func onNewTurnStarted(newWord: (question: String, control: String)) {
        animateNewWords(word: newWord.question)
    }
    
    func onTurnResolved(
        result: ResultStatus,
        turnsRemaining: Int
    ) {
        let gameOver = turnsRemaining <= 0
        
        if result == .correct {
            score += 1
            scoreLabel.text = "Score: \(score)"
        }
        
        if gameOver {
            showStandardAlert(title: "Game Over", message: "Your score: \(score)", buttonText: "See results") {
                let unlockedBadges = self.gameManager.checkForBadgesAfterGame(
                    score: self.score,
                    totalTurns: self.gameManager.turnAmountSetting
                )
                print("Unlocked badges: \(unlockedBadges)")
                if !unlockedBadges.isEmpty {
                    self.showBadgesInOrder(badges: unlockedBadges)
                } else {
                    self.navigateToEndScreen()
                }
            }
            return
        }
        
        if result == .wrong {
            animateWrongLabelShake()
            textFieldAnswer.text = ""
            return
        } else {
            let message =
            (result == .correct)
            ? "Your guess was right and you earned a point!" : "Too slow!"
            showStandardAlert(title: "Turn complete", message: message, buttonText: "Next") {
                self.textFieldAnswer.text = ""
                self.gameManager.startTurn()
            }
        }
    }
    
    func showBadgesInOrder(badges: [Badges], index: Int = 0) {
        if index >= badges.count {
            self.navigateToEndScreen()
            return
        }
        showUnlockedBadgeAlert(badge: badges[index]) {
            self.showBadgesInOrder(badges: badges, index: index + 1)
        }
    }
    
    
    func onTimerTick(timeLeft: Int) {
        timerLabel.text = String(format: "Time left: %02d", timeLeft)
    }
}

//MARK: Animations & Alerts
extension GamePlayViewController {
    
    private func animateNewWords(word: String) {
        wordLabel.alpha = 0
        wordLabel.transform = CGAffineTransform(translationX: 0.8, y: 0.8)
        wordLabel.text = word
        
        UIView.animate(withDuration: 0.3) {
            self.wordLabel.alpha = 1
            self.wordLabel.transform = .identity
        }
        
    }
    
    private func animateWrongLabelShake() {
        wrongLabel.isHidden = false
        let shake = CAKeyframeAnimation(keyPath: "transform.translation.x")
        shake.values = [-10, 10, -10, 10, -5, 5, -5, 5, 0]
        shake.keyTimes = [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 1]
        shake.duration = 0.5
        shake.repeatCount = 2
        wrongLabel.layer.add(shake, forKey: "shake")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.wrongLabel.isHidden = true
        }
    }
}

//MARK: Segue control
extension GamePlayViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == endScreenSegueId {
            if let endVC = segue.destination as? EndViewController {
                endVC.score = score
            }
        }
    }
    
    private func navigateToEndScreen() {
        self.performSegue(withIdentifier: endScreenSegueId, sender: nil)
    }
}
