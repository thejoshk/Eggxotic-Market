//
//  DifficultyViewController.swift
//  Eggxotic Market
//
//  Created by Joshua Kantner on 7/8/20.
//  Copyright © 2020 Joshua Kantner. All rights reserved.
//

import UIKit

class DifficultyViewController: UIViewController {
    
    var money = 0
    var difficulty = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func easyDifficulty(_ sender: Any) {
        money = 5000
        difficulty = "Easy"
    }
    
    @IBAction func normalDifficulty(_ sender: Any) {
        money = 4000
        difficulty = "Normal"
    }
    
    @IBAction func hardDifficulty(_ sender: Any) {
        money = 3000
        difficulty = "Hard"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "easy" || segue.identifier == "normal" || segue.identifier == "hard" {
            let vc = segue.destination as! ViewController
            vc.difficultyMoney = self.money
            vc.difficultyMessage = self.difficulty
            }
        
        }
    }

