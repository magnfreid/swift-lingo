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
