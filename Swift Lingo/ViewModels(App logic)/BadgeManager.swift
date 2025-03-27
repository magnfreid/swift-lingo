//
//  BadgeManager.swift
//  Swift Lingo
//
//  Created by Nicholas Samuelsson Jeria on 2025-03-26.
//

import Foundation

enum Badges: String, Codable, CaseIterable {
    
    case easyStreak = "🧩 Easy 20 streak"
    case mediumStreak = "🔥 Medium 20 streak"
    case hardStreak = "💥 Hard 20 streak"
    case extremeStreak = "👽 Extreme 20 streak"
    
    case score30 = "🔑 30 points total"
    case score50 = "🎯 50 points total"
    case score75 = "👑 75 points total"
    case score100 = "💎 100 points total"
    
    // fler svårighetsnivår? extreme ==
    case perfectTime = "⏱️ Always answered under 4s"
    
    case firstTime = "🍼 Ah your first time"
    case nightMode = "🦇 Ahh you think darkness is your ally? (game in darkmode)"
    
    case fullStreak = "🏆 100% correct answers in one game"
    
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
        
        let key = "badges_ \(player)"
        let data = try? JSONEncoder().encode(badges)
        UserDefaults.standard.set(data, forKey: key)
        
    }
    
    func getBadges(for player: String) -> [Badges] {
        let key = "badges_\(player)"
        guard let data = UserDefaults.standard.data(forKey: key) else { return [] }
        let decoded = try? JSONDecoder().decode([Badges].self, from: data)
        return decoded ?? []
    }
    
    func hasBadge(badges: Badges, for player: String) -> Bool {
        return getBadges(for: player).contains(badges)
    }
    
    
    func removeAllBadges(for player: String) {
        let key = "badges_\(player)"
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    
    
}
