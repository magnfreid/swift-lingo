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
        UserDefaults.standard.set(currentScores, forKey: key)
    }
    
    private func formattedDate() -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
        
    }
}
