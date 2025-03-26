//
//  UserDefaultsManager.swift
//  Swift Lingo
//
//  Created by Nicholas Samuelsson Jeria on 2025-03-25.
//

import Foundation

final class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    
    private let nameKey = "playerName"
    private let difficultyKey = "difficulty"
    private let darkModeKey = "isDarkModeOn"
    
    private init() {}
    
    func savePlayerName(is name: String) {
        UserDefaults.standard.set(name, forKey: nameKey)
    }
    
    func getPlayerName() -> String {
        return UserDefaults.standard.string(forKey: nameKey) ?? ""
    }
    
    func saveDifficulty(choosen difficulty: String) {
        UserDefaults.standard.set(difficulty, forKey: difficultyKey)
    }
    
    func getDifficulty() -> String {
        return UserDefaults.standard.string(forKey: difficultyKey) ?? ""
    }
    
    //MARK: DARK MODE
    
    func saveDarkMode(isOn: Bool) {
        UserDefaults.standard.set(isOn, forKey: darkModeKey)
    }
    
    func loadDarkMode() -> Bool {
        return UserDefaults.standard.bool(forKey: darkModeKey)
    }
    

}
