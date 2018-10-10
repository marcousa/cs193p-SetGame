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
        
    }
    
    @IBAction private func drawThreeCards(_ sender: UIButton) {
        for button in 0...2 {
            if let card = deck.draw() {
                print(card)
                
                if let colorComponents = colors[card.color.rawValue] {
                    
                    var attributes = [NSAttributedString.Key:Any]()
                    
                    switch card.shading {
                    case .striped:
                        attributes = [
                            .foregroundColor: UIColor(red: colorComponents[0], green: colorComponents[1], blue: colorComponents[2], alpha: 0.15),
                            .strokeWidth: -3,
                            .font: UIFont.systemFont(ofSize: 25)
                        ]
                    case .solid:
                        attributes = [
                            .strokeWidth: -3,
                            .strokeColor: UIColor(red: colorComponents[0], green: colorComponents[1], blue: colorComponents[2], alpha: 1.0),
                            .foregroundColor: UIColor(red: colorComponents[0], green: colorComponents[1], blue: colorComponents[2], alpha: 1.0),
                            .font: UIFont.systemFont(ofSize: 25)
                        ]
                    case .outlined:
                        attributes = [
                            .strokeWidth: 3,
                            .strokeColor: UIColor(red: colorComponents[0], green: colorComponents[1], blue: colorComponents[2], alpha: 1.0),
                            .font: UIFont.systemFont(ofSize: 25)
                        ]
                    }
                    
                    let shape = shapes[card.shape.rawValue]
                    var shapeText = ""
                    
                    for _ in 1...card.number.rawValue {
                        shapeText += shape ?? ""
                    }
                    
                    let attributedString = NSAttributedString(string: shapeText, attributes: attributes)
                    
                    cardButtons[button].setAttributedTitle(attributedString, for: .normal)
                    
                }
                
                
                
            } else {
                print("No more cards!")
            }
        }
    }
    


}
