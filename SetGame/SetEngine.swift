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
    private(set) var score = 0
    private(set) var availableSets: [[SetCard]] = []
    
    private struct Constants {
        static let scoreForSet = 3
        static let penaltyForNonSet = 5
        static let penaltyForDrawingWhenSetIsAvailable = 1
    }
    
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
    
    // Use a different function to setup the game rather than just drawing
    // since the draw function now penalizes the user if there are sets available
    mutating func setupGame() {
        for _ in 0...11 {
            let cardDrawn = cards.remove(at: cards.count.arc4random)
            cardsInPlay.append(cardDrawn)
        }
    }
    
    mutating func draw() {
        if cards.count > 0 {
            // penalize the user if there is at least 1 set in the cards currently on the table
            if(determineSetsOnTable() > 0) {
                score -= Constants.penaltyForDrawingWhenSetIsAvailable
            }
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
            } else {
                //If card was already selected, find its index and remove it from selectedCards
                let indexInSelectedCards = selectedCards.firstIndex(of: selectedCard)!
                selectedCards.remove(at: indexInSelectedCards)
            }
        } else {
            print("The selected card was not in play (not in the cardsInPlay array)")
        }
    }
    
    mutating func resetSelectedCards() {
        selectedCards.removeAll()
    }
 
    mutating func checkForAMatch() -> Bool {
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
            score += Constants.scoreForSet
            return true
        } else {
            // if they don't match, remove them from the selectedCards Array
            selectedCards.removeAll()
            score -= Constants.penaltyForNonSet
            return false
        }
    }
    
    private func cardsAreASet(first: SetCard, second: SetCard, third: SetCard) -> Bool {
        let cardsToMatch = [first, second, third]
        var colorSet = Set<SetCard.Color>()
        var numberSet = Set<SetCard.Number>()
        var shadeSet = Set<SetCard.Shading>()
        var shapeSet = Set<SetCard.Shape>()
        
        // Populate each set with the attributes for each card
        // THe item will only be inserted if that value is not already in the set
        for card in cardsToMatch {
            colorSet.insert(card.color)
            numberSet.insert(card.number)
            shadeSet.insert(card.shading)
            shapeSet.insert(card.shape)
        }
        
        // Either cards are completely different (3 for each set) or the same in all aspects except for one (1 for 1 Set and 3 for the rest)
        return colorSet.count != 2 && numberSet.count != 2 && shadeSet.count != 2 && shapeSet.count != 2
    }
    
    mutating func resetGame() {
        score = 0
        selectedCards.removeAll()
        cards.append(contentsOf: matchedCards)
        cards.append(contentsOf: cardsInPlay)
        cards.shuffle()
        matchedCards.removeAll()
        cardsInPlay.removeAll()
    }
    
    private mutating func determineSetsOnTable() -> Int {
        availableSets.removeAll()
        
        for firstCardIndex in 0..<cardsInPlay.count {
            for secondCardIndex in (firstCardIndex + 1)..<cardsInPlay.count {
                for thirdCardIndex in (secondCardIndex + 1)..<cardsInPlay.count {
                    let firstCard = cardsInPlay[firstCardIndex]
                    let secondCard = cardsInPlay[secondCardIndex]
                    let thirdCard = cardsInPlay[thirdCardIndex]
                    if(cardsAreASet(first: firstCard, second: secondCard, third: thirdCard)) {
                        availableSets.append([firstCard, secondCard, thirdCard])
                    }
                }
            }
        }
        
        return availableSets.count
    }
    
    mutating func getIndexOfFirstAvailableSet() -> [Int]? {
        let possibleSets = determineSetsOnTable()
        
        if possibleSets > 0 {
            let firstSet = availableSets.first!
            let firstCard = cardsInPlay.firstIndex(of: firstSet[0])
            let secondCard = cardsInPlay.firstIndex(of: firstSet[1])
            let thirdCard = cardsInPlay.firstIndex(of: firstSet[2])
            
            if  let firstIndex = firstCard,
                let secondIndex = secondCard,
                let thirdIndex = thirdCard {
                    return [firstIndex, secondIndex, thirdIndex]
            } else {
                return nil
            }
        } else {
            return nil
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


