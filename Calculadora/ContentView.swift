//
//  ContentView.swift
//  Calculadora
//
//  Created by NAHUM MARTINEZ on 1/9/23.
//

import SwiftUI


enum ButtonsCalc:String {
    case one = "1"
    case two = "2"
    case three="3"
    case four="4"
    case five="5"
    case six="6"
    case seven="7"
    case eight="8"
    case nine="9"
    case zero="0"
    case add="+"
    case substract="-"
    case divide="/"
    case multiply="x"
    case equal="="
    case ac="AC"
    case decimal="."
    case percent=""
    case backgroundD="W"
    
    
    var buttonsColors: Color {
        switch self {
        case .add, .substract, .multiply,.divide, .equal:
            return  .orange
        case .ac, .backgroundD, .percent:
            return Color(.lightGray)
        default:
            return Color(UIColor(red: 55/255.0, green: 55/255.0, blue: 55/255, alpha: 1))
        }
    }
    
    var textColors: Color {
        switch self {
        case .add, .substract, .multiply,.divide, .equal:
            return  .white
        case .ac, .backgroundD, .percent:
            return .black
            
        default:
            return .white
        }
        
    }
    
    
    
}

//Eliminar esto es viejo y ya no lo usare

enum Operations {
    case add, substract, multiply, divide, none
    
}



    struct ContentView: View {
        
        var  background = "W"
        
        let buttons: [[ButtonsCalc]] = [
            [.ac,.backgroundD , .percent, .divide],
            [.seven, .eight, .nine, .multiply],
            [.four, .five, .six,.substract],
            [.one, .two, .three, .add],
            [.zero, .decimal, .equal]
            
        ]
        
        
        
        
        @State var visibleOperation = ""
        @State var penultimo:Character = "/"
        @State var result = "0"
        @State var showToast = false
        @State var isBlack = false
        
        private func changeBackgroundText(buttonCalc: ButtonsCalc) -> String {
            
            if buttonCalc == .backgroundD {
                
                return isBlack ? "W" : "B"
                
            }
            else {
                return buttonCalc.rawValue
            }
        }
        
        
        var body: some View {
            ZStack {
                Color(isBlack ? .black : .white)
                    .edgesIgnoringSafeArea(.all)
                
                VStack{
                    Spacer()
                    //ESTO SERIA EL TEXTO QUE SE MUESTRE EN LA PANTALLA
                    HStack{
                        Spacer()
                        Text(visibleOperation)
                            
                            .font(.system(size:62))
                            .foregroundColor(isBlack ? .white : .black)
                    }.padding()
                    //Pintamos los botones
                    
                    ForEach(buttons, id:\.self){ row in
                        //Los ordenamos para que se vayan alineando horizontalmente y no se haga una lista vertical
                        HStack(spacing: 12) {
                            ForEach(row, id: \.self){ item in
                                
                                Button(action: {
                                    let number = item.rawValue
                                    self.buttonPressed(item: number)
                                    
                                }, label:{
                                                                        
                                    Text(changeBackgroundText(buttonCalc: item))
                                        
                                        .font(.system(size:30))
                                        .frame(
                                            width: self.buttonsWidth(item: item),
                                            height: self.buttonsHeight()
                                        )
                                        .background(item.buttonsColors)
                                        .foregroundColor(item.textColors)
                                        .cornerRadius(self.buttonsWidth(item: item) / 2)
                                    
                                })
                            }
                        }
                        .padding(.bottom, 3)
                        .alert(isPresented: $showToast) {
                            Alert(
                                title: Text("No fue posible realizar la operación"), message: Text(visibleOperation), dismissButton: .default(Text("Ok"))
                            )
                        }
                    }
                }
                
            }
            
        }
        
        
        
        
        func buttonPressed(item: String) {
            
            
            switch item {
            case "AC":
                clear()
                break
            case "=":
                visibleOperation = resultOperation()
                break
                
            case  "x","/","+","-":
                addOperation(item)
                break
            case "W":
                isBlack = !isBlack
            default:
                result = "0"
                visibleOperation += item
            }
            
        }
        
        
        
        
        func addOperation(_ item: String){
            if !visibleOperation.isEmpty{
                
                
                let last = String(visibleOperation.last!)
                
                if(last == "-"){
                    visibleOperation.removeLast()
                }
                visibleOperation += item
                
                
            }
        }
        
        func resultOperation() -> String{
            
            
            if(validInput()) {
                
                
                let operations = visibleOperation.replacingOccurrences(of: "x", with: "*")
                
                
                let expression = NSExpression(format: operations)
                
                
                let result =  expression.expressionValue(with: nil, context: nil) as! Double
                
                
                return formatResult(val: result)
            }
            
            
            
            showToast = true
            
            return "Error"
        }
        
        
        func validInput() -> Bool{
            
            
            
            
            
            
            if(visibleOperation.isEmpty){
                
                return false
            }
            
            
            let last = String(visibleOperation.last!)
            
            if(visibleOperation.count >= 2){
                penultimo = visibleOperation[visibleOperation.index(visibleOperation.endIndex, offsetBy: -2)]
            }
            
            
            if(penultimo == "/" && last == "0"){
                
                return false
                
            }
            
            
            return true
            
            
            
        }
        
        
        
        
        
        func formatResult(val: Double) -> String{
            if val.truncatingRemainder(dividingBy: 1) == 0 {
                return String(format: "%.0f", val)
            }
            
            
            return String(format: "%.1f", val)
        }
        
        
        func clear() {
            visibleOperation = ""
            result = "0"
            
            
        }
        
        
        
        
        
        func buttonsWidth(item:ButtonsCalc) -> CGFloat {
            
            if item == .zero {
                return ((UIScreen.main.bounds.width - (4 * 12)) / 4) * 2
            }
            return (UIScreen.main.bounds.width - (5 * 12)) / 4
        }
        
        func buttonsHeight() -> CGFloat {
            return (UIScreen.main.bounds.width - (5 * 12)) / 4
        }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        
            ContentView()
    
            
    }
        
}
    
