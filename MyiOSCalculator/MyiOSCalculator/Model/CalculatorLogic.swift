//
//  CalculatorLogic.swift
//  MyiOSCalculator
//
//  Created by davisatwell on 11/7/22

import SwiftUI

struct CalculatorLogic {
    
    private var number: Double?
    
    private var priorVal: Double?
    private var presentVal: Double?
    private var presentOp: CalcButton?
    private var resultVal: Double = 0

    
    mutating func setNumVal(_ number: Double) {
        self.number = number
    }
    
    private mutating func resetCalculator() -> Double {
        priorVal = nil
        presentVal = nil
        presentOp = nil
        return 0
    }
    
    private var lastInputEqual = false
    
    mutating func calculate(symbol: CalcButton) -> Double? {
        
        if let number = number {
            switch symbol {
            case .plusMinusButton:
                if number != 0 { return number * -1 }
            case .acButton:
                return resetCalculator()
            case .percentButton:
                return number * 0.01
            case .equalsButton:
                
                lastInputEqual = true
                
                if let priorVal = priorVal {
                    if let presentVal = presentVal {
                        return performCalculation(priorVal: priorVal, presentVal: presentVal)
                    } else {
                        presentVal = number
                        return performCalculation(priorVal: priorVal, presentVal: number)
                    }
                }
                
            default:
                
                if lastInputEqual {
                    lastInputEqual = false
                    priorVal = nil
                }

                if let previousValue = priorVal {
                    let result = performCalculation(priorVal: previousValue, presentVal: number)
                    presentOp = symbol
                    return result
                }
                
                presentOp = symbol
                presentVal = nil
                priorVal = priorVal != nil ? priorVal : number
            }
        }
        return nil
    }

    private mutating func performCalculation(priorVal: Double, presentVal: Double) -> Double? {
        
        if let operation = presentOp {
            switch operation {
            case .addButton:
                resultVal = priorVal + presentVal
            case .subtractButton:
                resultVal = priorVal - presentVal
            case .multiplyButton:
                resultVal = priorVal * presentVal
            case .divideButton:
                resultVal = priorVal / presentVal
            default:
                fatalError("ERROR - operation does not match any of the case options.")
            }
        }
        self.priorVal = resultVal
        return resultVal
    }
    
    
}
