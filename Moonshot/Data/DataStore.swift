import Foundation

final class DataStore: ObservableObject {
    enum DataStoreError: Error {
        case astronautNotFound
        case decodeError
        case missionNotFound
    }

    @Published private(set) var astronauts = [Astronaut]()
    @Published private(set) var missions = [Mission]()

    init() {
        loadData { result in
            switch result {
            case .success(let (astronauts, missions)):
                self.astronauts = astronauts
                self.missions = missions
            case .failure:
                self.astronauts = []
                self.missions = []
            }
        }
    }

    func fetchAstronauts(for missionID: Int, completion: @escaping (Result<[Astronaut], Error>) -> Void) {
        DispatchQueue.global().async { [weak self] in
            guard
                let self = self,
                let mission = self.missions.first(where: { $0.id == missionID })
            else {
                DispatchQueue.main.async {
                    completion(.failure(DataStoreError.missionNotFound))
                }

                return
            }

            let astronauts = mission.crew.compactMap { crewMember in
                return self.astronauts.first { $0.id == crewMember.name }
            }

            DispatchQueue.main.async {
                completion(.success(astronauts))
            }
        }
    }

    func fetchMissions(for astronautID: String, completion: @escaping (Result<[Mission], Error>) -> Void) {
        DispatchQueue.global().async { [weak self] in
            guard
                let self = self,
                let astronaut = self.astronauts.first(where: { $0.id == astronautID })
            else {
                DispatchQueue.main.async {
                    completion(.failure(DataStoreError.astronautNotFound))
                }

                return
            }

            let missions = astronaut.missionIds.compactMap { missionId in
                return self.missions.first { $0.id == missionId }
            }

            DispatchQueue.main.async {
                completion(.success(missions))
            }
        }
    }

    private func loadData(completion: @escaping (Result<(astronauts: [Astronaut], missions: [Mission]), Error>) -> Void) {
        DispatchQueue.global().async {
            guard
                let astronautResponses: [AstronautResponse] = try? Bundle.main.decode("astronauts.json"),
                let missions: [Mission] = try? Bundle.main.decode("missions.json")
            else {
                DispatchQueue.main.async {
                    completion(.failure(DataStoreError.decodeError))
                }

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

            DispatchQueue.main.async {
                completion(.success((astronauts, missions)))
            }
        }
    }
}
