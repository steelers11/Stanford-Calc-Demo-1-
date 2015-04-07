//
//  ViewController.swift
//  Lecture Calculator Demo
//
//  Created by Michael on 4/3/15.
//  Copyright (c) 2015 Michael. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    
    var isInMiddleOfTypingANumber = false
    
    var needsDecimal = true
    
    var historyArray = Array<String>()
    var historyEmpty = true
    
    // fuction to add a string to the history bar
    func addHistoryElement(element: String) {
        historyArray.append(element)
        historyLabel.text = historyLabel.text! + historyArray.last!
    }
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        historyArray.append(digit)
        
        if historyEmpty {
            historyLabel.text! = historyArray.last!
            historyEmpty = false
        } else {
            historyLabel.text = historyLabel.text! + historyArray.last!
            historyEmpty = false
        }
        
        println("History = \(historyArray)")
        
        if isInMiddleOfTypingANumber {
            display.text = display.text! + digit
        } else {
            display.text! = digit
            isInMiddleOfTypingANumber = true
            needsDecimal = true
        }
    }
    
        
    @IBAction func decimal(sender: UIButton) {
        let decimal = sender.currentTitle!
        addHistoryElement(decimal)
        println("Decimal = \(needsDecimal)")
        
        if needsDecimal {
            needsDecimal = false
            display.text = display.text! + decimal
        }
    }
    
    
    @IBAction func operation(sender: UIButton) {
        let operation = sender.currentTitle!
        addHistoryElement(operation)
        
        needsDecimal = false
        if isInMiddleOfTypingANumber {
            enter()
        }
        
        func performOperation(operation: (Double, Double) -> Double) {
            if operandStack.count >= 2 {
                needsDecimal = false
                displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
                enter()
            }
        }
        
         func performsOperation(operation: Double -> Double) {
            if operandStack.count >= 1 {
                needsDecimal = false
                displayValue = operation(operandStack.removeLast())
                enter()
            }
        }

        switch operation {
            case "x": performOperation{$1 * $0}
            case "÷": performOperation{$1 / $0}
            case "+": performOperation{$0 + $1}
            case "−": performOperation{$1 - $0}
            case "√": performsOperation{sqrt($0)}
            default: break
        }
           }
    // contains all number operators
    var operandStack = Array<Double>()
    
    @IBAction func enter() {
        isInMiddleOfTypingANumber = false
        operandStack.append(displayValue)
        
        addHistoryElement("⏎")
        // Debugging purposes
        println("Stack = \(operandStack)")
        println("Decimal = \(needsDecimal)")
    }
    
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text! = "\(newValue)"
            needsDecimal = false
            isInMiddleOfTypingANumber = false
        }
    }
    
    @IBOutlet weak var historyLabel: UILabel!
   
    @IBAction func clear() {
        display.text! = "0"
        isInMiddleOfTypingANumber = false
        
        historyLabel.text! = " "
        historyEmpty = true
    }
}
