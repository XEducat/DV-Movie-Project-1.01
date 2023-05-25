import Foundation

/// Model for videos from TMDB
struct Video : Codable {
    let id : Int?
    let results : [VideoResults]?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case results = "results"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        results = try values.decodeIfPresent([VideoResults].self, forKey: .results)
    }
}
