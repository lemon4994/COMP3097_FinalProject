import SwiftUI
import CoreData

struct GameScreen: View {
    
    let onFinished: () -> Void
    
    @Environment(\.managedObjectContext) private var context
    
    @FetchRequest(
        entity: Player.entity(),
        sortDescriptors: []
    ) var players: FetchedResults<Player>
    
    @State private var solution: [Int] = []
    //variables!!
    @State private var currentGuess = Array(repeating: "", count: 5)
    @State private var history: [[Color]] = []
    @State private var historyValues: [[String]] = []
    
    @State private var showWinPopup = false
    @State private var showLosePopup = false
    
    @State private var playerName = ""
    
    @FocusState private var focusedIndex: Int? //for user experience
    
    let maxGuesses = 5
    
    var guessesLeft: Int {
        maxGuesses - history.count
    }
    
    var body: some View {
        VStack(spacing: 15) {
            
            // This part will take your old guesses and generate a row of squares as hints
            ForEach(0..<history.count, id: \.self) { row in
                HStack {
                    ForEach(0..<5, id: \.self) { col in
                        
                        ZStack {
                            Rectangle()
                                .fill(history[row][col])
                                .frame(width: 30, height: 30)
                                .cornerRadius(4)
                            
                            Text(historyValues[row][col])
                                .font(.caption)
                        }
                    }
                }
            }
            
            // This is where the actual text boxes are created
            HStack {
                ForEach(0..<5, id: \.self) { i in
                    TextField("", text: $currentGuess[i])
                        .frame(width: 40, height: 40)
                        .multilineTextAlignment(.center)
                        .keyboardType(.numberPad)
                        .focused($focusedIndex, equals: i) //when a number is entered it automatically moves to the next field
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.blue, lineWidth: 2)
                        )
                        .onChange(of: currentGuess[i]) { newValue in
                            let trimmed = String(newValue.prefix(1))
                            currentGuess[i] = trimmed
                            
                            if !trimmed.isEmpty, i < 4 {
                                focusedIndex = i + 1
                            }
                        }
                }
            }
            
            HStack {
                Button("Submit") {
                    submitGuess()
                }
                
                Text("Left: \(guessesLeft)")
            }
        }
        .padding()
        .onAppear {
            resetGame()
            focusedIndex = 0
        }
        .sheet(isPresented: $showWinPopup) {
            resultSheet(title: "You Win!", isWin: true)
        }
        .sheet(isPresented: $showLosePopup) {
            resultSheet(title: "You Lose!", isWin: false)
        }
    }
    
    func submitGuess() {
        guard history.count < maxGuesses else { return }
        
        let values = currentGuess.compactMap { Int($0) }
        guard values.count == 5 else { return }
        
        var rowColors: [Color] = []
        //compares the guess to the solution and generates hints
        for i in 0..<5 {
            if values[i] == solution[i] {
                rowColors.append(.green)
            } else if solution.contains(values[i]) {
                rowColors.append(.yellow)
            } else {
                rowColors.append(.red)
            }
        }
        
        let isWin = rowColors.allSatisfy { $0 == .green }
        
        history.append(rowColors)
        historyValues.append(currentGuess)
        currentGuess = Array(repeating: "", count: 5)
        focusedIndex = 0
        
        if isWin {
            showWinPopup = true
            return
        }
        
        if history.count >= maxGuesses {
            showLosePopup = true
        }
    }
    
    @ViewBuilder
    func resultSheet(title: String, isWin: Bool) -> some View {
        VStack(spacing: 20) {
            
            Text(title)
                .font(.largeTitle)
            
            if isWin {
                Text("You win!")
            } else {
                Text("Better luck next time!")
            }
            
            TextField("Enter name", text: $playerName)
                .textFieldStyle(.roundedBorder)
                .padding()
            
            Button("Continue") {
                savePlayer(isWin: isWin)
                
                showWinPopup = false
                showLosePopup = false
                
                onFinished()
            }
        }
        .padding()
    }
    
    func resetGame() {
        solution = (0..<5).map { _ in Int.random(in: 0...9) }
        
        currentGuess = Array(repeating: "", count: 5)
        history = []
        historyValues = []
        
        playerName = ""
        
        showWinPopup = false
        showLosePopup = false
        
        focusedIndex = nil
    }
    
    func savePlayer(isWin: Bool) {
        let player: Player
        
        if let existing = players.first(where: { $0.name == playerName }) {
            player = existing
        } else {
            player = Player(context: context)
            player.name = playerName
            player.wins = 0
            player.streak = 0
            player.isOnStreak = false
        }
        
        if isWin {
            player.wins += 1
            
            if player.isOnStreak {
                player.streak += 1
            } else {
                player.streak = 1
                player.isOnStreak = true
            }
        } else {
            player.isOnStreak = false
            player.streak = 0
        }
        
        try? context.save()
    }
}
