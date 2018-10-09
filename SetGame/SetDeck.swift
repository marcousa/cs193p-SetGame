//
//  SetDeck.swift
//  SetGame
//
//  Created by Marco De Filippo on 10/8/18.
//  Copyright © 2018 Marco De Filippo. All rights reserved.
//

import Foundation

struct SetDeck
{
    private(set) var cards = [SetCard]()
    
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
    }
    
    mutating func draw() -> SetCard? {
        if cards.count > 0 {
            return cards.remove(at: cards.count.arc4random)
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
