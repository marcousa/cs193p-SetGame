//
//  ViewController.swift
//  SetGame
//
//  Created by Marco De Filippo on 10/8/18.
//  Copyright © 2018 Marco De Filippo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var selectedButtons = [UIButton]()
    
    private lazy var game = SetEngine()
    
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
        static let preferredFontSize: CGFloat = 25
    }
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setup the first 12 cards when the game starts
        for buttonIndex in 0...11 {
            game.draw()
            setInitialBorders(for: cardButtons[buttonIndex])
        }
        updateViewFromModel()
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
                        .font: UIFont.systemFont(ofSize: Constants.preferredFontSize)
                    ]
                case .solid:
                    attributes = [
                        .strokeWidth: -3,
                        .strokeColor: UIColor(red: colorComponents[0], green: colorComponents[1], blue: colorComponents[2], alpha: 1.0),
                        .foregroundColor: UIColor(red: colorComponents[0], green: colorComponents[1], blue: colorComponents[2], alpha: 1.0),
                        .font: UIFont.systemFont(ofSize: Constants.preferredFontSize)
                    ]
                case .outlined:
                    attributes = [
                        .strokeWidth: 3,
                        .strokeColor: UIColor(red: colorComponents[0], green: colorComponents[1], blue: colorComponents[2], alpha: 1.0),
                        .font: UIFont.systemFont(ofSize: Constants.preferredFontSize)
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
            game.chooseCard(at: buttonIndex)
            let button = cardButtons[buttonIndex]
            // change it to selected or de-selected
            if(selectedButtons.contains(cardButtons[buttonIndex])) {
                // de-select a button that was already selected
                button.layer.borderWidth = Constants.normalBorderWidth
                button.layer.borderColor = Constants.normalBorderColor
                // remove that button from the selectedButtonsArray
                selectedButtons.remove(at: selectedButtons.firstIndex(of: sender)!)
            } else {
                if(buttonIndex < game.cardsInPlay.count) {
                    // mark the button as selected
                    button.layer.borderWidth = Constants.selectedBorderWidth
                    button.layer.borderColor = Constants.selectedBorderColor
                    // add the button to the selectedButtonsArray
                    selectedButtons.append(button)
                }
            }
            
            if selectedButtons.count == 3 {
                game.checkForAMatch()
                selectedButtons.forEach() {
                    $0.layer.borderWidth = Constants.normalBorderWidth
                    $0.layer.borderColor = Constants.normalBorderColor
                }
                selectedButtons.removeAll()
                updateViewFromModel()
            }
            
        } else {
            print("Could not identify the selected card")
        }
    }
    
    private func setInitialBorders(for button: UIButton) {
        button.layer.borderWidth = Constants.normalBorderWidth
        button.layer.borderColor = Constants.normalBorderColor
        button.layer.cornerRadius = Constants.cornerRadius
    }
    
    private func markButtonAsSelectedOrDeSelected(forButtonAtIndex buttonIndex: Int) {
        let card = game.cardsInPlay[buttonIndex]
        let button = cardButtons[buttonIndex]
        
        if(game.selectedCards.contains(card)) {
            button.layer.borderWidth = Constants.selectedBorderWidth
            button.layer.borderColor = Constants.selectedBorderColor
        } else {
            button.layer.borderWidth = Constants.normalBorderWidth
            button.layer.borderColor = Constants.normalBorderColor
        }
        
    }
    
    private func updateViewFromModel() {
        for buttonIndex in cardButtons.indices {
            let button = cardButtons[buttonIndex]
            
            if buttonIndex < game.cardsInPlay.count {
                let card = game.cardsInPlay[buttonIndex]
                button.setAttributedTitle(make(card: card), for: .normal)
            } else {
                button.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
                button.setAttributedTitle(NSAttributedString(string: ""), for: .normal)
                button.layer.borderWidth = 0
            }
        }
        
//        for index in game.cardsInPlay.indices {
//            let card = game.cardsInPlay[index]
//            let button = cardButtons[index]
//            button.setAttributedTitle(make(card: card), for: .normal)
//        }
    }
    
}
