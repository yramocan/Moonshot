import Foundation

extension Bundle {
    func decode<T: Decodable>(_ file: String) throws -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            throw BundleError.fileError(description: "Failed to locate \(file) in bundle")
        }

        guard let data = try? Data(contentsOf: url) else {
            throw BundleError.fileError(description: "Failed to load \(file) in bundle")
        }

        let decoder = JSONDecoder()

        let formatter = DateFormatter()
        formatter.dateFormat = "y-MM-dd"
        decoder.dateDecodingStrategy = .formatted(formatter)

        guard let loaded = try? decoder.decode(T.self, from: data) else {
            throw BundleError.decodeError(description: "Failed to decode data from bundle")
        }

        return loaded
    }

    enum BundleError: Error {
        case decodeError(description: String)
        case fileError(description: String)

        var localDescription: String {
            switch self {
            case .decodeError(let description), .fileError(let description):
                return description
            }
        }
    }
}
