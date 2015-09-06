//
//  CalcuatorBrain.swift
//  Calculator
//
//  Created by Falcon on 15/9/1.
//  Copyright (c) 2015年 Falcon. All rights reserved.
//

import Foundation

class CalcuatorBrain {
    
    private enum Op {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String,(Double, Double) -> Double)
    }
    
    private var opStacks = [Op]()
    
    private var knownOps = [String:Op]()
    
    init() {
        knownOps["✖️"] = Op.BinaryOperation("✖️",*)
        knownOps["➗"] = Op.BinaryOperation("➗"){$1 / $0}
        knownOps["➕"] = Op.BinaryOperation("➕", +)
        knownOps["➖"] = Op.BinaryOperation("➖", {$1 - $0})
        knownOps["✓"] = Op.UnaryOperation("✓",sqrt)
        
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        if !ops.isEmpty {
//            ops.removeLast()
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand,remainingOps)
            case .UnaryOperation(_, let operation):
                let operationEvaluation = evaluate(remainingOps)
                if let operand = operationEvaluation.result {
                    return (operation(operand),remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result{
                        return (operation(operand1,operand2),op2Evaluation.remainingOps)
                    }
                }
            }
        }
        return (nil,ops)
    }
    
    func evaluate () -> Double? {
        let (result,remainder) = evaluate(opStacks)
        return result
    }
    
    func pushOperand(operand: Double){
        opStacks.append(Op.Operand(operand))
    }
    
    func performOperation(symbol: String) {
        if let operation = knownOps[symbol] {
            opStacks.append(operation)
        }
    }
}