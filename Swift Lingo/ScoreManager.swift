//
//  GameManager.swift
//  Swift Lingo
//
//  Created by Magnus Freidenfelt on 2025-03-24.
//

import UIKit

final class ScoreManager {

    static let shared = ScoreManager()

    private(set) var highScore = [(name: String, score: Int)]()
    let scoreKey = "scoreKey"

    private init() {
        loadHighScores()
    }

    func addScore(name: String, score: Int) {
        highScore.append((name: name, score: score))
        highScore.sort { $0.score > $1.score }
        if highScore.count > 10 {
            highScore.removeLast()
        }
        saveHighScores()
    }

    private func saveHighScores() {
        let scoresArray = highScore.map {
            ["name": $0.name, "score": $0.score]
        }
        UserDefaults.standard.set(scoresArray, forKey: scoreKey)
    }

    private func loadHighScores() {
            if let savedScores = UserDefaults.standard.array(forKey: scoreKey) as? [[String: Any]] {
                highScore = savedScores.map { (name: $0["name"] as! String, score: $0["score"] as! Int) }
                highScore.sort { $0.score > $1.score }
            }
        }

}
