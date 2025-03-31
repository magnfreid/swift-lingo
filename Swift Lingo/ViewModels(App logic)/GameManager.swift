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
    private(set) var answerTimes: [Int] = []
    private var currentAnswerStartTime: Date?
    private var sheepTriggered = false
    
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
        currentAnswerStartTime = Date()
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
                if timeRemaining <= 1 {
                    sheepTriggered = true
                }
            } else {
                correctInARow = 0
            }
            if let startTime = currentAnswerStartTime {
                let duration = Int(Date().timeIntervalSince(startTime))
                answerTimes.append(duration)
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
        sheepTriggered = false
        answerTimes.removeAll()
    }
    
    private func stopAndResetTimer() {
        timer?.invalidate()
        timer = nil
        timeRemaining = turnTimerSetting
    }
    
}

extension GameManager {
    
//    func fetchWordsData() -> [(question: String, control: String)] {
//        return [
//            (question: "Apple", control: "Äpple"),
//            (question: "House", control: "Hus"),
//            (question: "Dog", control: "Hund"),
//            (question: "Cat", control: "Katt"),
//            (question: "Book", control: "Bok"),
//            (question: "Tree", control: "Träd"),
//            (question: "Water", control: "Vatten"),
//            (question: "Sun", control: "Sol"),
//            (question: "Car", control: "Bil"),
//            (question: "Friend", control: "Vän"),
// 
//        ]
//    }
    
    //MARK: - EASY MODE
    func fetchWordsEasy() -> [(swedish: String, english: String)] {
        return [
            (swedish: "Äpple", english: "Apple"),
            (swedish: "Hus", english: "House"),
            (swedish: "Hund", english: "Dog"),
            (swedish: "Katt", english: "Cat"),
            (swedish: "Bok", english: "Book"),
            (swedish: "Träd", english: "Tree"),
            (swedish: "Vatten", english: "Water"),
            (swedish: "Sol", english: "Sun"),
            (swedish: "Bil", english: "Car"),
            (swedish: "Vän", english: "Friend"),
            (swedish: "Boll", english: "Ball"),
            (swedish: "Stol", english: "Chair"),
            (swedish: "Måne", english: "Moon"),
            (swedish: "Penna", english: "Pencil"),
            (swedish: "Kaffe", english: "Coffee"),
            (swedish: "Väg", english: "Road"),
            (swedish: "Röd", english: "Red"),
            (swedish: "Hjärna", english: "Brain"),
            (swedish: "Huvud", english: "Head"),
            (swedish: "Pappa", english: "Dad")
        ]
    }
    
    //MARK: - MEDIUM MODE
    func fetchWordsMedium() -> [(swedish: String, english: String)] {
        let mediumWords: [(swedish: String, english: String)] = [
            
            ("Fågelskrämma", "Scarecrow"),
            ("Räknesnurra", "Calculator"),
            ("Jordgubbe", "Strawberry"),
            ("Ficklampa", "Flashlight"),
            ("Äventyr", "Adventure"),
            ("Målarpensel", "Paintbrush"),
            ("Handduk", "Towel"),
            ("Köttbulle", "Meatball"),
            ("Växthuseffekt", "Greenhouse effect"),
            ("Spindelnät", "Spider web"),
            ("Matsäck", "Packed lunch"),
            ("Fjärrkontroll", "Remote control"),
            ("Långkalsonger", "Long johns"),
            ("Snöflinga", "Snowflake"),
            ("Skogspromenad", "Forest walk"),
            ("Leksaksaffär", "Toy store"),
            ("Fågelfjäder", "Bird feather"),
            ("Ryggsäck", "Backpack"),
            ("Telefonnummer", "Phone number"),
            ("Bänkpress", "Bench press")
        ]
        
        return mediumWords
    }
    
