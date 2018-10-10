//
//  ViewController.swift
//  SetGame
//
//  Created by Marco De Filippo on 10/8/18.
//  Copyright © 2018 Marco De Filippo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private(set) var deck = SetDeck()
    private(set) var selectedCards = [SetCard]()
    private(set) var matchedCards = [SetCard]()
    var preferredFontSize: CGFloat = 25
    
    private let shapes: [Int:String] = [
        0: "●",
        1: "▲",
        2: "■"
    ]
    
    private let colors: [Int:[CGFloat]] = [
        0: [1,0,0],
        1: [0,1,0],
        2: [0,0,1]
    ]
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for button in 0...11 {
            //set the first twelve cards to have a thin black background
            cardButtons[button].layer.borderWidth = 1.0
            cardButtons[button].layer.borderColor = UIColor.black.cgColor
            cardButtons[button].layer.cornerRadius = 8.0
            
            //get 12 cards out of the deck and display them
            if let card = deck.draw() {
                let title = make(card: card) ?? NSAttributedString(string: "??")
                cardButtons[button].setAttributedTitle(title, for: .normal)
            }
        }
    }
    
    // Function takes the input from the SetCard model and translates it to something that
    // the view will draw on the screen
    private func make(card: SetCard) -> NSAttributedString? {
        if let colorComponents = colors[card.color.rawValue] {
            
            var attributes = [NSAttributedString.Key:Any]()
            
            switch card.shading {
                case .striped:
                    attributes = [
                        .foregroundColor: UIColor(red: colorComponents[0], green: colorComponents[1], blue: colorComponents[2], alpha: 0.15),
                        .strokeWidth: -3,
                        .font: UIFont.systemFont(ofSize: preferredFontSize)
                    ]
                case .solid:
                    attributes = [
                        .strokeWidth: -3,
                        .strokeColor: UIColor(red: colorComponents[0], green: colorComponents[1], blue: colorComponents[2], alpha: 1.0),
                        .foregroundColor: UIColor(red: colorComponents[0], green: colorComponents[1], blue: colorComponents[2], alpha: 1.0),
                        .font: UIFont.systemFont(ofSize: preferredFontSize)
                    ]
                case .outlined:
                    attributes = [
                        .strokeWidth: 3,
                        .strokeColor: UIColor(red: colorComponents[0], green: colorComponents[1], blue: colorComponents[2], alpha: 1.0),
                        .font: UIFont.systemFont(ofSize: preferredFontSize)
                    ]
            }
            
            let shape = shapes[card.shape.rawValue]
            var shapeText = ""
            
            for _ in 1...card.number.rawValue {
                shapeText += shape ?? ""
            }
            
            return NSAttributedString(string: shapeText, attributes: attributes)
            
        } else {
            return nil
        }
    }
    
    @IBAction private func drawThreeCards(_ sender: UIButton) {

    }
    


}
