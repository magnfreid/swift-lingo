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

    let gameManager = GameManager.shared

    var score = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        gameManager.delegate = self
        gameManager.startTurn()

    }

    @IBAction func submitButtonTapped(_ sender: UIButton) {
        print("Tapped")
        guard let guessed = textFieldAnswer.text,
            !guessed.trimmingCharacters(in: .whitespaces).isEmpty
        else {
            return
        }
        gameManager.answerQuestion(answer: guessed)
    }

    private func setupUI() {

        //TODO: finslipa på designen.

        wordLabel.textAlignment = .center
        wordLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)

        textFieldAnswer.delegate = self
        scoreLabel.text = "Score: \(score)"
        timerLabel.text = "00:00"
        wordLabel.text = "Loading..."
    }

}

// MARK: - UITextFieldDelegate
extension GamePlayViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return false
    }

    //TODO: Tving fram tangentbordet vid denna VC, vad ska vi göra? trycka på knappen? retur på tangentbordet?, vi tar fram tangentbordet.

    //TODO: klicka på retur för att mata in ordet, inte ta ned tangentbordet.

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
            let message = (result == .correct) ? "Your guess was right! Game is over..." : "Wrong answer! Game is over..."
            showAlert(title: "Game over!", message: message , buttonText: "End", action: {
                //Show end screen here
            })
            return
        }
        
        if result == .wrong {
            //Show animated label
            textFieldAnswer.text = ""
            return
        }
        else {
            let message = (result == .correct) ? "Your guess was right and you earned a point!": "Too slow!"
            showAlert(title: "Turn complete", message: message, buttonText: "Next", action: {
                self.textFieldAnswer.text = ""
                self.gameManager.startTurn()
            })
        }
    }

    func onTimerTick(timeLeft: Int) {
        timerLabel.text = String(format: "Time left: %02d", timeLeft)
    }

    //    func onAnsweredTooLate() {
    //        //TODO: bugg -> ingen paus om man skrivit fel eller om tiden rinner ut. infinite loop
    //        let alert = UIAlertController(
    //            title: "Too slow", message: "Ah you didnt make it...",
    //            preferredStyle: .alert)
    //        alert.addAction(
    //            UIAlertAction(
    //                title: "Next", style: .default,
    //                handler: { _ in
    //                    self.gameManager.startTurn()
    //                }))
    //
    //        present(alert, animated: true)
    //    }
    //
    //    func onGameOver() {
    //        HighScoreManager.shared.saveUserHighScore(score: score)
    //
    //        let alert = UIAlertController(
    //            title: "🎉 Game Over",
    //            message: "You got \(score) points",
    //            preferredStyle: .alert
    //        )
    //
    //        alert.addAction(
    //            UIAlertAction(
    //                title: "Back", style: .default,
    //                handler: { _ in
    //                    self.navigationController?.popToRootViewController(
    //                        animated: true)
    //                }))
    //        present(alert, animated: true)
    //
    //    }

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

    private func showAlert(
        title: String,
        message: String,
        buttonText: String,
        action: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(
            title: title, message: message,
            preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(
                title: buttonText,
                style: .default,
                handler: { _ in
                    action?()
                }))
        present(alert, animated: true)
    }

}

//TODO: poängen uppdateras inte när man gissar rätt
