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
        let newEntry: [String: Any] = [
            "score": score,
            "name": playerName,
            "date": formattedDate()
        ]
        currentScores.append(newEntry)
        currentScores.sort { ($0["score"] as? Int ?? 0) > ($1["score"] as? Int ?? 0) }
        UserDefaults.standard.set(currentScores, forKey: key)
    }
    
    func saveUserHighScore(score: Int) {
        let name = UserDefaultsManager.shared.getPlayerName()
        saveUserData(score: score, playerName: name)
    }
    
    private func formattedDate() -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
        
    }
}


