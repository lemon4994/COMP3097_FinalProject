import SwiftUI
import CoreData

struct ContentView: View {
    
    @State private var showGame = false
    @State private var showRecords = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                Text("Guessing Game")
                    .font(.largeTitle)
                
                Button("Start Game") {
                    showGame = true
                }
                
                Button("View Records") {
                    showRecords = true
                }
            }
            .navigationDestination(isPresented: $showGame) {
                GameScreen(onFinished: {
                    showGame = false
                    showRecords = true
                })
            }
            .navigationDestination(isPresented: $showRecords) {
                Records()
            }
        }
    }
}
