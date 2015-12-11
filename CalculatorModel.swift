//
//  CalculatorModel.swift
//  Calculator
//
//  Created by Krishak Choukhany on 07/12/15.
//  Copyright © 2015 Krishak Choukhany. All rights reserved.
//

import Foundation

class CalculatorModel {

    private enum op {
        case Operand(Double)
        case UnaryOperator(String,Double -> Double)
        case BinaryOperator(String,(Double,Double)->Double)
        case Constant(String,Double?)
        
        var description:String{
            switch self{
            case .Operand(let operand):
                    return "\(operand)"
            case .UnaryOperator(let symbol, _):
                return symbol
            case .BinaryOperator(let symbol, _):
                return symbol
            case .Constant(let symbol,_):
                return symbol
                
            }
        }
        
    }
    
    private var opStack = [op]()
    private var operations = [String:op]()
    private var variables = [String:op]()
    
    
    
    init(){
        func learn(let operation:op){
            operations[operation.description] = operation
        }
        
        learn(op.BinaryOperator("+",+))
        learn(op.BinaryOperator("*",*))
        learn(op.BinaryOperator("-",{$1 - $0}))
        learn(op.BinaryOperator("/",{$1/$0}))
        learn(op.UnaryOperator("sqrt",sqrt))
        learn(op.UnaryOperator("cos",cos))
        learn(op.UnaryOperator("sin",sin))
        learn(op.Constant("pi",3.14))
    }
    
    func evaluate() -> Double? {
    let (result,remainder) = evaluate(opStack)
    return result
    }
    
    func pushOperand(literal:Double){
        opStack.append(op.Operand(literal))
    }
    
    func pushVariable(literal:String) {
        if variables[literal] == nil {
            if !opStack.isEmpty {
                let val = opStack.removeLast()
                    variables[literal] = val
                }
            }
        else{
            opStack.append(variables[literal]!)
            print(variables[literal]!)
        }
        }
    
    
    func performOperation(symbol:String){
        if let operation = operations[symbol]{
            opStack.append(operation)
        }
    
    }
    
    private func evaluate(var stack : [op]) -> (result : Double?,remainingOps : [op]) {
        if !stack.isEmpty {
        let element = stack.removeLast()
        switch element {
            case .Operand(let operand):
                return (operand,stack)
            case .UnaryOperator(_, let operation):
                let stackEval = evaluate(stack)
                if let evalResult = stackEval.result {
                    return (operation(evalResult),stack)
            }
            case .BinaryOperator(_, let operation):
                    let stackEval1 = evaluate(stack)
                    if let evalResult1 = stackEval1.result {
                        let stackEval2 = evaluate(stackEval1.remainingOps)
                        if let evalResult2 = stackEval2.result{
                            return (operation(evalResult1,evalResult2),stackEval2.remainingOps)
                        }
                    }
            case .Constant(_,let val):
                        return (val!,stack)
                }
        }
    
            return (nil,stack)
    }
    
    func clear(){
        opStack.removeAll()
        variables.removeAll()
    }
}
    
