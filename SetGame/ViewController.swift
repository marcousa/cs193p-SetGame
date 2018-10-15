//
//  ViewController.swift
//  SetGame
//
//  Created by Marco De Filippo on 10/8/18.
//  Copyright © 2018 Marco De Filippo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var selectedButtons = [UIButton]() {
        didSet {
            if(selectedButtons.count == 3) {
                if(game.checkForAMatch()) {
                    selectedButtons.forEach() { $0.layer.borderColor = Constants.matcheddBorderColor }
                    // If 3 cards have been matched, the drawing button should be reset to active
                    disableDrawButtonIfNeeded()
                } else {
                    selectedButtons.forEach() { $0.layer.borderColor = Constants.unmatchedBorderColor }
                }
            }
        }
    }
    
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
        static let matchedBorderWidth: CGFloat = 3.0
        static let matcheddBorderColor = UIColor.green.cgColor
        static let unmatchedBorderWidth: CGFloat = 3.0
        static let unmatchedBorderColor = UIColor.red.cgColor
        static let normalBorderWidth: CGFloat = 1.0
        static let normalBorderColor = UIColor.black.cgColor
        static let cornerRadius: CGFloat = 8.0
        static let preferredFontSize: CGFloat = 25
        static let initialCards = 12
    }
    
    @IBOutlet private var cardButtons: [UIButton]!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var drawButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setup the first 12 cards when the game starts
        for _ in 1...Constants.initialCards {
            game.draw()
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
        
        // regardless of whether there's a match or not, reset the buttons as not selected
        if(selectedButtons.count > 0) {
            selectedButtons.forEach() { resetBorders(forButton: $0) }
            selectedButtons.removeAll()
            game.resetSelectedCards()
        }
        
        for _ in 0...2 {
            if(game.cards.count > 0 && game.cardsInPlay.count < 24) {
                game.draw()
                // If the deck has run out of cards then disable the draw button
                disableDrawButtonIfNeeded()
            }
        }
        
        updateViewFromModel()
    }
    
    private func selectOrDeSelectButton(atIndex buttonIndex: Int) {
        let button = cardButtons[buttonIndex]
        // If the button you clicked on is already selected, show it as de-selected
        // and remove it from teh selectedbuttons array. Otherwise select it and add it
        if selectedButtons.contains(button) {
            button.layer.borderWidth = Constants.normalBorderWidth
            button.layer.borderColor = Constants.normalBorderColor
            selectedButtons.remove(at: selectedButtons.firstIndex(of: button)!)
        } else {
            button.layer.borderWidth = Constants.selectedBorderWidth
            button.layer.borderColor = Constants.selectedBorderColor
            selectedButtons.append(button)
        }
    }
    
    private func resetBorders(forButton button: UIButton) {
        button.layer.borderColor = Constants.normalBorderColor
        button.layer.borderWidth = Constants.normalBorderWidth
    }
    
    private func redrawButtonBorders() {
        for buttonIndex in game.cardsInPlay.indices {
            let button = cardButtons[buttonIndex]
            resetBorders(forButton: button)
        }
    }

    @IBAction private func touchCard(_ sender: UIButton) {
        // figure out the button that was selected
        if let buttonIndex = cardButtons.firstIndex(of: sender) {
            // if there are less than 3 cards selected, then select it
            if(selectedButtons.count < 3) {
                if(buttonIndex < game.cardsInPlay.count) {
                    // mark the card shown on the button as selected or unselected
                    game.chooseCard(at: buttonIndex)
                    selectOrDeSelectButton(atIndex: buttonIndex)
                } else {
                    print("Selected card not in play")
                }
                
            } else {
                // deselect all the cards
                redrawButtonBorders()
                selectedButtons.removeAll()
                updateViewFromModel()
                touchCard(sender)
            }
        } else {
            // a button outside the playable range was selected
            print("Could not identify selected card")
        }
    }
    
    private func disableDrawButtonIfNeeded() {
        // if the screen is full of cards, or there are no more cards in the deck disable the draw button
        if(game.cardsInPlay.count == 24 || game.cards.count == 0) {
            drawButton.isEnabled = false
        } else {
            drawButton.isEnabled = true
        }
    }
    
    
    @IBAction func newGameTouched(_ sender: UIButton) {
        resetGame()
    }
    
    private func resetGame() {
        game.resetGame()
        viewDidLoad()
    }
    
    private func updateViewFromModel() {
        for buttonIndex in cardButtons.indices {
            let button = cardButtons[buttonIndex]
            // if the button is beyond the range of the cards in play, make it transparent
            // otherwise set it as the drawn card
            if buttonIndex < game.cardsInPlay.count {
                let card = game.cardsInPlay[buttonIndex]
                button.setAttributedTitle(make(card: card), for: .normal)
                button.layer.borderWidth = Constants.normalBorderWidth
                button.layer.borderColor = Constants.normalBorderColor
                button.layer.cornerRadius = Constants.cornerRadius
            } else {
                button.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
                button.setAttributedTitle(NSAttributedString(string: ""), for: .normal)
                button.layer.borderWidth = 0
            }
        }
        // Figure out if the draw button should be enabled or disabled
        disableDrawButtonIfNeeded()
        scoreLabel.text = "Score: \(game.score)"
    }
    
}