    //MARK: - HARD MODE
    func fetchWordsHard() -> [(swedish: String, english: String)] {
        
        let hardWords: [(swedish: String, english: String)] = [
            ("Samhällsbyggnad", "Urban planning"),
            ("Världsarv", "World heritage"),
            ("Ansvarsfullhet", "Responsibility"),
            ("Flygplansmotor", "Aircraft engine"),
            ("Självförverkligande", "Self-actualization"),
            ("Trådlös kommunikation", "Wireless communication"),
            ("Klimatförändringar", "Climate change"),
            ("Vägtrafikinspektör", "Traffic inspector"),
            ("Bostadsrättsförening", "Housing cooperative"),
            ("Mellanösternpolitik", "Middle eastern politics"),
            ("Livsmedelshantering", "Food handling"),
            ("Miljötillstånd", "Environmental permit"),
            ("Elektronikkonstruktion", "Electronics design"),
            ("Höghastighetståg", "High-speed train"),
            ("Försvarsminister", "Defense minister"),
            ("Kriminalteknik", "Forensic science"),
            ("Samarbetsorganisation", "Cooperation organization"),
            ("Internationella relationer", "International relations"),
            ("Högskolebehörighet", "University eligibility"),
            ("Organisationspsykologi", "Organizational psychology")
        ]
        
        return hardWords
    }
    
    //MARK: - EXTREME MODE⚠️
    func fetchWordsExtreme() -> [(swedish: String, english: String)] {
        let extremeWords = [
            ("Verksamhetsutveckling", "Business development"),
            ("Självständighetsförklaring", "Declaration of independence"),
            ("Industrirobotautomation", "Industrial robot automation"),
            ("Besiktningsförrättare", "Certified inspector"),
            ("Mikrovågsteknologi", "Microwave technology"),
            ("Internationellt samfund", "International community"),
            ("Rekonstruktionsplanering", "Restructuring planning"),
            ("Förundersökningsledare", "Preliminary investigation leader"),
            ("Signalbehandlingsalgoritm", "Signal processing algorithm"),
            ("Flerskiktsarkitektur", "Multi-layered architecture"),
            ("Övergångsregering", "Transitional government"),
            ("Industriforskningsinstitut", "Industrial research institute"),
            ("Blodproppsförebyggande", "Thrombosis prevention"),
            ("Energimyndighetsrapport", "Energy agency report"),
            ("Havsövervakningssystem", "Marine monitoring system"),
            ("Tvärvetenskaplig forskning", "Interdisciplinary research"),
            ("Folkhälsomyndigheten", "Public health agency"),
            ("Obligatorisk vaccinationsplan", "Mandatory vaccination plan"),
            ("Avfallshanteringsstrategi", "Waste management strategy"),
            ("Integritetslagstiftning", "Data protection legislation")
        ]
        
        return extremeWords
    }
    
}

//MARK: - CENTRALIZED BADGE LOGIC

extension GameManager {

