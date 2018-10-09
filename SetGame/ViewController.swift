//
//  ViewController.swift
//  SetGame
//
//  Created by Marco De Filippo on 10/8/18.
//  Copyright © 2018 Marco De Filippo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var deck = SetDeck()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for _ in 0...9 {
            if let card = deck.draw() {
                print(card)
            }
        }
        
    }


}

