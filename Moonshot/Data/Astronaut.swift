struct AstronautResponse: Codable, Identifiable {
    let id: String
    let name: String
    let description: String
}

struct Astronaut: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let description: String
    let missionIds: [Int]

    static let mock = Astronaut(
        id: "ramocan",
        name: "Yuri Ramocan",
        description: "Anyone can sit through a tutorial, but it takes actual work to remember what was taught. It’s my job to make sure you take as much from these tutorials as possible, so I’ve prepared a short review to help you check your learning.\nAs for GeometryReader, it’s one of those things you can get by perfectly fine without even thinking about, and that’s fine. But when you want to add a little pizazz to your designs – when you want to really bring something to life as the user interacts with it – GeometryReader is a fast and flexible fix that offers a huge amount of power in only a handful of lines of code.",
        missionIds: [1, 22, 43, 9]
    )
}
