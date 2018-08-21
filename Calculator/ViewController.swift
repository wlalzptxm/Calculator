//
//  ViewController.swift
//  Calculator
//
//  Created by Seunghoon Jeon on 21/08/2018.
//  Copyright © 2018 Seunghoon Jeon. All rights reserved.
//

//UIKitにはButton、TextFieldのような基本的なすべてのUIが入っている
import UIKit

class ViewController: UIViewController {
    
    //optionalはnotsetの状態でいつも初期化される
    @IBOutlet weak var display: UILabel!
    
    // 一般propertyは、初期化が必要してswiftはタイプを推論するために:Boolは省略可能である
    var userIsInTheMiddleOfTyping = false
    
    //アンダーバーを使用してexternal名前を省略することができる
    @IBAction func touchDigit(_ sender: UIButton) {
        //letを使用するとき二つの理由がある。
        //1. コードを読む人たちに絶対に変わるはずないと明示してくれる
        //2. ArrayやDictionaryにletを使用するなら、どの値も追加で入ったり、取り出したりすることができないということを意味する(読みだけに可能なものとつくる方法の一つ)
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textCurrnetlyInDisplay = display.text!
            display.text = textCurrnetlyInDisplay + digit
        }else {
            display.text = digit
        }
        userIsInTheMiddleOfTyping = true
    }
    
    @IBAction func performOpertation(_ sender: UIButton) {
        userIsInTheMiddleOfTyping = false
        if let mathematicalSymbol = sender.currentTitle {
            if mathematicalSymbol == "π" {
                //displayはdoubleタイプが受けられないため、Stringでcasting
                display.text = String(Double.pi)
            }
        }
    }
}

