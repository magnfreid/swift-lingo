//
//  BadgesRoomViewController.swift
//  Swift Lingo
//
//  Created by Nicholas Samuelsson Jeria on 2025-03-27.
//

import UIKit

final class TrophyRoomViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var allBadges = Badges.allCases
    private var unlockedBadges: [Badges] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        let currentPlayer = UserDefaultsManager.shared.getPlayerName()
        unlockedBadges = BadgeManager.shared.getBadges(for: currentPlayer)
    }
    
    
    
    @IBAction func backButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
}


extension TrophyRoomViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allBadges.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "trophyCell", for: indexPath)
        let badge = allBadges[indexPath.row]
        let isUnlocked = unlockedBadges.contains(badge)
        cell.textLabel?.text = badge.rawValue
        cell.textLabel?.textColor = isUnlocked ? .label : .systemGray
        return cell
    }
    
}

extension TrophyRoomViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let badge = allBadges[indexPath.row]
        let isUnlocked = unlockedBadges.contains(badge)
        
        guard !isUnlocked else { return }
        
        let hint = showHintForBadges(badge: badge)
        let alert = UIAlertController(title: "🔓 Locked Badge", message: hint, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Got it!", style: .default))
        present(alert, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

    private func showHintForBadges(badge: Badges) -> String {
        
        switch badge {
            
        case .nightMode:
            return "Activate dark mode and finish a full game 🦇"
        case .firstTime:
            return "Complete your first game 🍼"
        case .score30:
            return "Score at least 30 points in total 🔑"
        case .score50:
            return "Score at least 50 points in total 🎯"
        case .score75:
            return "Score at least 75 points in total 👑"
        case .score100:
            return "Score at least 100 points in total 💎"
        case .easyStreak:
            return "Get 20 correct in a row on Easy 🐸"
        case .mediumStreak:
            return "Get 20 correct in a row on Medium 🔥"
        case .hardStreak:
            return "Get 20 correct in a row on Hard 💥"
        case .extremeStreak:
            return "Get 20 correct in a row on Extreme 👽"
        case .perfectTime:
            return "Answer every question under 4 seconds ⏰"
        case .fullStreak:
            return "Answer all questions correctly in one game on Extreme 🏆"
        case .typoNoob:
            return "Score 0 points in one game 🤦🏼‍♀️"
        case .almostThere:
            return "Get all but one question right in one game 🥲"
        case .pepsiLover:
            return "Play with a Pepsi Max drink 🥤"
        case .noMercy:
            return "0 mistakes in hard mode 🥊"
        case .allDifficulties:
            return "Beat a game on all difficulties 🎲"
        case .hulkSmash:
            return "You pressed too many buttons... 🎮"
        case .fastAndFurious:
            return "Get 10 answers under 2 seconds each 🏎️"
        case .sheep:
            return "Answer right before the timer hits 0... 🐑"
        case .bug:
            return "Ah, the joys of coding... 🐞"
        case .youShallNotPass:
            return "Only given to the developers during development 🧙🏻‍♂️"
        }
        
        
        
    }
    
}
