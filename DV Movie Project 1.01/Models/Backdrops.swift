import Foundation

/// Submodel for MovieFrames
struct Backdrops : Codable {
    let aspect_ratio : Double?
    let height : Int?
    let iso_639_1 : String?
    let file_path : String?
    let vote_average : Double?
    let vote_count : Int?
    let width : Int?

    enum CodingKeys: String, CodingKey {

        case aspect_ratio = "aspect_ratio"
        case height = "height"
        case iso_639_1 = "iso_639_1"
        case file_path = "file_path"
        case vote_average = "vote_average"
        case vote_count = "vote_count"
        case width = "width"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        aspect_ratio = try values.decodeIfPresent(Double.self, forKey: .aspect_ratio)
        height = try values.decodeIfPresent(Int.self, forKey: .height)
        iso_639_1 = try values.decodeIfPresent(String.self, forKey: .iso_639_1)
        file_path = try values.decodeIfPresent(String.self, forKey: .file_path)
        vote_average = try values.decodeIfPresent(Double.self, forKey: .vote_average)
        vote_count = try values.decodeIfPresent(Int.self, forKey: .vote_count)
        width = try values.decodeIfPresent(Int.self, forKey: .width)
    }
}
