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
    
    static let shared = GameManager()
    private(set) var roundTime = 10
    private(set) var rounds = 10
    private(set) var score = 0
    
    private var roundsLeft: Int
    private var timer: Timer?
    private var timeLeft: Int
    private var allWords = [(question: String, control: String)]()
    private var gameWords = [(question: String, control: String)]()
    private var currentWord: (question: String, control: String) = ("", "")
    
    weak var delegate: GameManagerDelegate?
    
    private init() {
        timeLeft = roundTime
        roundsLeft = rounds
        allWords = fetchWordsEasy().map {(question: $0.swedish, control: $0.english)}
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
        delegate?.onTimerTick(timeLeft: timeLeft)
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
                    endRound()
                }
                
            }
        )}
    
    
  
    
    /**
     Used when the player answers a question.
     - Returns: A tuple with a descriptive message and a win or lose boolean.
     */
    func answerQuestion(answer: String) -> (
        message: String, correctAnswer: Bool
    ) {
        stopAndResetTimer()
        let isCorrect = answer.lowercased() == currentWord.control.lowercased()
        if isCorrect {
            score += 1
            print("Guessed Right")
        } else {
            score = max(score - 1, 0)
            print("Guessed Wrong")
        }
        endRound()
        return (isCorrect ? "Correct" : "Incorrect", isCorrect)
    }
    
    func setRoundTime(time: Int) {
        roundTime = time
        resetGame()
    }
    
    func setRounds(roundAmount: Int) {
        rounds = roundAmount
        resetGame()
    }
    
    private func endRound() {
        roundsLeft -= 1
        if roundsLeft <= 0 {
            delegate?.onGameOver()
            resetGame()
        } else {
            timeLeft = roundTime
            startTurn()
        }
        
    }
    
    private func resetGame() {
        stopAndResetTimer()
        timeLeft = roundTime
        roundsLeft = rounds
        score = 0
        gameWords = allWords
    }
    
    private func stopAndResetTimer() {
        timer?.invalidate()
        timer = nil
        timeLeft = roundTime
    }
    
    func pauseTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func resumeTimer() {
        startTimer()
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
    
    // MARK - EASY MODE
    func fetchWordsEasy() -> [(swedish: String, english: String)] {
        return [
            (swedish: "Apple", english: "Äpple"),
            (swedish: "House", english: "Hus"),
            (swedish: "Dog", english: "Hund"),
            (swedish: "Cat", english: "Katt"),
            (swedish: "Book", english: "Bok"),
            (swedish: "Tree", english: "Träd"),
            (swedish: "Water", english: "Vatten"),
            (swedish: "Sun", english: "Sol"),
            (swedish: "Car", english: "Bil"),
            (swedish: "Friend", english: "Vän")
        ]
    }
    
    // 7 sekunder
    func fetchWordsMedium() -> [(swedish: String, english: String)] {
        let mediumWords: [(swedish: String, english: String)] = [
            
            ("fågelskrämma", "scarecrow"),
            ("räknesnurra", "calculator"),
            ("jordgubbe", "strawberry"),
            ("ficklampa", "flashlight"),
            ("äventyr", "adventure"),
            ("målarpensel", "paintbrush"),
            ("handduk", "towel"),
            ("köttbulle", "meatball"),
            ("växthuseffekt", "greenhouse effect"),
            ("spindelnät", "spider web"),
            ("matsäck", "packed lunch"),
            ("fjärrkontroll", "remote control"),
            ("långkalsonger", "long johns"),
            ("snöflinga", "snowflake"),
            ("skogspromenad", "forest walk"),
            ("leksaksaffär", "toy store"),
            ("fågelfjäder", "bird feather"),
            ("ryggsäck", "backpack"),
            ("telefonnummer", "phone number"),
            ("bänkpress", "bench press")
        ]
        
        return mediumWords
    }
    
    // 10 sekunder
    func fetchWordsHard() -> [(swedish: String, english: String)] {
        
        let hardWords: [(swedish: String, english: String)] = [
            ("samhällsbyggnad", "urban planning"),
            ("världsarv", "world heritage"),
            ("ansvarsfullhet", "responsibility"),
            ("flygplansmotor", "aircraft engine"),
            ("självförverkligande", "self-actualization"),
            ("trådlös kommunikation", "wireless communication"),
            ("klimatförändringar", "climate change"),
            ("vägtrafikinspektör", "traffic inspector"),
            ("bostadsrättsförening", "housing cooperative"),
            ("mellanösternpolitik", "middle eastern politics"),
            ("livsmedelshantering", "food handling"),
            ("miljötillstånd", "environmental permit"),
            ("elektronikkonstruktion", "electronics design"),
            ("höghastighetståg", "high-speed train"),
            ("försvarsminister", "defense minister"),
            ("kriminalteknik", "forensic science"),
            ("samarbetsorganisation", "cooperation organization"),
            ("internationella relationer", "international relations"),
            ("högskolebehörighet", "university eligibility"),
            ("organisationspsykologi", "organizational psychology")
        ]
        
        return hardWords
    }
    
    //16 sekunder ⚠️
    func fetchWordsExtreme() -> [(swedish: String, english: String)] {
        let extremeWords = [
            
            ("verksamhetsutveckling", "business development"),
            ("självständighetsförklaring", "declaration of independence"),
            ("industrirobotautomation", "industrial robot automation"),
            ("besiktningsförrättare", "certified inspector"),
            ("mikrovågsteknologi", "microwave technology"),
            ("internationellt samfund", "international community"),
            ("rekonstruktionsplanering", "restructuring planning"),
            ("förundersökningsledare", "preliminary investigation leader"),
            ("signalbehandlingsalgoritm", "signal processing algorithm"),
            ("flerskiktsarkitektur", "multi-layered architecture"),
            ("övergångsregering", "transitional government"),
            ("industriforskningsinstitut", "industrial research institute"),
            ("blodproppsförebyggande", "thrombosis prevention"),
            ("energimyndighetsrapport", "energy agency report"),
            ("havsövervakningssystem", "marine monitoring system"),
            ("tvärvetenskaplig forskning", "interdisciplinary research"),
            ("folkhälsomyndigheten", "public health agency"),
            ("obligatorisk vaccinationsplan", "mandatory vaccination plan"),
            ("avfallshanteringsstrategi", "waste management strategy"),
            ("integritetslagstiftning", "data protection legislation")
            
        ]
        
        return extremeWords
    }
    
}
