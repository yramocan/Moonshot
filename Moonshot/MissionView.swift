import SwiftUI

struct MissionView: View {
    let mission: Mission

    @EnvironmentObject private var dataStore: DataStore
    @State private var astronauts = [Astronaut]()

    var body: some View {
        GeometryReader { geo in
            ScrollView(.vertical) {
                Spacer()

                VStack {
                        HStack {
                            Spacer()
                            Image(mission.image)
                                .resizable()
                                .scaledToFit()
                                .padding(.vertical)
                                .frame(maxWidth: geo.size.width * 0.75)
                            Spacer()
                        }

                    Text(mission.formattedLaunchDate)
                        .font(.caption)

                    Text(mission.description)
                        .padding()

                    ForEach(mission.crew, id: \.role) { crewMember in
                        if let astronaut = astronauts.first(where: { $0.id == crewMember.name }) {
                            NavigationLink(destination: AstronautView(astronaut: astronaut)) {
                                HStack {
                                    Image(crewMember.name)
                                        .resizable()
                                        .frame(width: 83, height: 60)
                                        .clipShape(Capsule())
                                        .overlay(Capsule().stroke(Color.primary, lineWidth: 1))

                                    VStack(alignment: .leading) {
                                        Text(astronaut.name)
                                            .font(.headline)
                                        Text(crewMember.role)
                                            .foregroundColor(.secondary)
                                    }

                                    Spacer()
                                }
                                .padding(.horizontal)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }

                    Spacer(minLength: 25)
                }
            }
        }
        .navigationBarTitle(mission.displayName, displayMode: .inline)
        .onAppear(perform: fetchAstronauts)
    }

    private func fetchAstronauts() {
        dataStore.fetchAstronauts(for: mission.id) { result in
            switch result {
            case .success(let astronauts):
                self.astronauts = astronauts
            case .failure(let error):
                print("There was an error: \(error.localizedDescription)")
            }
        }
    }
}

struct MissionView_Previews: PreviewProvider {
    static var previews: some View {
        MissionView(mission: Mission.mock)
    }
}
