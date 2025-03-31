//
//  HighViewController.swift
//  Swift Lingo
//
//  Created by Simon Elander on 2025-03-24.
//

import UIKit

final class HighViewController: UIViewController {
    
    @IBOutlet weak var highscoreTableView: UITableView!

    private var totalHighScores: [(name: String, totalScore: Int)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ThemeManager.shared.setTheme(view: self.view)

        
        let currentPlayer = UserDefaultsManager.shared.getPlayerName()
        print("current player: \(currentPlayer)") // Debug
        let selectedDiff = UserDefaultsManager.shared.getDifficulty()
        print(selectedDiff)
        
        highscoreTableView.delegate = self
        highscoreTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        totalHighScores = HighScoreManager.shared.getTotalScorePerPlayer()
        highscoreTableView.reloadData()
    }
    
    @IBAction func tappedNavigationBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
}


extension HighViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalHighScores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = highscoreTableView.dequeueReusableCell(withIdentifier: "namePoints", for: indexPath)
        let entry = totalHighScores[indexPath.row]
        let badges = BadgeManager.shared.getBadges(for: entry.name).map { $0.rawValue.prefix(1) }.joined()
        
        cell.textLabel?.text = "\(entry.name) | \(entry.totalScore)p | \(badges)"
        cell.textLabel?.textColor = ThemeManager.shared.currentTheme?.textColor
        cell.selectionStyle = .none
        return cell
        
        //TODO: CUSTOM CELL?
    }
    
}

extension HighViewController: UITableViewDelegate {
    
    
}
