//
//  ContentView.swift
//  MyiOSCalculator
//
//  Created by davisatwell on 11/7/22

import SwiftUI

extension Double {
    func roundTo(places: Int) -> Double {
        let denominator = pow(10.0, Double(places))
        return (self * denominator).rounded() / denominator
    }
}

enum CalcButton: String {
    case zero, one, two, three, four, five, six, seven, eight, nine, decimal
    case equalsButton, addButton, subtractButton, multiplyButton, divideButton
    case acButton, plusMinusButton, percentButton
    
    var num: String {
        switch self {
        case .zero: return "0"
        case .one: return "1"
        case .two: return "2"
        case .three: return "3"
        case .four: return "4"
        case .five: return "5"
        case .six: return "6"
        case .seven: return "7"
        case .eight: return "8"
        case .nine: return "9"
        case .addButton: return "+"
        case .subtractButton: return "-"
        case .multiplyButton: return "×"
        case .divideButton: return "÷"
        case .plusMinusButton: return "±"
        case .percentButton: return "%"
        case .decimal: return "."
        case .equalsButton: return "="
        default:
            return "AC"
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine, .decimal:
            return Color(.magenta)
        case .acButton, .plusMinusButton, .percentButton:
            return Color(.white)
        default:
            return .purple
        }
    }
    
    var textColor: Color {
        switch self {
        case .acButton, .plusMinusButton, .percentButton:
            return Color(.black)
        default:
            return .white
        }
    }
    
    var size: CGFloat {
        switch self {
        case .acButton, .plusMinusButton, .percentButton:
            return 28.0
        default:
            return 32.0
        }
    }
}


class GlobalEnvironment: ObservableObject {
    
    @Published var displayedVal = "0"
    
    private var finishedTyping: Bool = true
    private var priorInputVal: CalcButton?
    
    private var displayValue: Double {
        get {
            guard let number = Double(self.displayedVal)
            else {
                fatalError("display label text can not be converted to a double value") }
            return number
        }
        set {
            self.displayedVal = newValue.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", newValue) : String(newValue)
        }
    }

    private var calculator = CalculatorLogic()
    
    private func isPreviousInputValOperator() -> Bool {
        
        guard let priorInputVal = priorInputVal else { return false }
        
            return
        priorInputVal == .divideButton ||
        priorInputVal == .multiplyButton ||
        priorInputVal == .addButton ||
        priorInputVal == .subtractButton
    }
    
    func inputReceived(calculatorButton: CalcButton) {

        switch calculatorButton {
        case .acButton, .plusMinusButton, .percentButton, .divideButton, .multiplyButton, .subtractButton, .addButton, .equalsButton:
            
            if isPreviousInputValOperator() { break }
            
            finishedTyping = true
            
            calculator.setNumVal(displayValue) 

            if let result = calculator.calculate(symbol: calculatorButton) {
                displayValue = result
            }
            
        default:
            
            if finishedTyping {
                
                
                if displayValue == 0 && calculatorButton == .zero { return }
                
                if calculatorButton == .decimal {
                    self.displayedVal = "0" + calculatorButton.num
                } else { self.displayedVal = calculatorButton.num }
                
                finishedTyping = false
                
            } else {
                
                if calculatorButton == .decimal {
                    
                    if self.displayedVal.contains(".") { return }

                    let isInt = floor(displayValue) == displayValue
                    if !isInt { return }
                }
                self.displayedVal = self.displayedVal + calculatorButton.num
            }
        }
        priorInputVal = calculatorButton
    }
}



struct ContentView: View {
    
    @EnvironmentObject var env: GlobalEnvironment

    let space: CGFloat = 16
    
    var buttonWidth = (UIScreen.main.bounds.width - 5 * 16) / 4
    
    let buttons: [[CalcButton]] = [
        [.acButton, .plusMinusButton, .percentButton, .divideButton],
        [.seven, .eight, .nine, .multiplyButton],
        [.four, .five, .six, .subtractButton],
        [.one, .two, .three, .addButton],
        [.zero, .decimal, .equalsButton]
    ]

    var body: some View {
        
        ZStack (alignment: .bottom) {
            
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack (spacing: self.space) {
                
                HStack {
                    Spacer()
                    Text(env.displayedVal).foregroundColor(.white)
                        .font(.system(size: 100))
                        .fontWeight(.light)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                }
                .padding(.trailing).padding(.trailing, buttonWidth / 2 / 4)
                
                ForEach(buttons, id: \.self) { row in
                    HStack (spacing: self.space) {
                        ForEach(row, id: \.self) { button in
                            CalculatorButtonView(button: button)
                        }
                    }
                }
            }.padding(.bottom)
        }
    }
}



struct CalculatorButtonView: View {
    
    var button: CalcButton
    let spacing: CGFloat = 16
    
    let screenWidth = UIScreen.main.bounds.width
    
    @EnvironmentObject var env: GlobalEnvironment
    
    var body: some View {
        Button(action: {
            self.env.inputReceived(calculatorButton: self.button)
        }) {
            Text(button.num)
                .font(.system(size: button.size))
                .fontWeight(.regular)
                .frame(width: self.buttonWidth(button: button), height: (screenWidth - 5 * self.spacing)  / 4)
                .foregroundColor(button.textColor)
                .background(button.backgroundColor)
                .cornerRadius(self.buttonWidth(button: button))
        }
    }

    private func buttonWidth(button: CalcButton) -> CGFloat {
        if button == .zero {
            return (screenWidth - 4 * self.spacing)  / 4 * 2
        }
        return (screenWidth - 5 * self.spacing)  / 4
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(GlobalEnvironment())
    }
}