    func checkForBadgesAfterGame(score: Int, totalTurns: Int) -> [Badges] {
        
        let player = currentPlayer
        var unlockedBadges: [Badges] = []
        let hasDarkMode = UserDefaultsManager.shared.loadDarkMode()
        
        
        
        //"🍼 First time playing (Aww your first time")
        print("Player badges before firstTime check: \(BadgeManager.shared.getBadges(for: player))")
        if !BadgeManager.shared.hasBadge(badges: .firstTime, for: player) {
            BadgeManager.shared.addBadge(badge: .firstTime, for: player)
            unlockedBadges.append(.firstTime)
        }
        
        //"🔑 Scores"
        let totalScores = HighScoreManager.shared.getTotalScorePerPlayer().first { $0.name == player }?.totalScore ?? 0
        
        if totalScores >= 30 && !BadgeManager.shared.hasBadge(badges: .score30, for: player) {
            BadgeManager.shared.addBadge(badge: .score30, for: player)
            unlockedBadges.append(.score30)
        }
        if totalScores >= 50 && !BadgeManager.shared.hasBadge(badges: .score50, for: player) {
            BadgeManager.shared.addBadge(badge: .score50, for: player)
            unlockedBadges.append(.score50)
        }
        if totalScores >= 75 && !BadgeManager.shared.hasBadge(badges: .score75, for: player) {
            BadgeManager.shared.addBadge(badge: .score75, for: player)
            unlockedBadges.append(.score75)
        }
        if totalScores >= 100 && !BadgeManager.shared.hasBadge(badges: .score100, for: player) {
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
        
        //🔢 User has a name that can be written in reversed and still reads the same ("Anna")
        let name = player.lowercased()
        if name == String(name.reversed()) && !BadgeManager.shared.hasBadge(badges: .palindrome, for: name) {
            BadgeManager.shared.addBadge(badge: .palindrome, for: player)
            unlockedBadges.append(.palindrome)
        }
        
        //🎮 20 in a row (in game modes)
        if correctInARow >= 20 {
            
            switch currentDifficulty.lowercased() {
                
            case "easy":
                if !BadgeManager.shared.hasBadge(badges: .easyStreak, for: player) {
                    BadgeManager.shared.addBadge(badge: .easyStreak, for: player)
                    unlockedBadges.append(.easyStreak)
                }
            case "medium":
                if !BadgeManager.shared.hasBadge(badges: .mediumStreak, for: player) {
                    BadgeManager.shared.addBadge(badge: .mediumStreak, for: player)
                    unlockedBadges.append(.mediumStreak)
                }
            case "hard":
                if !BadgeManager.shared.hasBadge(badges: .hardStreak, for: player) {
                    BadgeManager.shared.addBadge(badge: .hardStreak, for: player)
                    unlockedBadges.append(.hardStreak)
                }
            case "extreme":
                if !BadgeManager.shared.hasBadge(badges: .extremeStreak, for: player) {
                    BadgeManager.shared.addBadge(badge: .extremeStreak, for: player)
                    unlockedBadges.append(.extremeStreak)
                }
            default:
                break
            }
            
        }
        
        //🏆 100% Correct in extreme
        if currentDifficulty.lowercased() == "extreme" && score == totalTurns && !BadgeManager.shared.hasBadge(badges: .fullStreak, for: player) {
            BadgeManager.shared.addBadge(badge: .fullStreak, for: player)
            unlockedBadges.append(.fullStreak)
        }
        
        // 🥊 No mercy - 0 mistakes in hard mode
        if currentDifficulty.lowercased() == "hard" && score == totalTurns && !BadgeManager.shared.hasBadge(badges: .noMercy, for: player) {
            BadgeManager.shared.addBadge(badge: .noMercy, for: player)
            unlockedBadges.append(.noMercy)
        }
        
        // ⏱️ The speedster - All answers under 4s
        let allAnswersOnTime = answerTimes
        let allUnder4Seconds = allAnswersOnTime.allSatisfy { $0 <= 4}
        
        if allUnder4Seconds && !BadgeManager.shared.hasBadge(badges: .perfectTime, for: player) {
            BadgeManager.shared.addBadge(badge: .perfectTime, for: player)
            unlockedBadges.append(.perfectTime)
        }
        
        //🏎️ FastAndFurios - 10 answers under 2s(Any mode, so far)
        let fastAnswers = allAnswersOnTime.filter { $0 <= 2 }
        if fastAnswers.count >= 10 && !BadgeManager.shared.hasBadge(badges: .fastAndFurious, for: player) {
            BadgeManager.shared.addBadge(badge: .fastAndFurious, for: player)
            unlockedBadges.append(.fastAndFurious)
        }
        
        // 🐑 Are you afraid? - Answer the question just before the timer stops (1s)
        if sheepTriggered && !BadgeManager.shared.hasBadge(badges: .sheep, for: player) {
            BadgeManager.shared.addBadge(badge: .sheep, for: player)
            unlockedBadges.append(.sheep)
        }
        
        if player.lowercased() == "nicholas" && !BadgeManager.shared.hasBadge(badges: .youShallNotPass, for: player) {
            BadgeManager.shared.addBadge(badge: .youShallNotPass, for: player)
            unlockedBadges.append(.youShallNotPass)
        }
        
        return unlockedBadges
        
    }
}

