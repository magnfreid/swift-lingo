//
//  GameManager.swift
//  Swift Lingo
//
//  Created by Magnus Freidenfelt on 2025-03-24.
//

import UIKit

enum ResultStatus {
    case correct, wrong, tooSlow
}

protocol GameManagerDelegate: AnyObject {
    /** Reports the remaining time after each timer tick.
     - Parameter timeLeft: The number of seconds left in the current turn. */
    func onTimerTick(timeLeft: Int)

    /** Signals the start of a new turn with a fresh word pair.
    - Parameter newWord: A tuple with the English question and Swedish control word. */
    func onNewTurnStarted(newWord: (question: String, control: String))

    /** Notifies when a turn ends, providing the result and remaining turn count.
    - Parameter result: The outcome of the turn (correct, wrong, or too slow).
    - Parameter turnsRemaining: The number of turns left in the game. */
    func onTurnResolved(result: ResultStatus, turnsRemaining: Int)
}

final class GameManager {

    static let shared = GameManager()

    weak var delegate: GameManagerDelegate?

    private var timer: Timer?

    ///Setting for how many seconds each turn lasts.
    private(set) var turnTimerSetting = 10
    ///Setting for how many rounds a game setting has.
    private(set) var turnAmountSetting = 10

    private var turnsRemaining: Int
    private var timeRemaining: Int
    private var isRunning = false

    private var allWords = [(question: String, control: String)]()
    private var gameWords = [(question: String, control: String)]()
    private var currentWord: (question: String, control: String) = ("", "")

    private init() {
        timeRemaining = turnTimerSetting
        turnsRemaining = turnAmountSetting
        allWords = fetchWordsEasy().map {
            (question: $0.swedish, control: $0.english)
        }
        gameWords = allWords
    }

    func startTurn() {
        guard !gameWords.isEmpty else { return }
        let randomIndex = Int.random(in: 0..<gameWords.count)
        currentWord = gameWords[randomIndex]
        gameWords.remove(at: randomIndex)
        delegate?.onNewTurnStarted(newWord: currentWord)
        startTimer()
        delegate?.onTimerTick(timeLeft: timeRemaining)
    }

    private func startTimer() {
        if turnsRemaining > 0 && !isRunning {
            isRunning = true
            timer = Timer.scheduledTimer(
                withTimeInterval: 1.0, repeats: true,
                block: { [weak self] timer in
                    guard let self = self else { return }
                    if timeRemaining > 0 {
                        timeRemaining -= 1
                        delegate?.onTimerTick(timeLeft: timeRemaining)
                    } else {
                        resolveTurn(result: .tooSlow)
                    }
                }
            )
        }
    }

    func answerQuestion(answer: String) {
        if isRunning {
            let isCorrect =
                answer.lowercased() == currentWord.control.lowercased()
            resolveTurn(
                result: isCorrect ? .correct : .wrong)
        }
    }

    func setRoundTime(time: Int) {
        turnTimerSetting = time
        resetGame()
    }

    func setRounds(roundAmount: Int) {
        turnAmountSetting = roundAmount
        resetGame()
    }

    private func resolveTurn(result: ResultStatus) {
        if result != .wrong {
            stopAndResetTimer()
            isRunning = false
        }
        turnsRemaining = max(0, turnsRemaining - 1)
        delegate?.onTurnResolved(
            result: result,
            turnsRemaining: turnsRemaining)
    }

    func loadWords(words: [(swedish: String, english: String)]) {
        allWords = words.map { (question: $0.swedish, control: $0.english) }
        gameWords = allWords
    }

    func resetGame() {
        stopAndResetTimer()
        timeRemaining = turnTimerSetting
        turnsRemaining = turnAmountSetting
        gameWords = allWords
    }

    private func stopAndResetTimer() {
        timer?.invalidate()
        timer = nil
        timeRemaining = turnTimerSetting
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
            (question: "Friend", control: "Vän"),
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
            (swedish: "Friend", english: "Vän"),
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
            ("bänkpress", "bench press"),
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
            ("organisationspsykologi", "organizational psychology"),
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
            ("integritetslagstiftning", "data protection legislation"),

        ]

        return extremeWords
    }

}
