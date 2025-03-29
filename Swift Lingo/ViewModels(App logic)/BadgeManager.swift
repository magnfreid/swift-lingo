//
//  BadgeManager.swift
//  Swift Lingo
//
//  Created by Nicholas Samuelsson Jeria on 2025-03-26.
//

import Foundation

enum Badges: String, Codable, CaseIterable {
    
    //STREAK
    case easyStreak = "🧩 Easy 20 streak"
    case mediumStreak = "🔥 Medium 20 streak"
    case hardStreak = "💥 Hard 20 streak"
    case extremeStreak = "👽 Extreme 20 streak"
    case fullStreak = "🏆 100% correct in one Extreme game"
    
    //SCORE
    case score30 = "🔑 30 points total"
    case score50 = "🎯 50 points total"
    case score75 = "👑 75 points total"
    case score100 = "💎 100 points total"
    
    // PERFORMANCE
    case perfectTime = "⏱️ Always answered under 4s"
    case noMercy = "🥊 0 mistakes in hard mode"
    case typoNoob = "🤷‍♂️ Did you even try?"
    case almostThere = "🥲 ONE wrong, Just one"
    case fastAndFurious = "🏎️ F1 wants to meet you" // 10 Correct answers under 2s each
    
    //MODES
    case firstTime = "🍼 Aww your first time"
    case nightMode = "🦇 You merely adopted the dark"
    case allDifficulties = "🎲 Beat all difficulties once"
  
    
    //EASTER EGGS
    case pepsiLover = "🥤 Maxed out your energy?"
    case hulkSmash = "🎮 You pressed something... to many times"
    case sheep = "🐑 Are you afraid?" // vänta för länge innan man svarar tex 1 sekund kvar, i vilket läge?
    case palindrome = "🔢 Ah yes the perfect reflection"
    case bug = "🪲 Bug hunter" // typ klickade 2 gånger på en liten ruta som inte syns (en rolig grej)
    case woof = "🦮 Woof Woof"
    
    //DEV
    case youShallNotPass = "🧙‍♂️ You shall not pass" // Only developers get this badge
    
    
}


final class BadgeManager {
    
    static let shared = BadgeManager()
    private init() {}
    
    
    //MARK: - Adds badge to user / Checks if player already has
    func addBadge(badge: Badges, for player: String) {
        
        var badges = getBadges(for: player)
        
        if !badges.contains(badge) {
            badges.append(badge)
            saveBadges(badges: badges, for: player)
        }
    }
    
    
    
    //MARK: - UserDefaults
    private func saveBadges(badges: [Badges], for player: String) {
        
        let key = "badges_\(player)"
        let data = try? JSONEncoder().encode(badges)
        UserDefaults.standard.set(data, forKey: key)
        
    }
    
    func getBadges(for player: String) -> [Badges] {
        let key = "badges_\(player)"
        guard let data = UserDefaults.standard.data(forKey: key) else { return [] }
        let decoded = try? JSONDecoder().decode([Badges].self, from: data)
        return decoded ?? []
    }
    
    func hasBadgeData(for player: String) -> Bool {
        let key = "badges_\(player)"
        return UserDefaults.standard.data(forKey: key) != nil
    }
    
    func hasBadge(badges: Badges, for player: String) -> Bool {
        return getBadges(for: player).contains(badges)
    }
    
    
    func removeAllBadges(for player: String) {
        let key = "badges_\(player)"
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    func badgeKey(for player: String) -> String {
        return "badges"
    }
    
}

