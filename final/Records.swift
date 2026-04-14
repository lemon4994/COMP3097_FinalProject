import SwiftUI
import CoreData

struct Records: View {
    
    @FetchRequest(
        entity: Player.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Player.wins, ascending: false),
            NSSortDescriptor(keyPath: \Player.streak, ascending: false)
        ]
    ) var players: FetchedResults<Player>
    
    var body: some View {
        VStack {
            
            Text("Leaderboard")
                .font(.largeTitle)
            
            List {
                ForEach(players, id: \.self) { player in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(player.name ?? "Unknown")
                            Text("Wins: \(player.wins) Streak: \(player.streak)")
                                .font(.subheadline)
                        }
                        
                        Spacer()
                        
                        if player.isOnStreak {
                            Text("🔥")
                        }
                    }
                }
            }
        }
    }
}
