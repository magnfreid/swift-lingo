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

    //TODO: Tving fram tangentbordet vid denna VC, vad ska vi göra? trycka på knappen? retur på tangentbordet?, vi tar fram tangentbordet.

    //TODO: klicka på retur för att mata in ordet, inte ta ned tangentbordet.

}

// MARK: - GameManagerDelegate
extension GamePlayViewController: GameManagerDelegate {
    func onNewTurnStarted(newWord: (question: String, control: String)) {
        animateNewWords(word: newWord.question)
    }

    func onTurnResolved(
        result: ResultStatus, turnsRemaining: Int
    ) {
        if result == .correct {
            score += 1
            scoreLabel.text = "Score: \(score)"
        }

        let gameOver = turnsRemaining <= 0

        let title = switch result {
        case .correct:
            "Correct!"
        case .wrong:
            "Wrong answer..."
        case .tooSlow:
            "Too late!"
        }
        
        let message = switch result {
        case .correct:
            "Well done!"
        case .wrong:
            "That is not how to spell it..."
        case .tooSlow:
            "Ah, you were too slow!"
        }
       

            

        let alert = UIAlertController(
            title: gameOver ? "Game over!" : title, message: message,
            preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(
                title: gameOver ? "End" : "Next", style: .default,
                handler: { _ in
                    if gameOver {
                        self.gameManager.resetGame()
                        //Show end screen here
                    } else {
                        self.gameManager.startTurn()
                        self.textFieldAnswer.text = ""
                    }
                }))
        present(alert, animated: true)
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

}

//TODO: poängen uppdateras inte när man gissar rätt
