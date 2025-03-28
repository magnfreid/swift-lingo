//
//  HighViewController.swift
//  Swift Lingo
//
//  Created by Simon Elander on 2025-03-24.
//

import UIKit

final class HighViewController: UIViewController {
    
    @IBOutlet weak var highscoreTableView: UITableView!
    
    var highScores: [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentPlayer = UserDefaultsManager.shared.getPlayerName()
        print("current player: \(currentPlayer)") // Debug
        let selectedDiff = UserDefaultsManager.shared.getDifficulty()
        print(selectedDiff)
        
        highScores = HighScoreManager.shared.getHighScores()
        highscoreTableView.delegate = self
        highscoreTableView.dataSource = self
        highscoreTableView.reloadData()
    }
    

    
}


extension HighViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return highScores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = highscoreTableView.dequeueReusableCell(withIdentifier: "namePoints", for: indexPath)
        let entry = highScores[indexPath.row]
        let playerName = entry["name"] as? String ?? "test"
        let score = entry["score"] as? Int ?? 0
        let difficulty = entry["difficulty"] as? String ?? "No data"
        
        cell.textLabel?.text = "\(playerName) - \(score) p - \(difficulty)"
        return cell
        
        //TODO: CUSTOM CELL?
    }
    
}

extension HighViewController: UITableViewDelegate {
    
    
}





//TODO: Gör om som i settings, inbädda denna i en nav controller, custom knapp etc etc, ändra namn på klassen, gör den till final


