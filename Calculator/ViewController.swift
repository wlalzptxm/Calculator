//
//  ViewController.swift
//  Calculator
//
//  Created by Seunghoon Jeon on 21/08/2018.
//  Copyright © 2018 Seunghoon Jeon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var display: UILabel!
    
    private var userIsInTheMiddleOfTyping = false
    
    @IBAction private func touchDigit(_ sender: UIButton) {
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
    private var displayValue: Double {
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
    
    //保存と呼ぶことを作る
    var savedProgram: CalculatorBrain.PropertyList?
    
    @IBAction func save() {
        savedProgram = brain.program
    }
    
    @IBAction func restore() {
        if savedProgram != nil {
            brain.program = savedProgram!
            displayValue = brain.result
        }
    }
    
    
    //ModelのCalulatorBrainのControllerとして活用される変数
    private var brain = CalculatorBrain()
    
    @IBAction private func performOpertation(_ sender: UIButton) {
        //もし、使用者が数字を入力しているなら、その数字を計算機のoperandでsetしてくれる、例えば、235かいて、ルート'√'をするなら、235をoperandの中に入れておくようになる。
        if userIsInTheMiddleOfTyping {
            brain.setOperand(operand: displayValue)
            userIsInTheMiddleOfTyping = false
        }
        //senderを通じて数字が入ってくると、mathematicalSymbolを通じて演算をして
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(symbol : mathematicalSymbol)
        }
        //演算が終わったらdisplayValueにここにいるresultの結果の値を入れることになる
        displayValue = brain.result
    }
}

