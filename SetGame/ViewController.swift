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
    private(set) var cardsInPlay = [SetCard]()
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
    
    private struct Constants {
        static let selectedBorderWidth: CGFloat = 3.0
        static let selectedBorderColor = UIColor.blue.cgColor
        static let normalBorderWidth: CGFloat = 1.0
        static let normalBorderColor = UIColor.black.cgColor
        static let cornerRadius: CGFloat = 8.0
    }
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup the first 12 cards when the game starts
        for button in 0...11 {
            //set the first twelve cards to have a thin black background
            cardButtons[button].layer.borderWidth = Constants.normalBorderWidth
            cardButtons[button].layer.borderColor = Constants.normalBorderColor
            cardButtons[button].layer.cornerRadius = Constants.cornerRadius
            
            //get 12 cards out of the deck and display them
            if let card = deck.draw() {
                let title = make(card: card) ?? NSAttributedString(string: "??")
                cardButtons[button].setAttributedTitle(title, for: .normal)
                cardsInPlay.append(card)
            } else {
                print("No more cards in the deck!")
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
        // ALWAYS MAKE SURE WHEN YOU ADD A CARD THAT ITS POSITION IN THE cardsInPlay ARRAY MATCHES THE CORRESPONDING INDEX OF ITS cardButton
    }
    

    @IBAction private func touchCard(_ sender: UIButton) {
        // Figure out what card the user clicked on
        if let buttonIndex = cardButtons.firstIndex(of: sender) {
            // change it to selected or de-selected
            changeButtonState(forIndex: buttonIndex)
            
            // if 3 cards have been selected, check if it's a match
            if(selectedCards.count == 3) {
                
            }
            
        } else {
            print("Could not identify the selected card")
        }
    }
    
    private func changeButtonState(forIndex buttonIndex: Int) {
        // Make sure that card is one of the cardsInPlay
        if buttonIndex < cardsInPlay.count {
            let selectedCard = cardsInPlay[buttonIndex]
            // Ensure the card was not already selected
            if !selectedCards.contains(selectedCard) {
                // Add it to the selected cards array
                selectedCards.append(selectedCard)
                // Update the view to show it as selected
                cardButtons[buttonIndex].layer.borderWidth = Constants.selectedBorderWidth
                cardButtons[buttonIndex].layer.borderColor = Constants.selectedBorderColor
            } else {
                // If card was already selected, find its index in the selectedCards array and remove it
                let indexInSelectedCards = selectedCards.firstIndex(of: selectedCard)!
                selectedCards.remove(at: indexInSelectedCards)
                // then update the view to show that the card is now de-selected
                cardButtons[buttonIndex].layer.borderWidth = Constants.normalBorderWidth
                cardButtons[buttonIndex].layer.borderColor = Constants.normalBorderColor
            }
        } else {
            // The card that was clicked was not in play, so ignore the action
            print("The selected card was not in play (not in the cardsInPlay array)")
        }
    }
    
}
