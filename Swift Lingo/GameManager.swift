//
//  GameManager.swift
//  Swift Lingo
//
//  Created by Magnus Freidenfelt on 2025-03-24.
//

import UIKit

protocol GameManagerDelegate: AnyObject {
    ///Provides the time left after each tick.
    func onTimerTick(timeLeft: Int)
    ///Provides a new word for the game.
    func onNewWordPlayed(question: String)
    ///Triggers when the player did not answer in time.
    func onAnsweredTooLate()
    ///Triggers when the all rounds have been played and the game is over.
    func onGameOver()
}

final class GameManager {

    private var roundsLeft: Int
    private var timer: Timer?
    private(set) var roundTime = 10
    private(set) var rounds = 10
    private var timeLeft: Int
    private var allWords = [(question: String, control: String)]()
    private var gameWords = [(question: String, control: String)]()
    private var currentWord: (question: String, control: String) = ("", "")

    weak var delegate: GameManagerDelegate?

    private init() {
        timeLeft = roundTime
        roundsLeft = rounds
        allWords = fetchWordsData()
        gameWords = allWords
    }

    /*
     *** Possible outcomes ***

     Time runs out: onAnsweredTooLate() triggers, timer stops and round time resets. Checks if it was last round and trigger game over if is.

     Player answers question: Stop timer and check correct answer. Checks if it was last round and trigger game over if is.

     */

    func startTurn() {
        guard !gameWords.isEmpty else { return }
        let randomIndex = Int.random(in: 0..<gameWords.count)
        currentWord = gameWords[randomIndex]
        gameWords.remove(at: randomIndex)
        delegate?.onNewWordPlayed(question: currentWord.question)
        startTimer()
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(
            withTimeInterval: 1.0, repeats: true,
            block: { [weak self] timer in
                guard let self = self else { return }
                if timeLeft > 0 {
                    timeLeft -= 1
                    delegate?.onTimerTick(timeLeft: timeLeft)
                } else {
                    delegate?.onAnsweredTooLate()
                    roundsLeft -= 1
                    if roundsLeft <= 0 {
                        delegate?.onGameOver()
                        resetGame()
                    }
                    stopTimer()
                    resetTimer()
                }
            })
    }

    /**
     Used when the player answers a question.
     - Returns: A tuple with a descriptive message and a win or lose boolean.
     */
    func answerQuestion(answer: String) -> (
        message: String, correctAnswer: Bool
    ) {
        stopTimer()
        roundsLeft -= 1
        if roundsLeft <= 0 {
            delegate?.onGameOver()
            resetGame()
        }
        if answer.lowercased() == currentWord.control.lowercased() {
            return ("Correct answer!", true)
        } else {
            return ("Wrong answer!", false)
        }
    }

    func setRoundTime(time: Int) {
        roundTime = time
        resetGame()
    }

    func setRounds(roundAmount: Int) {
        rounds = roundAmount
        resetGame()
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func resetGame() {
        stopTimer()
        timeLeft = roundTime
        roundsLeft = rounds
        gameWords = allWords
    }

    private func resetTimer() {
        timeLeft = roundTime
    }

}

extension GameManager {
    
    func fetchWordsData() -> [(question: String, control: String)] {
        return [
            (question: "Apple", control: "Äpple"),
            (question: "House", control: "Hus"),
            (question: "Dog", control: "Hund"),
            (question: "Cat", control: "Katt"),
            (question: "Book", control: "Bok"),
            (question: "Tree", control: "Träd"),
            (question: "Water", control: "Vatten"),
            (question: "Sun", control: "Sol"),
            (question: "Car", control: "Bil"),
            (question: "Friend", control: "Vän")
        ]
    }

}
