import Foundation

struct DataSource {
    enum MissionServiceError: Error {
        case decodeError
    }

    let astronauts: [Astronaut]
    let missions: [Mission]

    init() {
        guard
            let astronautResponses: [AstronautResponse] = try? Bundle.main.decode("astronauts.json"),
            let missions: [Mission] = try? Bundle.main.decode("missions.json")
        else {
            self.astronauts = []
            self.missions = []

            return
        }

        let astronauts: [Astronaut] = astronautResponses.map { astronautResponse in
            let missionIds: [Int] = missions.compactMap { mission in
                if mission.crew.contains(where: { $0.name == astronautResponse.id }) {
                    return mission.id
                } else {
                    return nil
                }
            }

            return Astronaut(
                id: astronautResponse.id,
                name: astronautResponse.name,
                description: astronautResponse.description,
                missionIds: missionIds
            )
        }

        self.astronauts = astronauts
        self.missions = missions
    }
}
