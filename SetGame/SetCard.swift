//
//  File.swift
//  SetGame
//
//  Created by Marco De Filippo on 10/8/18.
//  Copyright © 2018 Marco De Filippo. All rights reserved.
//

import Foundation

struct SetCard: CustomStringConvertible
{
    var description: String {
        return "\(number) \(shading) \(color) \(number.rawValue == 1 ? shape.rawValue : shape.rawValue + "s")"
    }
    
    var shape: Shape
    var color: Color
    var number: Number
    var shading: Shading
    
    enum Shape: String, CustomStringConvertible {
        var description: String { return self.rawValue }
        
        case oval = "oval"
        case squiggle = "squiggle"
        case diamond = "diamond"
        
        static var all: [Shape] = [.oval, .squiggle, .diamond]
        
    }
    
    enum Color: String, CustomStringConvertible {
        var description: String { return "\(self.rawValue)" }
        
        case red
        case purple
        case green
        
        static var all: [Color] = [.red, .purple, .green]
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
