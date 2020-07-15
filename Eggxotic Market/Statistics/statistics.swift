//
//  statistics.swift
//  Eggxotic Market
//
//  Created by Joshua Kantner on 7/12/20.
//  Copyright © 2020 Joshua Kantner. All rights reserved.
//

import UIKit

class statistics: UIViewController {
    
    @IBOutlet weak var easyHighScore: UILabel!
    
    @IBOutlet weak var normalHighScore: UILabel!
    
    @IBOutlet weak var hardHighScore: UILabel!
    
    @IBOutlet weak var easyWinCount: UILabel!
    
    @IBOutlet weak var normalWinCount: UILabel!
    
    @IBOutlet weak var hardWinCount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Update High Scores
        easyHighScore.text = "$" + String(UserDefaults().integer(forKey: "easyhighscore"))
        normalHighScore.text = "$" + String(UserDefaults().integer(forKey: "normalhighscore"))
        hardHighScore.text = "$" + String(UserDefaults().integer(forKey: "hardhighscore"))
        
        // Update Win Counts
        easyWinCount.text = String(UserDefaults().integer(forKey:"easywincount"))
        normalWinCount.text = String(UserDefaults().integer(forKey:"normalwincount"))
        hardWinCount.text = String(UserDefaults().integer(forKey:"hardwincount"))
        
    }
    

   

}
