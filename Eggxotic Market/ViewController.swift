//
//  ViewController.swift
//  Eggxotic Market
//
//  Created by Joshua Kantner on 7/7/20.
//  Copyright © 2020 Joshua Kantner. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    

    // MARK: - IBOutlets & Variables
    
    // IBOutlets
    
    @IBOutlet weak var buyButton: UIButton!
    
    @IBOutlet weak var passButton: UIButton!
    
    @IBOutlet weak var quitButton: UIButton!
    
    @IBOutlet weak var infoButton: UIButton!
    
    @IBOutlet weak var dayOfWeek: UILabel!
    
    @IBOutlet weak var dayNumber: UILabel!
    
    @IBOutlet weak var playerMoney: UILabel!
    
    @IBOutlet weak var eventType: UILabel!
    
    @IBOutlet weak var eggNumber: UILabel!
    
    @IBOutlet weak var eggPrice: UILabel!
    
    @IBOutlet weak var passMessage: UILabel!
    
    @IBOutlet weak var diffMessage: UILabel!
    
    @IBOutlet weak var priceInfo: UILabel!
    
    @IBOutlet weak var logoAndWinOrLose: UIImageView!
    
    @IBOutlet var blurView: UIVisualEffectView!
    
    @IBOutlet var infoWindow: UIView!
    
    @IBOutlet var winOrLoseWindow: UIView!
    
    @IBOutlet weak var eventTitleInWindow: UILabel!
    
    @IBOutlet weak var eventDetailsInWindow: UILabel!
    
    @IBOutlet weak var imageWinOrLose: UIImageView!
    
    @IBOutlet weak var detailsWinOrLose: UILabel!
    
    @IBOutlet weak var onDifficultyWinOrLose: UILabel!
    
    @IBOutlet weak var newHighScoreMessage: UILabel!
    
    @IBOutlet weak var countingMoney: CountingLabel!
    

    // Other Variables
    
    var difficultyMoney = 0
    var difficultyMessage = ""
    
    var eggsForSale:Int = 3
    
    var eggNum:Int = 1
    
    var dayNum:Int = 1
    
    var money:Int = 0
    
    var difficulty:String = ""
    
    var price = Int.random(in:100...999)
    
    let daysOfTheWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    let possibleEvents = ["none", "good", "bad", "tax", "discount", "broken", "surplus", "shortage", "blackout", "reverse", "coupon", "double"]
        // Note: events listed after "surplus" are not used in current game
    
    var weekDay = ""
    
    var event = "none"
    
    var possibleForEvent = false
    
    var easyHighScore = UserDefaults().integer(forKey: "easyhighscore")
    var normalHighScore = UserDefaults().integer(forKey: "normalhighscore")
    var hardHighScore = UserDefaults().integer(forKey: "hardhighscore")
    
    var easyWinCount = UserDefaults().integer(forKey: "easywincount")
    var normalWinCount = UserDefaults().integer(forKey: "normalwincount")
    var hardWinCount = UserDefaults().integer(forKey: "hardwincount")
    
    var easyWins = 0
    var normalWins = 0
    var hardWins = 0
    
    var audioPlayer: AVAudioPlayer?
    
    // MARK: - Game Functions
    
    // check if player money is below $1000 for color, and $100 for gameover
    func checkMoney(amount:Int) {
        if amount < 1000 {
            countingMoney.textColor = UIColor.red
            playerMoney.textColor = UIColor.red
        }
        if amount < 100 {
            animateIn(desiredView: blurView)
            animateIn(desiredView: winOrLoseWindow)
            difficultyWinOrLoseMessage()
            imageWinOrLose.image = UIImage(named: "gameover")
            detailsWinOrLose.text = "You do not have enough money to buy any more eggs.\nYou only bought \(dayNum - 1) eggs."
            newHighScoreMessage.text = ""
            playSound(soundFile: "Losing", soundExt: "wav")
            
            buyButton.isEnabled = false
            passButton.isEnabled = false
        }
    }
    
    // choose price based on event (or no event)
    func pickPrice(event:String) -> Int {
        if event == possibleEvents[1] {
            price = Int.random(in:100...500)
        }
        else if event == possibleEvents[2] {
            price = Int.random(in:500...999)
        }
        else {
            price = Int.random(in:100...999)
        }
        return price
    }
    
    // check if events are possible based on day of week
    func eventPossible(day:String) -> Bool {
        if day == "Monday" || day == "Wednesday" {
            possibleForEvent = false
        }
        else {
            possibleForEvent = true
        }
        return possibleForEvent
    }
    
    // pick an event based on randomness
    func pickEvent() -> String {
        let chooser = Int.random(in:1...20)
        if chooser == 1 {
            event = possibleEvents[5] //broken
        }
        else if chooser >= 2 && chooser <= 5 {
            event = possibleEvents[1] //good
        }
        else if chooser >= 6 && chooser <= 9 {
            event = possibleEvents[2] //bad
        }
        else if chooser >= 10 && chooser <= 12 {
            event = possibleEvents[4] //discount
        }
        else if chooser >= 13 && chooser <= 16 {
            event = possibleEvents[0] //none
        }
        else if chooser >= 17 && chooser <= 19 {
            event = possibleEvents[3] //tax
        }
        else if chooser == 20 {
            event = possibleEvents[6] //surplus
        }
        return event
    }
    
    func difficultyWinOrLoseMessage() {
        onDifficultyWinOrLose.text = "(on " + difficulty + ")"
        if difficulty == "Easy" {
            onDifficultyWinOrLose.textColor = UIColor.systemTeal
        }
        else if difficulty == "Normal" {
            onDifficultyWinOrLose.textColor = UIColor.systemYellow
        }
        else if difficulty == "Hard" {
            onDifficultyWinOrLose.textColor = UIColor.orange
        }
    }
    
    func saveHighScores() {
        if difficulty == "Easy" {
            UserDefaults.standard.set(money, forKey: "easyhighscore")
        }
        else if difficulty == "Normal" {
            UserDefaults.standard.set(money, forKey: "normalhighscore")
        }
        else if difficulty == "Hard" {
            UserDefaults.standard.set(money, forKey: "hardhighscore")
        }
        
    }
    
    func addToWinCounts() {
        if difficulty == "Easy" {
            UserDefaults.standard.set(easyWins, forKey: "easywincount")
        }
        else if difficulty == "Normal" {
            UserDefaults.standard.set(normalWins, forKey: "normalwincount")
        }
        else if difficulty == "Hard" {
            UserDefaults.standard.set(hardWins, forKey: "hardwincount")
        }
        
    }
    
    func playSound(soundFile:String, soundExt:String) {
        let pathToSound = Bundle.main.path(forResource: soundFile, ofType: soundExt)!
        let url = URL(fileURLWithPath: pathToSound)
        
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("error")
        }
    }
    
    
    // MARK: - Setup (viewDidLoad)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Remove initial message about buying Egg 3
        passMessage.text = ""
        
        // Get Initial Egg Price
        eggPrice.text = "$" + String(price)
        
        // Remove initial message about price info
        priceInfo.text = " "
        
        // Get Initial Day of Week
        weekDay = daysOfTheWeek[0]
        
        // Set initial money amount
        money = difficultyMoney
        playerMoney.text = "$"
        countingMoney.count(fromValue: 0, toValue: Float(money), withDuration: 1, andAnimationType: .EaseOut, andCounterType: .Int)
        
        // Set Egg Count
        eggNumber.text = "Egg " + String(eggNum) + "/" + String(eggsForSale)
        
        // Set difficulty message at top of screen
        difficulty = difficultyMessage
        diffMessage.text = "(on " + difficulty + ")"
        if difficulty == "Easy" {
            diffMessage.textColor = UIColor.systemTeal
        }
        else if difficulty == "Normal" {
            diffMessage.textColor = UIColor.systemYellow
        }
        else if difficulty == "Hard" {
            diffMessage.textColor = UIColor.orange
        }
        
        //set up info window
        
        blurView.bounds = self.view.bounds
        
        infoWindow.bounds = CGRect(x: 0, y: 0, width:self.view.bounds.width * 0.9, height: self.view.bounds.height * 0.5)
        
        // allow background music outside of game
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient)
    }
    
    // MARK: - Animation Functions
    
    // animates in chosen pop up window
    func animateIn(desiredView: UIView) {
        let backgroundView = self.view!
        
        backgroundView.addSubview(desiredView)
        
        // set view scaling
        desiredView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        desiredView.alpha = 0
        desiredView.center = backgroundView.center
        
        UIView.animate(withDuration: 0.3, animations: {
            desiredView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            desiredView.alpha = 1
        })
    }
    
    // animates out the info window
    func animateOut(desiredView: UIView) {
        UIView.animate(withDuration: 0.3, animations: {
            desiredView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            desiredView.alpha = 0
        }, completion: { _ in
            desiredView.removeFromSuperview()
        })
    }
    
    // animates buttons
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
    
    // MARK: - Pass Button
    
    @IBAction func passButton(_ sender: Any) {
        
        // Egg is passed, and next egg is presented.
        animateButtonOut(button:passButton)
        playSound(soundFile:"passButtonSound", soundExt:"wav")
        
        // First check to see how many eggs are presented in total
        if event == possibleEvents[6] {
            eggsForSale = 4
        }
        else {
            eggsForSale = 3
        }
        
        // Then run pass button functions
        if eggNum < eggsForSale {
            eggNum += 1
            eggNumber.text = "Egg " + String(eggNum) + "/" + String(eggsForSale)
            
            price = pickPrice(event:event)
            eggPrice.text = "$" + String(price)
        }
        if eggNum == eggsForSale {
            passMessage.text = "You must buy Egg " + String(eggsForSale)
            passButton.isEnabled = false
        }
        // Check if new egg price does not meet event criteria
        
        if event == possibleEvents[3] { // tax day
            if price >= 900 {
                priceInfo.text = " "
            }
            else {
                priceInfo.text = "+ $100"
                priceInfo.textColor = UIColor.red
            }
        }
        else if event == possibleEvents[4] {
            if price < 200 {
                priceInfo.text = " "
            }
            else {
                priceInfo.text = "- $100"
                priceInfo.textColor = UIColor.green
            }
        }
        else if event == possibleEvents[5] {
            if price < 200 {
                priceInfo.text = " "
            }
            else {
                priceInfo.text = "- 50%"
                priceInfo.textColor = UIColor.green
            }
        }
    }
    
    @IBAction func passButtonOff(_ sender: Any) {
        animateButtonPressed(button:passButton)
        
    }
    
    @IBAction func passButtonDrag(_ sender: Any) {
        animateButtonOut(button:passButton)
    }
    
    
    // MARK: - Buy Button
    
    @IBAction func buyButton(_ sender: AnyObject) {
        
        // Egg is bought, next day begins and egg count is reset
        animateButtonOut(button:buyButton)
        playSound(soundFile:"buyButtonSound", soundExt:"wav")
        
        if dayNum < 10 {
            eggNum = 1
            eggNumber.text = "Egg " + String(eggNum) + "/3"
        
            dayNum += 1
            dayNumber.text = "Day " + String(dayNum) + "/10"
            
            // Calculate money - price based on event (or no event)
            if event == possibleEvents[5] && price >= 200 { // broken day
                countingMoney.count(fromValue: Float(money), toValue: Float(money - (price / 2)), withDuration: 1, andAnimationType: .EaseOut, andCounterType: .Int)
                money = money - (price / 2)
                
            }
            else if event == possibleEvents[3] && price < 900 { // tax
                countingMoney.count(fromValue: Float(money), toValue: Float(money - (price + 100)), withDuration: 1, andAnimationType: .EaseOut, andCounterType: .Int)
                money = money - (price + 100)
                
            }
            else if event == possibleEvents[4] && price >= 200 { //discount
                countingMoney.count(fromValue: Float(money), toValue: Float(money - (price-100)), withDuration: 1, andAnimationType: .EaseOut, andCounterType: .Int)
                money = money - (price - 100)
            }
            else {
                //money = money - price
                //playerMoney.text = "$" + String(money)
                countingMoney.count(fromValue: Float(money), toValue: Float(money - price), withDuration: 1, andAnimationType: .EaseOut, andCounterType: .Int)
                money = money - price
            }
            
            checkMoney(amount:money)
            
            passMessage.text = ""
            passButton.isEnabled = true
            
            // Change Day of Week
            if dayNum <= 7 {
                weekDay = daysOfTheWeek[dayNum - 1]
                dayOfWeek.text = weekDay
            }
            // For when the week needs to loop back to Monday
            else {
                weekDay = daysOfTheWeek[dayNum - 8]
                dayOfWeek.text = weekDay
            }
            
            // Check for if event may occur, and if so generate an event
            possibleForEvent = eventPossible(day:weekDay)
            if possibleForEvent == true {
                event = pickEvent()
                price = pickPrice(event:event)
                eggPrice.text = "$" + String(price)
                if event == possibleEvents[0] {
                    eventType.text = "No Event"
                    priceInfo.text = " "
                    priceInfo.textColor = UIColor.black
                }
                else if event == possibleEvents[1] {
                    eventType.text = "Good Egg Day"
                    priceInfo.text = " "
                    priceInfo.textColor = UIColor.black
                }
                else if event == possibleEvents[2] {
                    eventType.text = "Bad Egg Day"
                    priceInfo.text = " "
                    priceInfo.textColor = UIColor.black
                }
                else if event == possibleEvents[3] {
                    eventType.text = "Tax Day"
                    if price >= 900 {
                        priceInfo.text = " "
                    }
                    else {
                    priceInfo.text = "+ $100"
                    priceInfo.textColor = UIColor.red
                    }
                }
                else if event == possibleEvents[4] {
                    eventType.text = "Discount Day"
                    if price < 200 {
                        priceInfo.text = " "
                    }
                    else {
                    priceInfo.text = "- $100"
                    priceInfo.textColor = UIColor.green
                    }
                }
                else if event == possibleEvents[5] {
                    eventType.text = "Broken Day"
                    if price < 200 {
                        priceInfo.text = " "
                    }
                    else {
                    priceInfo.text = "- 50%"
                    priceInfo.textColor = UIColor.green
                    }
                }
                else if event == possibleEvents[6] {
                    eventType.text = "Surplus Day"
                    priceInfo.text = " "
                    priceInfo.textColor = UIColor.black
                    eggNumber.text = "Egg 1/4"
                }
            }
            else if possibleForEvent == false {
                event = possibleEvents[0]
                price = pickPrice(event:event)
                eggPrice.text = "$" + String(price)
                eventType.text = "No Event"
                priceInfo.text = " "
                priceInfo.textColor = UIColor.black
                }
            
            // Check to see if player has enough money to continue
            if money < 0 {
                countingMoney.text = "$0"
                animateIn(desiredView: blurView)
                animateIn(desiredView: winOrLoseWindow)
                difficultyWinOrLoseMessage()
                imageWinOrLose.image = UIImage(named: "gameover")
                detailsWinOrLose.text = "You ran out of money and only bought \(dayNum - 2) eggs."
                playSound(soundFile: "Losing", soundExt: "wav")
                newHighScoreMessage.text = ""
                
                
                buyButton.isEnabled = false
                passButton.isEnabled = false
                }
            else if money < 100 && dayNum < 10 {
                animateIn(desiredView: blurView)
                animateIn(desiredView: winOrLoseWindow)
                difficultyWinOrLoseMessage()
                imageWinOrLose.image = UIImage(named: "gameover")
                detailsWinOrLose.text = "You do not have enough money to buy any more eggs.\nYou only bought \(dayNum - 1) eggs."
                newHighScoreMessage.text = ""
                playSound(soundFile: "Losing", soundExt: "wav")
                
                buyButton.isEnabled = false
                passButton.isEnabled = false
            }
            
        }
        // Special Criteria for checking win/lose on day 10
        else if dayNum == 10 {
            countingMoney.count(fromValue: Float(money), toValue: Float(money - price), withDuration: 1, andAnimationType: .EaseOut, andCounterType: .Int)
            money = money - price
            
            if money >= 0 {
                animateIn(desiredView: blurView)
                animateIn(desiredView: winOrLoseWindow)
                difficultyWinOrLoseMessage()
                imageWinOrLose.image = UIImage(named: "congratulations")
                detailsWinOrLose.text = "You bought 10 eggxotic eggs with $\(money) left over!"
                newHighScoreMessage.text = ""
                
                
                // save high score & win count based on difficulty
                if difficulty == "Easy" {
                    if money > UserDefaults().integer(forKey: "easyhighscore"){
                        saveHighScores()
                        newHighScoreMessage.text = "New High Score!"
                        playSound(soundFile: "Highscore", soundExt: "wav")
                    }
                    else {
                        playSound(soundFile: "Winning", soundExt: "wav")
                    }
                    
                    easyWins = UserDefaults().integer(forKey:"easywincount")
                    easyWins += 1
                    addToWinCounts()
                }
                else if difficulty == "Normal" {
                    if money > UserDefaults().integer(forKey: "normalhighscore"){
                        saveHighScores()
                        newHighScoreMessage.text = "New High Score!"
                        playSound(soundFile: "Highscore", soundExt: "wav")
                    }
                    else {
                        playSound(soundFile: "Winning", soundExt: "wav")
                    }
                    
                    normalWins = UserDefaults().integer(forKey:"normalwincount")
                    normalWins += 1
                    addToWinCounts()
                }
                else if difficulty == "Hard" {
                    if money > UserDefaults().integer(forKey: "hardhighscore"){
                        saveHighScores()
                        newHighScoreMessage.text = "New High Score!"
                        playSound(soundFile: "Highscore", soundExt: "wav")
                    }
                    else {
                        playSound(soundFile: "Winning", soundExt: "wav")
                    }
                    
                    hardWins = UserDefaults().integer(forKey:"hardwincount")
                    hardWins += 1
                    addToWinCounts()
                }
                
                buyButton.isEnabled = false
                passButton.isEnabled = false
            }
            else if money < 0 {
                countingMoney.text = "$0"
                animateIn(desiredView: blurView)
                animateIn(desiredView: winOrLoseWindow)
                difficultyWinOrLoseMessage()
                imageWinOrLose.image = UIImage(named: "gameover")
                detailsWinOrLose.text = "You ran out of money and only bought \(dayNum - 1) eggs."
                newHighScoreMessage.text = ""
                playSound(soundFile: "Losing", soundExt: "wav")
                
                buyButton.isEnabled = false
                passButton.isEnabled = false
            }
        }
        
    }
    
    @IBAction func buyButtonOff(_ sender: Any) {
        animateButtonPressed(button:buyButton)
    }
    
    @IBAction func buyButtonDrag(_ sender: Any) {
        animateButtonOut(button:buyButton)
    }
    // MARK: - Other Buttons
    
    //  Quit Button
    @IBAction func quitButton(_ sender: Any) {
        animateButtonOut(button:quitButton)
    }
    
    @IBAction func quitButtonOff(_ sender: Any) {
        animateButtonPressed(button:quitButton)
    }
    
    @IBAction func quitButtonDrag(_ sender: Any) {
        animateButtonOut(button:quitButton)
    }
    
    
    // Info window buttons
    
    @IBAction func infoButton(_ sender: Any) {
        
        animateButtonOut(button:infoButton)
        
        // Animate the window into view
        
        animateIn(desiredView: blurView)
        animateIn(desiredView: infoWindow)
        
        // Change text in window for each event
        
        if event == possibleEvents[0] {
            eventTitleInWindow.text = "No Event Today:"
            eventDetailsInWindow.text = "Nothing special happens today.\n\n (NOTE: Mondays and Wednesdays will never have an event)"
        }
        else if event == possibleEvents[1] {
            eventTitleInWindow.text = "Good Egg Day:"
            eventDetailsInWindow.text = "All eggs for sale will range from $100 to $500. Get a cheap egg!"
        }
        else if event == possibleEvents[2] {
            eventTitleInWindow.text = "Bad Egg Day:"
            eventDetailsInWindow.text = "All eggs for sale will range from $500 to $999. This is going to hurt your wallet..."
        }
        else if event == possibleEvents[3] {
            eventTitleInWindow.text = "Tax Day:"
            eventDetailsInWindow.text = "The seller is in need of some extra cash, so unfortunately you must pay an additional $100 on any egg purchase below $900. Yikes!"
        }
        else if event == possibleEvents[4] {
            eventTitleInWindow.text = "Discount Day:"
            eventDetailsInWindow.text = "The seller is offering a $100 discount to any egg purchase of $200 or more! Make sure to take advantage of this offer!"
        }
        else if event == possibleEvents[5] {
            eventTitleInWindow.text = "Broken Egg Day:"
            eventDetailsInWindow.text = "The egg you buy will be broken.\nTo make up for this unfortunate circumstance, the seller will halve the sell price as long as your egg costs at least $200. What a deal!"
        }
        else if event == possibleEvents[6] {
            eventTitleInWindow.text = "Surplus Egg Day:"
            eventDetailsInWindow.text = "The seller has a surplus amount of eggs! To celebrate, you are allowed to see 4 eggs instead of the usual 3 eggs. Choose wisely!"
        }
    }
    
    @IBAction func infoButtonOff(_ sender: Any) {
        animateButtonPressed(button:infoButton)
    }
    
    @IBAction func infoButtonDrag(_ sender: Any) {
        animateButtonOut(button:infoButton)
    }
    
    //back button for info window
    @IBAction func backInfoButton(_ sender: Any) {
        animateOut(desiredView: infoWindow)
        animateOut(desiredView: blurView)
    }
    
    // WinOrLose Window Buttons
    @IBAction func quitButtonWinOrLose(_ sender: Any) {
        animateOut(desiredView: winOrLoseWindow)
        animateOut(desiredView: blurView)
    }
    
    @IBAction func retryButtonWinOrLose(_ sender: Any) {
        animateOut(desiredView: winOrLoseWindow)
        animateOut(desiredView: blurView)
        
        //resets game to original state
        
        eggNum = 1
        eggNumber.text = "Egg " + String(eggNum) + "/3"
        
        dayNum = 1
        dayNumber.text = "Day " + String(dayNum) + "/10"
        
        price = Int.random(in:100...999)
        eggPrice.text = "$" + String(price)
            
        money = difficultyMoney
        playerMoney.text = "$"
        playerMoney.textColor = UIColor.black
        countingMoney.textColor = UIColor.black
        countingMoney.count(fromValue: 0, toValue: Float(money), withDuration: 1, andAnimationType: .EaseOut, andCounterType: .Int)
        
        weekDay = daysOfTheWeek[0]
        dayOfWeek.text = weekDay
        
        event = possibleEvents[0]
        eventType.text = "No Event"
        priceInfo.text = " "
        
        passMessage.text = ""
        
        buyButton.isEnabled = true
        passButton.isEnabled = true
    }
    
}

