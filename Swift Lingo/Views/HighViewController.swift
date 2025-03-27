//
//  HighViewController.swift
//  Swift Lingo
//
//  Created by Simon Elander on 2025-03-24.
//

import UIKit

class HighViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var highscoreTableView: UITableView!
    var highScores: [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentPlayer = UserDefaultsManager.shared.getPlayerName()
        print("current player: \(currentPlayer)") // Debug
        
        highScores = HighScoreManager.shared.getHighScores()
        highscoreTableView.delegate = self
        highscoreTableView.dataSource = self
        highscoreTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return highScores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = highscoreTableView.dequeueReusableCell(withIdentifier: "namePoints", for: indexPath)
        let entry = highScores[indexPath.row]
        let playerName = entry["name"] as? String ?? "Jane Doe"
        let score = entry["score"] as? Int ?? 0
        cell.textLabel?.text = "\(playerName): \(score)"
        return cell
    }
    
    private func showAllHighscores() {
        
        
        
    }
}






//TODO: Gör om som i settings, inbädda denna i en nav controller, custom knapp etc etc, ändra namn på klassen, gör den till final


