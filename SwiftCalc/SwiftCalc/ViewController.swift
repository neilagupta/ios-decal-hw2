//
//  ViewController.swift
//  SwiftCalc
//
//  Created by Zach Zeleznick on 9/20/16.
//  Copyright © 2016 zzeleznick. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // MARK: Width and Height of Screen for Layout
    var w: CGFloat!
    var h: CGFloat!
    

    // IMPORTANT: Do NOT modify the name or class of resultLabel.
    //            We will be using the result label to run autograded tests.
    // MARK: The label to display our calculations
    var resultLabel = UILabel()
    var lastResult : String?
    var operatorLastPressed: Bool = false
    var computationOccurred: Bool = false
    
    // TODO: This looks like a good place to add some data structures.
    //       One data structure is initialized below for reference.
    
    //Array version of resultStringLabel
    var resultStringData: [String] = [""]
    
    //Array version of the last operation
    var operationStringData: [String] = [""]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        w = view.bounds.size.width
        h = view.bounds.size.height
        navigationItem.title = "Calculator"
        // IMPORTANT: Do NOT modify the accessibilityValue of resultLabel.
        //            We will be using the result label to run autograded tests.
        resultLabel.accessibilityValue = "resultLabel"
        makeButtons()
        // Do any additional setup here.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // TODO: A method to update your data structure(s) would be nice.
    //       Modify this one or create your own.
    func updateSomeDataStructure(_ content: String) {
        print("Update me like one of those PCs")
    }
    
    // TODO: Ensure that resultLabel gets updated.
    //       Modify this one or create your own.
    func updateResultLabel(_ content: String) {
        print("Update me like one of those PCs")
        resultLabel.text = content
    }
    
    
    // TODO: A calculate method with no parameters, scary!
    //       Modify this one or create your own.
    func calculate() -> String {
        return "0"
    }
    
    // TODO: A simple calculate method for integers.
    //       Modify this one or create your own.
    func intCalculate(a: Int, b:Int, operation: String) -> Int {
        print("Calculation requested for \(a) \(operation) \(b)")
        let aInt : Int = Int(a)
        let bInt : Int = Int(b)
        
        if (operation == "+") {
            return aInt + bInt
        } else if (operation == "-") {
            return aInt - bInt
        } else if (operation == "/") {
            if (bInt == 0) {
                //TODO: Do alert
            }
            return aInt / bInt
        } else if (operation == "*") {
            return aInt * bInt
        }
        
        return 0
    }
    
    // TODO: A general calculate method for doubles
    //       Modify this one or create your own.
    func calculate(a: String, b:String, operation: String) -> Double {
        print("Calculation requested for \(a) \(operation) \(b)")
        let aDbl : Double = Double(a)!
        let bDbl : Double = Double(b)!
        
        if (operation == "+") {
            return aDbl + bDbl
        } else if (operation == "-") {
            return aDbl - bDbl
        } else if (operation == "/") {
            if (bDbl == 0.0) {
                //TODO: Do alert
                
            }
            return aDbl / bDbl
        } else if (operation == "*") {
            return aDbl * bDbl
        }
        
        return 0.0
    }
    
    // REQUIRED: The responder to a number button being pressed.
    func numberPressed(_ sender: CustomButton) {
        guard Int(sender.content) != nil else { return }
        print("The number \(sender.content) was pressed")
        if (computationOccurred == true) {
            computationOccurred = false
            clear(cPressed: true)
        }
        if (operatorLastPressed == true) {
            //If the last button pressed was an operator, then the next number should be a restart
            operatorLastPressed = false
            resultStringData.append(sender.content)
            updateResultLabel(sender.content)
        } else if (resultStringData.count < 8) {
            //Checks if number is possible to add to the display
            resultStringData.append(sender.content)
            if (resultLabel.text == "0") {
                //Resets text to another number
                updateResultLabel(sender.content)
            } else {
                //Adds the number to the end
                resultLabel.text!.append(sender.content)
            }
        }
    }
    
    // REQUIRED: The responder to an operator button being pressed.
    func operatorPressed(_ sender: CustomButton) {
        // Fill me in!
        if (sender.content == "C") {
            //Clears life
            clear(cPressed: true)
        }
        
        
        if (resultStringData.count < 7) {
            if (sender.content == "+/-") {
                var resultValue : Double = Double(resultLabel.text!)!
                resultValue = -resultValue
                updateResultLabel(String(format: resultValue == floor(resultValue) ? "%.0f" : "%.1f", resultValue))
            }
        }
        
        if (sender.content == "+" || sender.content == "-" || sender.content == "/" ||
            sender.content == "*" || sender.content == "=") {
            print("Operator pressed: " +  sender.content)
            operating(operatorValue: sender.content)
        }
        
    }
    
    func operating(operatorValue: String) {
        
        if (operationStringData.contains("+") == true || operationStringData.contains("-") == true ||
            operationStringData.contains("/") == true || operationStringData.contains("*") == true) {
            let num1 : String!
            let num2 : String!
            
            if (operatorLastPressed == true) {
                //If no new number has been inputted but the operator has been changed, then shift operators to the new one
                operationStringData[operationStringData.count - 1] = operatorValue
                return
            }
            
            //num1 should have been saved in the last item
            num1 = operationStringData[0..<operationStringData.count - 1].joined()
            num2 = resultLabel.text!
                
            let finalValue = calculate(a: num1, b: num2, operation: operationStringData[operationStringData.count - 1])
                
            
            lastResult = (String(finalValue))
            updateResultLabel(String(format: finalValue == floor(finalValue) ? "%.0f" : "%.1f", finalValue))
            
            if (operatorValue == "=") {
                operationStringData = [""]
                computationOccurred = true
            } else {
                operationStringData = lastResult!.components(separatedBy: "")
                operationStringData.append(operatorValue)
            }
            
            operatorLastPressed = true
            
        } else {
            if (operatorValue != "=") {
                //Adds the last number and operator to operationStringData
                if (computationOccurred == true) {
                    //If there was a computation last time, just modify that last computation
                    resultStringData = resultLabel.text!.components(separatedBy: "")
                }
                operationStringData += resultStringData
                operationStringData.append(operatorValue)
                operatorLastPressed = true
                computationOccurred = false
            }
            
        }
    }
    
    // REQUIRED: The responder to a number or operator button being pressed.
    func buttonPressed(_ sender: CustomButton) {
       // Fill me in!
        if (sender.content == "0") {
            if (resultLabel.text != "0") {
                //adds 0 to end of number
                resultLabel.text!.append(sender.content)
            }
        } else if (sender.content == ".") {
            if ((resultLabel.text!.contains(".") == false) && (resultStringData.count < 8)) {
                if (computationOccurred == true) {
                    computationOccurred = false
                    clear(cPressed: true)
                }
                if (operatorLastPressed == true) {
                    //If the last button pressed was an operator
                    operatorLastPressed = false
                    
                }
                resultLabel.text!.append(".")
                resultStringData.append(".")
                
            }
        }
    }
    
    //Clears everything, should make resultLabel cleared when C is pressed
    func clear(cPressed: Bool) {
        resultStringData = [""]
        operationStringData = [""]
        if (cPressed) {
            resultLabel.text = "0"
        }
        
    }
    
    // IMPORTANT: Do NOT change any of the code below.
    //            We will be using these buttons to run autograded tests.
    
    func makeButtons() {
        // MARK: Adds buttons
        let digits = (1..<10).map({
            return String($0)
        })
        let operators = ["/", "*", "-", "+", "="]
        let others = ["C", "+/-", "%"]
        let special = ["0", "."]
        
        let displayContainer = UIView()
        view.addUIElement(displayContainer, frame: CGRect(x: 0, y: 0, width: w, height: 160)) { element in
            guard let container = element as? UIView else { return }
            container.backgroundColor = UIColor.black
        }
        displayContainer.addUIElement(resultLabel, text: "0", frame: CGRect(x: 70, y: 70, width: w-70, height: 90)) {
            element in
            guard let label = element as? UILabel else { return }
            label.textColor = UIColor.white
            label.font = UIFont(name: label.font.fontName, size: 60)
            label.textAlignment = NSTextAlignment.right
        }
        
        let calcContainer = UIView()
        view.addUIElement(calcContainer, frame: CGRect(x: 0, y: 160, width: w, height: h-160)) { element in
            guard let container = element as? UIView else { return }
            container.backgroundColor = UIColor.black
        }

        let margin: CGFloat = 1.0
        let buttonWidth: CGFloat = w / 4.0
        let buttonHeight: CGFloat = 100.0
        
        // MARK: Top Row
        for (i, el) in others.enumerated() {
            let x = (CGFloat(i%3) + 1.0) * margin + (CGFloat(i%3) * buttonWidth)
            let y = (CGFloat(i/3) + 1.0) * margin + (CGFloat(i/3) * buttonHeight)
            calcContainer.addUIElement(CustomButton(content: el), text: el,
            frame: CGRect(x: x, y: y, width: buttonWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.addTarget(self, action: #selector(operatorPressed), for: .touchUpInside)
            }
        }
        // MARK: Second Row 3x3
        for (i, digit) in digits.enumerated() {
            let x = (CGFloat(i%3) + 1.0) * margin + (CGFloat(i%3) * buttonWidth)
            let y = (CGFloat(i/3) + 1.0) * margin + (CGFloat(i/3) * buttonHeight)
            calcContainer.addUIElement(CustomButton(content: digit), text: digit,
            frame: CGRect(x: x, y: y+101.0, width: buttonWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.addTarget(self, action: #selector(numberPressed), for: .touchUpInside)
            }
        }
        // MARK: Vertical Column of Operators
        for (i, el) in operators.enumerated() {
            let x = (CGFloat(3) + 1.0) * margin + (CGFloat(3) * buttonWidth)
            let y = (CGFloat(i) + 1.0) * margin + (CGFloat(i) * buttonHeight)
            calcContainer.addUIElement(CustomButton(content: el), text: el,
            frame: CGRect(x: x, y: y, width: buttonWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.backgroundColor = UIColor.orange
                button.setTitleColor(UIColor.white, for: .normal)
                button.addTarget(self, action: #selector(operatorPressed), for: .touchUpInside)
            }
        }
        // MARK: Last Row for big 0 and .
        for (i, el) in special.enumerated() {
            let myWidth = buttonWidth * (CGFloat((i+1)%2) + 1.0) + margin * (CGFloat((i+1)%2))
            let x = (CGFloat(2*i) + 1.0) * margin + buttonWidth * (CGFloat(i*2))
            calcContainer.addUIElement(CustomButton(content: el), text: el,
            frame: CGRect(x: x, y: 405, width: myWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
            }
        }
    }

}

