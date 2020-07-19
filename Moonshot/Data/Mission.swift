import Foundation

struct Mission: Codable, Identifiable {
    struct CrewRole: Codable {
        let name: String
        let role: String

        static let mock = CrewRole(name: "Spock", role: "Starship Captain")
    }

    let crew: [CrewRole]
    let description: String
    let id: Int
    let launchDate: Date?

    var displayName: String {
        "Apollo \(id)"
    }

    var formattedLaunchDate: String {
        guard let launchDate = launchDate else {
            return "N/A"
        }

        let formatter = DateFormatter()
        formatter.dateStyle = .long

        return formatter.string(from: launchDate)
    }

    var image: String {
        "apollo\(id)"
    }

    static let mock = Mission(
        crew: [CrewRole](repeating: .mock, count: 8),
        description: "The mission called 22.",
        id: 22,
        launchDate: Date()
    )
}
