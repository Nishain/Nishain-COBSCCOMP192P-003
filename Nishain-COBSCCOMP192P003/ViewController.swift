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
        let whatButton:String = button.titleLabel!.text!
        let displayText = display!.text!
        if(whatButton=="="){
            
            let answer = NSExpression(format: displayText.replacingOccurrences(of: "x", with: "*").replacingOccurrences(of: "/", with: "/1.0/").replacingOccurrences(of: "%", with: "/100.0")).expressionValue(with: nil, context: nil) as! NSNumber
            display.text = answer.stringValue
        }else if(whatButton=="AC"){
            display.text = ""
        }
        else{
            var printCharacter:String
            if(whatButton=="÷"){
                printCharacter = "/"
            }else{
                printCharacter = whatButton
            }
            
            if(displayText.count==0 || displayText == "0"){
                if(printCharacter.first!.isNumber){
                    display.text = printCharacter
                }
            }else if(whatButton=="+/-"){
                //for(i in displayText)
                
                var count = displayText.count - 1
                let reverseForm = displayText.reversed()
                for c in reverseForm{
                    print("outer - \(c)")
                    if(!c.isNumber && c != "."){
                        let index = displayText.lastIndex(of: c)!
                        print(c)
                        if(c=="+"){
                            display.text?.remove(at: index)
                            display.text?.insert("-", at: index)
                            return
                        }else if(c=="-"){
                            
                            display.text?.remove(at:index)
                        
                            if(index != displayText.startIndex && displayText[displayText.index(before: index)].isNumber){
                                    display.text?.insert("+", at: index)
                            }
                        
                            return
                        }else{
                            display.text?.insert("-",at:displayText.index(after: index))
                            return
                        }
                    }
                    
                    count -= 1
                }
                display.text = "-\(displayText)"
            }
            else{
                if(validate(a:displayText.last!,b:printCharacter.first!)){
                    display.text! += printCharacter
                }
                
            }
                
        }
    }
    
    func validate(a: Character,b:Character) -> Bool{
        if(a.isNumber && b == "%"){
            return true
        }
        if(a.isSymbol && b.isSymbol){
            return false
        }
        return true
    }
}

