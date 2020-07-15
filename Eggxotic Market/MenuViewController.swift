//
//  MenuViewController.swift
//  Eggxotic Market
//
//  Created by Joshua Kantner on 7/8/20.
//  Copyright © 2020 Joshua Kantner. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var learnButton: UIButton!
    
    @IBOutlet weak var statsButton: UIButton!
    
    
    func animateButtonPressed(button: UIButton) {
        UIButton.animate(withDuration: 0.1, animations: {
            button.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        })
    }
    
    func animateButtonOut(button:UIButton) {
        UIButton.animate(withDuration: 0.1, animations: {
            button.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    // play button
    
    @IBAction func playButtonInside(_ sender: Any) {
        animateButtonOut(button:playButton)
    }
    
    @IBAction func playButtonDown(_ sender: Any) {
        animateButtonPressed(button:playButton)
    }
    
    @IBAction func playButtonDrag(_ sender: Any) {
        animateButtonOut(button:playButton)
    }
    
    //learn button
    
    @IBAction func learnButtonInside(_ sender: Any) {
        animateButtonOut(button:learnButton)
    }
    
    @IBAction func learnButtonDown(_ sender: Any) {
        animateButtonPressed(button:learnButton)
    }
    
    @IBAction func learnButtonDrag(_ sender: Any) {
        animateButtonOut(button:learnButton)
    }
    
    // stats button
    
    @IBAction func statsButtonInside(_ sender: Any) {
        animateButtonOut(button:statsButton)
    }
    
    @IBAction func statsButtonDown(_ sender: Any) {
        animateButtonPressed(button:statsButton)
    }
    
    @IBAction func statsButtonDrag(_ sender: Any) {
        animateButtonOut(button:statsButton)
    }
    
    
    
    
}
