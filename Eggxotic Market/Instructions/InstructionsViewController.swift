//
//  InstructionsViewController.swift
//  Eggxotic Market
//
//  Created by Joshua Kantner on 7/11/20.
//  Copyright © 2020 Joshua Kantner. All rights reserved.
//

import UIKit
import WebKit

class InstructionsViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let localHtmlFile = Bundle.main.path(forResource: "instructions", ofType: "html") {
            do {
                let htmlString = try String.init(contentsOfFile: localHtmlFile, encoding: .utf8)
                webView.loadHTMLString(htmlString, baseURL: Bundle.main.bundleURL)
            } catch {
                    // contents could not be found
                }
        }
        else {
        // instructions.html not found
            
        }
    }
    



}
