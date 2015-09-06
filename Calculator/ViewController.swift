//
//  ViewController.swift
//  Calculator
//
//  Created by Falcon on 15/8/23.
//  Copyright (c) 2015年 Falcon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    var userIsInTheMiddleOfTypingNumber: Bool = false
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        println("digit = \(digit)")
        if userIsInTheMiddleOfTypingNumber {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingNumber = true
        }
        
    }
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if(userIsInTheMiddleOfTypingNumber){
            enter()
        }
        switch operation {
            // 这里的闭包可以省略参数和返回值的类型，因为在performOperation里可以推导出来，甚至不需要return 关键字，因为类型推导知道你要返回一个Double的值
            case "✖️": performOperation({(op1,op2) in op1 * op2})
            // 更进一步的省略,将参数以$0,$1的形式表示
            case "➗":performOperation({$1 / $0})
            // 再进一步，如果这个闭包是performOperation的最后一个参数，可以将闭包移到括号外
            // 甚至如果performOperation只有这一个参数时，可以把括号也去掉
            case "➕":performOperation{$0 + $1}
              // 不省略的情况如下
            case "➖":performOperation({(op1: Double,op2: Double) -> Double in
                return op2 - op1
            })
            case "✓":performOperation{sqrt($0)}
            default: break
            
        }
        
    }
    
    func performOperation(operation: (Double,Double) -> Double){
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(),operandStack.removeLast())
            // displayValue = operandStack.removeLast() * operandStack.removeLast()
            enter()
        }
    }
    // UIViewController 继承自OC的NSObject. 在Swift中被装饰成@objc class, 那么就必须遵循OC的selector，在oc中不支持方法重载，这里加入private正常了
    private func performOperation(operation: Double -> Double){
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            // displayValue = operandStack.removeLast() * operandStack.removeLast()
            enter()
        }
    }
    
//    func multiply(op1: Double,op2: Double) -> Double {
//        return op1 * op2
//    }
    
    // var operandStack: Array<Double> = Array<Double>()
//    var operandStack = Array<Double>()
    var operandStack = [Double]()
    @IBAction func enter() {
        userIsInTheMiddleOfTypingNumber = false
        operandStack.append(displayValue)
        println("operandStack=\(operandStack)")
    }
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
            
        }
        
        set {
            //newValue: magic variable
            display.text = "\(newValue)" // 将Double转换成String
            println(display.text!)
            userIsInTheMiddleOfTypingNumber = false
        }
    }
}

