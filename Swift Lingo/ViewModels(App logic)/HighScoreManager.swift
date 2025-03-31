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
        let difficulty = UserDefaultsManager.shared.getDifficulty()
        
        if let index = currentScores.firstIndex(where: {($0["name"] as? String) == playerName}) {
            
            if let existingScore = currentScores[index]["score"] as? Int {
                
                currentScores[index]["score"] = existingScore + score
                
            } else {
                
                let newEntry: [String: Any] = [
                    "score": score,
                    "name": playerName,
                    "date": formattedDate(),
                    "difficulty": difficulty
                ]
                currentScores.append(newEntry)
                
            }
           
        }
 
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
    
    func getTotalScorePerPlayer() -> [(name: String, totalScore: Int)] {
        var scoreDict = [String: Int]()
        
        for playerScore in getHighScores() {
            guard let name = playerScore["name"] as? String,
                  let scores = playerScore["score"] as? Int else { continue }
            
            scoreDict[name, default: 0] += scores
        }
        
        return scoreDict.map { ($0.key, $0.value) }
            .sorted { $0.1 > $1.1}
    }
}


//MARK: - BADGE LOGIC
extension HighScoreManager {
    
    func getGamesPlayed(for player: String) -> Int {
        return getHighScores().filter { $0["name"] as? String == player }.count
        
    }
        
}

