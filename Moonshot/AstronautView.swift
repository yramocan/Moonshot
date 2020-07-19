import SwiftUI

struct AstronautView: View {
    let astronaut: Astronaut

    @EnvironmentObject private var dataStore: DataStore
    @State private var missions = [Mission]()

    var body: some View {
        ScrollView(.vertical) {
            Spacer()
            
            VStack {
                Image(astronaut.id)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)

                Text(astronaut.description)
                    .padding()

                Spacer()

                List(missions) { mission in
                    NavigationLink(destination: MissionView(mission: mission)) {
                        HStack {
                            Image(mission.image)
                                .resizable()
                                .frame(width: 60, height: 60)

                            Text(mission.displayName)
                        }
                    }
                }
            }
        }
        .navigationBarTitle(Text(astronaut.name), displayMode: .inline)
        .onAppear(perform: fetchMissions)
    }

    private func fetchMissions() {
        dataStore.fetchMissions(for: astronaut.id) { result in
            switch result {
            case .success(let missions):
                self.missions = missions
            case .failure(let error):
                print("There was an error: \(error.localizedDescription)")
            }
        }
    }
}

struct AstronautView_Previews: PreviewProvider {
    static var previews: some View {
        AstronautView(astronaut: Astronaut.mock)
    }
}
