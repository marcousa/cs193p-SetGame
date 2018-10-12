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
    
    mutating func draw() {
        if cards.count > 0 {
            let cardDrawn = cards.remove(at: cards.count.arc4random)
            cardsInPlay.append(cardDrawn)
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
                    print("3 cards have been selected")
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
        // Check for a Set
        // if they match, remove them from selectedCards and cardsInPlay Arrays and add to matchedCardsArray
        if(cardsAreASet(first: selectedCards[0], second: selectedCards[1], third: selectedCards[2])) {
            while(selectedCards.first != nil) {
                let card = selectedCards.first!
                // find the index of that card in cardsInPlay and remove it
                if let indexInCardsInPlay = cardsInPlay.firstIndex(of: card) {
                    cardsInPlay.remove(at: indexInCardsInPlay)
                }
                // remove the card from the selectedCards array
                selectedCards.removeFirst()
                // add the card to the matchedCards array
                matchedCards.append(card)
            }
        } else {
            // if they don't match, remove them from the selectedCards Array
            selectedCards.removeAll()
        }
        
        
    }
    
    private func cardsAreASet(first: SetCard, second: SetCard, third: SetCard) -> Bool {
        // Either everything is different OR one of the 4 attributes is consistant across the 3 cards
        if(
            (first.shape != second.shape && first.shape != third.shape) &&
                (first.color != second.color && first.color != third.color) &&
                (first.number != second.number && first.number != third.number) &&
                (first.shading != second.shading && first.shading != third.shading)
            ) {
            print("Cards were a Set!")
            return true
        } else if(
            (first.shape == second.shape && first.shape == third.shape) ||
                (first.color == second.color && first.color == third.color) ||
                (first.number == second.number && first.number == third.number) ||
                (first.shading == second.shading && first.shading == third.shading)
            ) {
            print("Cards were a Set!")
            return true
        } else {
            print("Cards were NOT a set")
            return false
        }
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


