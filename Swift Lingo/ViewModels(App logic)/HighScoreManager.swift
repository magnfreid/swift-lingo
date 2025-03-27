//
//  HighScoreManager.swift
//  Swift Lingo
//
//  Created by Nicholas Samuelsson Jeria on 2025-03-25.
//

import Foundation

final class HighScoreManager {
    
    static let shared = HighScoreManager()
    let key = "highscores"
    
    private init() {}
    
    func getHighScores() -> [[String: Any]] {
        
        return UserDefaults.standard
            .array(forKey: key) as? [[String: Any]] ?? []
        
    }
    
    func saveUserData(score: Int, playerName: String) {
        
        var currentScores = getHighScores()
        
        if currentScores.contains(where: {($0["name"] as? String) == playerName && ($0["score"] as? Int) == score }) {
            print("A duplicate exists")
            return
        }
        
        
        let newEntry: [String: Any] = [
            "score": score,
            "name": playerName,
            "date": formattedDate()
        ]
        currentScores.append(newEntry)
        currentScores.sort { ($0["score"] as? Int ?? 0) > ($1["score"] as? Int ?? 0) }
        UserDefaults.standard.set(currentScores, forKey: key)
    }
    
    func saveUserHighScore(playername: String = UserDefaultsManager.shared.getPlayerName(), score: Int) -> (name: String, score: Int) {
            saveUserData(score: score, playerName: playername)
            return (name: playername, score: score)
        }
    
    private func formattedDate() -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
        
    }
}


