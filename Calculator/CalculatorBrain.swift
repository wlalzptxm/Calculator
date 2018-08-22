//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Seunghoon Jeon on 21/08/2018.
//  Copyright © 2018 Seunghoon Jeon. All rights reserved.
//

import Foundation


class CalculatorBrain
{
    private var accumulator = 0.0
    private var internalProgram = [AnyObject]()
    
    func setOperand(operand: Double) {
        accumulator = operand
        internalProgram.append(operand as AnyObject)
    }
    
    //Dictionaryで何らかの種類のボタンが来てもどんな種類の演算かだけを定義することができたら
    private var operations: Dictionary<String, Operation> = [
        "π" : Operation.Constant(Double.pi),
        "e" : Operation.Constant(M_E),
        "√" : Operation.UnaryOperation(sqrt),
        "cos" : Operation.UnaryOperation(cos),
        //二項演算だけに演算メソッドを別々にしてるのはxを押された時点で演算ができる情報が不足するためだ。
        //クローザーはインライン関数(関数呼び出しなくその位置ですぐ実行される関数)環境状態をキャプチャーするインライン関数と見ることができる
        //クローザーは基本値入力因子とタイプ推論を通じてこんな風に減らして使用することもできる。
        "×" : Operation.BinaryOperation({ $0 * $1 }),
        "÷" : Operation.BinaryOperation({ $0 / $1 }),
        "+" : Operation.BinaryOperation({ $0 + $1 }),
        "-" : Operation.BinaryOperation({ $0 - $1 }),
        "=" : Operation.Equals
    ]
    
    //こんなふうにenumはジェノリクタイプとしてどのようなタイプでも来られるから
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double,Double) -> Double)
        case Equals
    }
    
    //もしperformOperationを呼び出すことになれば、Dictionary、enumの属性を持ったfuncを持つようになって
    //(func(Dictionary(enum)))と一緒に包括する形式の構造になる
    
    //ここで。Constantとも言える理由も上のDictionary、enumの属性を持っていると、swiftが推論できるからだ
    //つまり、Dictionaryの中にあるのではなく値を持ってきた状態だということだ
    
    //そうなら、どういう値をもたらすことができるのか? optionalは関連値を持っており、optionalがenumであるため、swiftが値を推論してもたらすことが可能になる
    
    //enum Optional<T> {
    //    case None
    //    case Some(T)
    //}
    
    //もうenumとDictionaryにタイプが指定されたため、()中に変数を入れ、関連値を除いて来られることができる
    
    func performOperation(symbol: String) {
        internalProgram.append(symbol as AnyObject)
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value) :
                accumulator = value
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
                // = を押える時にpending、つまり4×()の括弧の中に数字がなければ、当然、演算ができないのでpending=nilを与えてcrashを作く理だし
            // 空いてまま、数字があるなら、最初の数字を持っていたfirstOperandと　× の次に来る、accumulatorとともに4x5の等式を作って演算されるようにしている
            case .Equals:
                executePendingBinaryOperation()
            }
            
        }
    }
    
    private func executePendingBinaryOperation(){
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    private var pending : PendingBinaryOperationInfo?
    
    //classとstructの最も大きな違いは、structは'値'が伝わることと、classは'値のアドレス'が伝わる点だ
    //そして値が伝わるというのは'コピー'出来ることで、swiftはコピーされた時たけ、実質的にコピーすることでメモリの心配はする必要がない
    //また、コピーされているというのは原本とコピーされたことつまり、異なる2つになるということで、これは原本に変化を与えてもコピーには、まったく変化がないということを意味することもある
    
    //構造体はクラス(()のような)と別に自動生成される初期化関数が構造体の中にあるすべての変数を入力因子として持つことになる、
    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    //typealiasはタイプを作ることができるように手伝ってくれる
    typealias PropertyList = AnyObject
    
    //作られたPropertyListタイプを演算プロパティで作って活用する
    var program: PropertyList {
        get {
            return internalProgram as CalculatorBrain.PropertyList
        }
        set {
            clear()
            if let arrayOfOps = newValue as? [AnyObject] {
                for op in arrayOfOps {
                    if let operand = op as? Double {
                        setOperand(operand: operand)
                    }else if let operation = op as? String {
                        performOperation(symbol: operation)
                    }
                }
            }
        }
    }
    
    func clear() {
        accumulator = 0.0
        pending = nil
        internalProgram.removeAll()
    }
    
    var result: Double {
        get {
            return accumulator
        }
    }
}
