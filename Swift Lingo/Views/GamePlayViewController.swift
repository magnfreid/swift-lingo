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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        GameManager.shared.delegate = self
        GameManager.shared.startTurn()
    }
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        print("Tapped")
        guard let guessed = textFieldAnswer.text, !guessed.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        let result = GameManager.shared.answerQuestion(answer: guessed)
        GameManager.shared.pauseTimer()
        
        let alert = UIAlertController(title: result.message, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            GameManager.shared.resumeTimer()
            self.textFieldAnswer.text = ""
        }))
        present(alert, animated: true)
    }
    
    private func setupUI() {
        
        wordLabel.textAlignment = .center
        wordLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        
        textFieldAnswer.delegate = self
        scoreLabel.text = "Score:"
        timerLabel.text = "00:00"
        wordLabel.text = "Loading..."
    }
    
    
}




// MARK: - UITextFieldDelegate
extension GamePlayViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return false
    }
    
    
}

// MARK: - GameManagerDelegate
extension GamePlayViewController: GameManagerDelegate {
    
    func onTimerTick(timeLeft: Int) {
        timerLabel.text = String(format: "Time left: %02d", timeLeft)
    }
    
    func onNewWordPlayed(question: String) {
        animateNewWords(word: question)
    }
    
    func onAnsweredTooLate() {
        
        let alert = UIAlertController(title: "To slow", message: "ah you didnt make it...", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            GameManager.shared.resumeTimer()
        }))

        present(alert, animated: true)
    }
    
    func onGameOver() {
        GameManager.shared.pauseTimer()
        let finalScore = GameManager.shared.score
        HighScoreManager.shared.saveUserHighScore(score: finalScore)
        
        let alert = UIAlertController(
            title: "🎉 Game Over",
            message: "You got \(finalScore) points",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Back", style: .default, handler: { _ in
            self.navigationController?.popToRootViewController(animated: true)
        }))
        present(alert, animated: true)
        
    }
    
    
    
}


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
    
}
