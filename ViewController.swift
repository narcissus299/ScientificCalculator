//
//  ViewController.swift
//  Calculator
//
//  Created by Krishak Choukhany on 07/12/15.
//  Copyright © 2015 Krishak Choukhany. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    
    var startedTyping = false //User is in the middle of typing
    var addedDecimalPoint = false // User has added decimal point
    
    var calculator = CalculatorModel()
    
    var displayValue:Double {
        get{
            return Double(display.text!)!
        }
        set{
            display.text = "\(newValue)"
        }
    }
    
    private func reset(){
        startedTyping = false
        addedDecimalPoint = false
    }
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        
        switch digit{
        case ".":
            if !addedDecimalPoint{
                display.text = display.text! + digit
                addedDecimalPoint = true
                startedTyping = true
    
            }
        default :
            if startedTyping {
                display.text = display.text! + digit
            }
            else {
                display.text = digit
                startedTyping = true
            }
        }
    
    }
    
    @IBAction func enter() {
        calculator.pushOperand(displayValue)
        reset()
        displayValue = calculator.evaluate()!
    }

    @IBAction func eval(sender: UIButton) {
        calculator.performOperation(sender.currentTitle!)
        displayValue = calculator.evaluate()!
    }
    
    @IBAction func variable(sender: UIButton) {
        calculator.pushVariable(sender.currentTitle!)
    }
    
    @IBAction func clear() {
        calculator.clear()
        reset()
        display.text = "0"
    }
    
}

