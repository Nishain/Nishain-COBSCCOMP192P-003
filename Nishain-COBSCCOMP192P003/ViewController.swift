//
//  ViewController.swift
//  Nishain-COBSCCOMP192P003
//
//  Created by Nishain on 2/3/21.
//  Copyright © 2021 Nishain. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UITextField!
    @IBOutlet weak var buttonGrid: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        /*first we have to transverse between stackview and find the revlant
         buttons and assign click event target and set callback for callback for each
         button click event as onbuttonClicked**/
        for row in buttonGrid.subviews{
            for button in row.subviews{
                if(button is UIStackView){
                    for b in button.subviews{
                        (b as? UIButton)?.addTarget(self, action: #selector(onbuttonClicked(button:)), for: .touchUpInside)
                    }
                }else{
                    (button as? UIButton)?.addTarget(self, action: #selector(onbuttonClicked(button:)), for: .touchUpInside)
                }
            }
        }
    }
    @objc func onbuttonClicked(button:UIButton){
        //identify which button pressed by the visible title of the button
        let whatButton:String = button.titleLabel!.text!
        
        //if the display showing infinite then reset the display to 0
        if(display!.text == "infinite"){
            display.text = "0"
        }
        let displayText = display!.text!
        switch whatButton {
        case "="://getting the answer
            let evaluatedExpression = displayText
                .replacingOccurrences(of: "x", with: "*") //replacing natural multiply sign with * sign
                .replacingOccurrences(of: "/", with: "/1.0/")//when dividing we need to convert interger to float to get decimal values so we divide the numerator with 1.0
                .replacingOccurrences(of: "%", with: "/100.0")//getting the value as percentage by dividing by 100
            let answer = NSExpression(format:evaluatedExpression).expressionValue(with: nil, context: nil) as! NSNumber
            //replacing default inf with friendly "infinite"
            display.text = answer.stringValue == "inf" ? "infinite" : answer.stringValue
        case "AC": //clear button
            display.text = "0"
        case "+/-"://swapping sign between + and -
            //we need start check from tail side of display text
            let reverseForm = displayText.reversed()
            //check if last user entered character is %
            var shouldSkipPercentage = reverseForm.first == "%"
            for c in reverseForm{
                
                if(!c.isNumber && c != "." && !shouldSkipPercentage){
                    let index = displayText.lastIndex(of: c)!//getting the index of last/recent operator character
                    
                    if(c=="+"){//if + then swap to -
                        display.text?.remove(at: index)
                        display.text?.insert("-", at: index)
                        return
                    }else if(c=="-"){
                        //removing the - sign
                        display.text?.remove(at:index)
                        //the index is not first index and the character before
                        //the sign is number then insert + sign
                        if(index != displayText.startIndex && displayText[displayText.index(before: index)].isNumber){
                            display.text?.insert("+", at: index)
                        }
                        //make sure to terminate after swapping
                        return
                    }else{
                        display.text?.insert("-",at:displayText.index(after: index))
                        return
                    }
                }else if(shouldSkipPercentage){
                    shouldSkipPercentage = false
                }
            }
            //if there are no symbol and only number in the screen then convert to negative by preappending with -
            display.text = "-\(displayText)"
        default:
            var printCharacter:String
            if(whatButton=="÷"){//replace divide symbol with /
                printCharacter = "/"
            }else{
                printCharacter = whatButton
            }
            //if the display only showing 0 then user only allow to enter numbers
            //to ensure the expression cannot start with operator
            if((displayText == "0") && printCharacter.first!.isNumber){
                display.text = printCharacter
            }
            //concadenate the the title of pressed button with the text in display
            else{
                //validate if the user modifying the expression correctly without any errors
                if(validate(a:displayText.last!,b:printCharacter.first!)){
                    display.text! += printCharacter
                }
            }
        }
    }
    
    var periodAlreadyAdded = false
    func validate(a: Character,b:Character) -> Bool{
        
        if(a == "%"){
            //if the previous character is % the user is only allowed to whitlisted opedijiorators afterwards
            if("+-x/".contains(b)){
                return true
            }else{
                return false
            }
        }
        if(b=="-"){
            //user can only add - operator if previous character is number or muliply,divide operator
            if(a.isNumber || "x/".contains(a)){
                return true
            }else{
                return false
            }
        }
        //user cannot add an operator more than once in a row
        if(!a.isNumber && !b.isNumber){
            return false
        }
        if(b=="."){
            //user is prohibited add period more than once for same number if it is already added
            if(periodAlreadyAdded){
                return false
            }
            periodAlreadyAdded = true
        }else if(!b.isNumber){
            //mark this as the end of the number user can now add a decimal later
            periodAlreadyAdded = false
        }
        return true
    }
}

