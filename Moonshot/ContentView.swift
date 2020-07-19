import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var dataStore: DataStore

    var body: some View {
        NavigationView {
            Group {
                if dataStore.missions.isEmpty {
                    ProgressView()
                } else {
                    List(dataStore.missions) { mission in
                        NavigationLink(destination: MissionView(mission: mission)) {
                            HStack {
                                Image(mission.image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 44, height: 44)

                                VStack(alignment: .leading) {
                                    Text(mission.displayName)
                                    Text(mission.formattedLaunchDate)
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Moonshot")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
