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
        guard let correctAnswer = textFieldAnswer.text, !correctAnswer.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        let finishedGame = GameManager.shared.answerQuestion(answer: correctAnswer)
        scoreLabel.text = "Score :\(GameManager.shared.score)"
        textFieldAnswer.text = ""
        
        let alert = UIAlertController(title: finishedGame.correctAnswer ? "Correct" : "Incorrect", message: finishedGame.message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func setupUI() {
        textFieldAnswer.delegate = self
        scoreLabel.text = "Score: 0"
        timerLabel.text = "Time: 00:00"
        wordLabel.text = "Loading..."
    }
    
    
}




// MARK: - UITextFieldDelegate
extension GamePlayViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        submitButtonTapped(UIButton())
        return true
    }
    
    
}

// MARK: - GameManagerDelegate
extension GamePlayViewController: GameManagerDelegate {
    func onTimerTick(timeLeft: Int) {
        timerLabel.text = "\(timeLeft)"
    }
    
    func onNewWordPlayed(question: String) {
        animateNewWords(word: question)
    }
    
    func onAnsweredTooLate() {
        let alert = UIAlertController(title: "to slow", message: "you didnt make it in time", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func onGameOver() {
        let score = GameManager.shared.score
        HighScoreManager.shared.saveUserHighScore(score: score)
        
        let alert = UIAlertController(
            title: "🎉 Game Over",
            message: "Du fick \(score) poäng!",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Tillbaka", style: .default, handler: { _ in
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
