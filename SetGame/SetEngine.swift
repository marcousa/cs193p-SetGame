//
//  SetEngine.swift
//  SetGame
//
//  Created by Marco De Filippo on 10/10/18.
//  Copyright © 2018 Marco De Filippo. All rights reserved.
//

import Foundation

struct SetEngine {
    
    private(set) var cards = [SetCard]()
    private(set) var selectedCards = [SetCard]()
    private(set) var matchedCards = [SetCard]()
    private(set) var cardsInPlay = [SetCard]()
    
    init() {
        for shape in SetCard.Shape.all {
            for color in SetCard.Color.all {
                for number in SetCard.Number.all {
                    for shading in SetCard.Shading.all {
                        cards.append(SetCard.init(shape: shape, color: color, number: number, shading: shading))
                    }
                }
            }
        }
        cards.shuffle()
    }
    
    mutating func draw() -> SetCard? {
        if cards.count > 0 {
            let cardDrawn = cards.remove(at: cards.count.arc4random)
            cardsInPlay.append(cardDrawn)
            return cardDrawn
        } else {
            return nil
        }
    }
    
    // Function will select a card and return it so that the view can mark it as selected or de-selected
   mutating func chooseCard(at buttonIndex: Int) {
        // Make sure the selected card is one of the cardsInPlay
        if buttonIndex < cardsInPlay.count {
            let selectedCard = cardsInPlay[buttonIndex]
            // Ensure the card was not already selected
            if !selectedCards.contains(selectedCard) {
                // Add it to the selected cards array
                selectedCards.append(selectedCard)
                // if 3 cards are now selected, check for a match
                if(selectedCards.count == 3) {
                    checkForAMatch()
                }
            } else {
                //If card was already selected, find its index and remove it from selectedCards
                let indexInSelectedCards = selectedCards.firstIndex(of: selectedCard)!
                selectedCards.remove(at: indexInSelectedCards)
            }
        } else {
            print("The selected card was not in play (not in the cardsInPlay array)")
        }
    }
 
    mutating func checkForAMatch() {
        print("Called checkForAMatch()")
    }
    
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}


