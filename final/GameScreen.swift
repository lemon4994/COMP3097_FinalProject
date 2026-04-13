//
//  Game Screen.swift
//  final
//
//  Created by Tech on 2026-04-07.
//

import SwiftUI

enum HintState {
    case empty
    case correct
    case correctNumber
    case incorrect
}

struct GameScreen: View {
    
    @State private var solution = [1,2,3,4,5]
    @State private var currentRow = 0
    @State private var guesses = Array(repeating: "", count: 25)
    @State private var feedback = Array(repeating: Color.clear, count: 25)
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Number Game")

            ForEach(0..<5, id: \.self) { row in
                HStack {
                    ForEach(0..<5, id: \.self) { col in
                        let index = row * 5 + col

                        TextField("", text: $guesses[index])
                            .frame(width: 40, height: 40)
                            .multilineTextAlignment(.center)
                            .background(feedback[index])
                            .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(row == currentRow ? Color.blue : Color.gray, lineWidth: 2)
                                    )
                    }
                }
                .disabled(row != currentRow)
            }
            Button("Submit") {
                submitRow()
            }
        }
    }
    func submitRow() {
        let start = currentRow * 5
        let end = start + 5
        let rowValues = guesses[start..<end].compactMap {Int($0)}
        
        guard rowValues.count == 5 else {return}
        
        for i in 0..<5 {
                let index = start + i
                let value = rowValues[i]

                if value == solution[i] {
                    feedback[index] = .green
                } else if solution.contains(value) {
                    feedback[index] = .yellow
                } else {
                    feedback[index] = .red
                }
            }
        
        if currentRow < 6 {
                currentRow += 1
            }
    }
    
}

/*
struct GameScreen: View {
    
    @State private var currentGuess: [Int] = []
    
    @State private var feedback = Array(repeating: HintState.empty, count: 35)
    

    var body: some View {
        VStack {
            Text("Enter your answer")
            ForEach(0..<7, id: \.self) { row in
                HStack {
                    ForEach(0..<5, id: \.self) { col in
                        let index = row * 5 + col

                        TextField(
                            "",
                            text: Binding(
                                get: { guesses[index] },
                                set: { guesses[index] = $0 }
                            )
                        )
                        .frame(width:40, height:40)
                        .multilineTextAlignment(.center)
                        .keyboardType(.numberPad)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(boxColors(feedback[index]), lineWidth: 2)
                        )
                    }
                }
            }
            Button("Submit Guess") {
                let guessNumbers = guesses[currentRow].compactMap {Int($0)}
                guard guessNumbers.count == 5 else {return}
                currentGuess = guessNumbers
                checkGuess(guessNumbers)
                
                if currentRow < 6 {
                    currentRow += 1
                }
              }
            .padding
        }
        .padding()
        
    }
    
}
func answerGenerator() -> [Int] {
    return (0..<5).map { _ in Int.random(in: 0...9)}
}


func boxColors(_ state: HintState) -> Color {
    switch state {
    case .empty: return .gray
    case .correct: return .green
    case .correctNumber: return .yellow
    case .incorrect: return .red
    }
}
*/
struct Game_Screen_Previews: PreviewProvider {
    static var previews: some View {
        GameScreen()
    }
}
