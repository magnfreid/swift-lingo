//
//  GameViewController.swift
//  Swift Lingo
//
//  Created by Simon Elander on 2025-03-24.
//

import UIKit

class GameViewController: UIViewController {

    var turn = 0
    var score = 0
    var time = 10
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(
            withTimeInterval: 1.0, repeats: true,
            block: { [weak self] timer in
                guard let self = self else { return }
                if time > 0 {
                    self.time -= 1
                } else {
                    turnLost()
                }
            })
    }

    func turnLost() {
        timer?.invalidate()
        turn -= 1
        time = 10
        //Display loss screen
        if score > 0 {
            score -= 1
        }
    }

    func btnAnswer() {

    }

    deinit {
        timer?.invalidate()
    }

}
