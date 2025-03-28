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

    ///Triggers every second while the game timer is running.
    ///- Parameter timeLeft: The number of seconds left in the current turn. */
    func onTimerTick(timeLeft: Int)

    ///Triggers whenever a new turn starts and provides a new randomized game word.
    ///- `question`: The word the player should translate.
    ///- `control: The correct translation of the word.
    func onNewTurnStarted(newWord: (question: String, control: String))

    ///Triggers when a round is resolved, providing the result and remaining turn count.
    ///- Parameter result: The outcome of the turn (correct, wrong, or too slow).
    ///- Parameter turnsRemaining: The number of turns left in game session.
    func onTurnResolved(result: ResultStatus, turnsRemaining: Int)
}

/// Singleton for managing the game session, including turns and timers.
///
/// ## How to Use
/// - Access via `GameManager.shared`.
/// - **startTurn()**: Starts a new turn, initiating the timer and generating a new word via the delegate.
/// - **answerQuestion(answer: String)**: Submits an answer during an active turn. The result is calculated and provided through the delegate.
/// - **resetGame()**: Resets the game session to its initial state.
/// - **setTurnTimer(seconds: Int)**: Sets the turn duration in seconds. Resets the game when called.
/// - **setTurnAmount(turns: Int)**: Sets the total number of turns for the session. Resets the game when called.
final class GameManager {

    static let shared = GameManager()
    

    weak var delegate: GameManagerDelegate?

    private var timer: Timer?

    private(set) var turnTimerSetting = 10
    private(set) var turnAmountSetting = 10

    private var turnsRemaining: Int
    private var timeRemaining: Int
    private var isRunning = false

    private var allWords = [(question: String, control: String)]()
    private var gameWords = [(question: String, control: String)]()
    private var currentWord: (question: String, control: String) = ("", "")
    
    //MARK: - Variables for badges
    private var correctInARow = 0
    private var currentDifficulty: String { UserDefaultsManager.shared.getDifficulty()}
    private var currentPlayer: String { UserDefaultsManager.shared.getPlayerName()}

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
            let isCorrect = answer.lowercased() == currentWord.control.lowercased()
            
            if isCorrect {
                correctInARow += 1
//                checkForStreak()
            } else {
                correctInARow = 0
            }
            resolveTurn(
                result: isCorrect ? .correct : .wrong)
        }
    }

    func setTurnTime(seconds: Int) {
        turnTimerSetting = seconds
        resetGame()
    }

    func setTurnAmount(turns: Int) {
        turnAmountSetting = turns
        resetGame()
    }

    private func resolveTurn(result: ResultStatus) {
        if result != .wrong {
            stopAndResetTimer()
            isRunning = false
            turnsRemaining = max(0, turnsRemaining - 1)
        }

        delegate?.onTurnResolved(
            result: result,
            turnsRemaining: turnsRemaining)
    }

    //TODO: Add this to documentation.
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

    //MARK: - EASY MODE
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

    //MARK: - MEDIUM MODE
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

    //MARK: - HARD MODE
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

    //MARK: - EXTREME MODE⚠️
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

//MARK: - CENTRALIZED BADGE LOGIC

extension GameManager {
    
    
//centralisering för spel logic
    func checkForBadgesAfterGame(score: Int, totalTurns: Int) -> [Badges] {
        
        let player = currentPlayer
        let totalGames = HighScoreManager.shared.getGamesPlayed(for: player)
        var unlockedBadges: [Badges] = []
        let hasDarkMode = UserDefaultsManager.shared.loadDarkMode()
        
        //"🍼 First time playing (Aww your first time")
        if totalGames == 1 && !BadgeManager.shared.hasBadge(badges: .firstTime, for: player) {
            BadgeManager.shared.addBadge(badge: .firstTime, for: player)
            unlockedBadges.append(.firstTime)
        }
        
        //"🔑 Scores"
        if score >= 30 && !BadgeManager.shared.hasBadge(badges: .score30, for: player) {
            BadgeManager.shared.addBadge(badge: .score30, for: player)
            unlockedBadges.append(.score30)
        }
        if score >= 50 && !BadgeManager.shared.hasBadge(badges: .score50, for: player) {
            BadgeManager.shared.addBadge(badge: .score50, for: player)
            unlockedBadges.append(.score50)
        }
        if score >= 75 && !BadgeManager.shared.hasBadge(badges: .score75, for: player) {
            BadgeManager.shared.addBadge(badge: .score75, for: player)
            unlockedBadges.append(.score75)
        }
        if score >= 100 && !BadgeManager.shared.hasBadge(badges: .score100, for: player) {
            BadgeManager.shared.addBadge(badge: .score100, for: player)
            unlockedBadges.append(.score100)
        }
        
        //"🤷‍♂️ Get 0 points ("Did you even try?")
        if score == 0 && !BadgeManager.shared.hasBadge(badges: .typoNoob, for: player) {
            BadgeManager.shared.addBadge(badge: .typoNoob, for: player)
            unlockedBadges.append(.typoNoob)
        }
        
        //🥲 Get one wrong question in what mode? (ONE wrong, Just one)
        if score == totalTurns - 1 && !BadgeManager.shared.hasBadge(badges: .almostThere, for: player) {
            BadgeManager.shared.addBadge(badge: .almostThere, for: player)
            unlockedBadges.append(.almostThere)
        }
        
        //🦇 Play in dark mode ("You merely adopted the dark")
        if hasDarkMode && !BadgeManager.shared.hasBadge(badges: .nightMode, for: player) {
            BadgeManager.shared.addBadge(badge: .nightMode, for: player)
            unlockedBadges.append(.nightMode)
        }
        
        return unlockedBadges
        
    }
}

