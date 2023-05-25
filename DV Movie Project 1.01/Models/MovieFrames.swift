import Foundation

/// Model for movie frames from TMDB
struct MovieFrames : Codable {
    let backdrops : [Backdrops]?
    let id : Int?
    let logos : [Logos]?
    let posters : [Posters]?

    enum CodingKeys: String, CodingKey {

        case backdrops = "backdrops"
        case id = "id"
        case logos = "logos"
        case posters = "posters"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        backdrops = try values.decodeIfPresent([Backdrops].self, forKey: .backdrops)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        logos = try values.decodeIfPresent([Logos].self, forKey: .logos)
        posters = try values.decodeIfPresent([Posters].self, forKey: .posters)
    }

}
