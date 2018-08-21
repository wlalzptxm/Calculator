//
//  ViewController.swift
//  Calculator
//
//  Created by Seunghoon Jeon on 21/08/2018.
//  Copyright © 2018 Seunghoon Jeon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleOfTyping = false
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textCurrnetlyInDisplay = display.text!
            display.text = textCurrnetlyInDisplay + digit
        }else {
            display.text = digit
        }
        userIsInTheMiddleOfTyping = true
    }
    
    //計算 プロパティ
    var displayValue: Double {
        //getはdisplayValueに含まれている値を呼び出すために設定
        get {
            //呼び出される時Doubleに返還しなければならないから、再びcasting、また、タイプ変換ができない可能性もあることによりoptionalタイプで、再び全体をunwrappingしなければならない
            //つまり、displayValueに入ってくるString値をDoubleに返すための計算プロパティ
            return Double(display.text!)!
        }
        //setは誰かがこの変数の値を設定しようとする時に実行されるコードになる
        set {
            //displayValueに使われる新しいDouble値をStringに設定するための計算プロパティ
            //もっと易しく言えば、Double-(使おうとする値)-Stringに自動に変換してくれる計算プロパティ
            display.text = String(newValue)
        }
        
    }
    
    @IBAction func performOpertation(_ sender: UIButton) {
        userIsInTheMiddleOfTyping = false
        if let mathematicalSymbol = sender.currentTitle {
            if mathematicalSymbol == "π" {
                //この場合、displayに使われるようになるDoubleタイプのπ値が自動にStringとtypecastingなる
                displayValue = Double.pi
            } else if mathematicalSymbol == "√" {
                displayValue = sqrt(displayValue)
            }
        }
    }
    
    
}

