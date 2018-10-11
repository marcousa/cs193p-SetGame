//
//  File.swift
//  SetGame
//
//  Created by Marco De Filippo on 10/8/18.
//  Copyright © 2018 Marco De Filippo. All rights reserved.
//

import Foundation

struct SetCard: CustomStringConvertible, Equatable
{
    var description: String {
        return "\(number) \(shading) \(color) \(number.rawValue == 1 ? "item" : "items") of \(shape)"
    }
    
    let shape: Shape
    let color: Color
    let number: Number
    let shading: Shading
    
    static func ==(lhs: SetCard, rhs: SetCard) -> Bool {
        return  lhs.shape == rhs.shape &&
                lhs.color == rhs.color &&
                lhs.number == rhs.number &&
                lhs.shading == rhs.shading
    }
    
    static func cardsAreASet(first: SetCard, second: SetCard, third: SetCard) -> Bool {
        // Either everything is different OR one of the 4 attributes is consistant across the 3 cards
        if(
            (first.shape != second.shape && first.shape != third.shape) &&
            (first.color != second.color && first.color != third.color) &&
            (first.number != second.number && first.number != third.number) &&
            (first.shading != second.shading && first.shading != third.shading)
            ) {
            return true
        } else if(
            (first.shape == second.shape && first.shape == third.shape) ||
                (first.color == second.color && first.color == third.color) ||
                (first.number == second.number && first.number == third.number) ||
                (first.shading == second.shading && first.shading == third.shading)
            ) {
            return true
        } else {
            return false
        }        
    }
    
    enum Shape: Int, CustomStringConvertible {
        var description: String { return "shape: \(self.rawValue)" }
        
        case shapeOne = 0
        case shapeTwo = 1
        case shapeThree = 2
        
        static var all: [Shape] = [.shapeOne, .shapeTwo, .shapeThree]
        
    }
    
    enum Color: Int, CustomStringConvertible {
        var description: String { return "color: \(self.rawValue)" }
        
        case a = 0
        case b = 1
        case c = 2
        
        static var all: [Color] = [.a, .b, .c]
    }
    
    enum Number: Int, CustomStringConvertible {
        var description: String { return "\(self.rawValue)" }
        
        case one = 1
        case two = 2
        case three = 3
        
        static var all: [Number] = [.one, .two, .three]
    }
    
    enum Shading: String,CustomStringConvertible {
        var description: String { return "\(self.rawValue)" }
        
        case solid
        case striped
        case outlined
        
        static var all: [Shading] = [.solid, .striped, .outlined]
    }
    
}
