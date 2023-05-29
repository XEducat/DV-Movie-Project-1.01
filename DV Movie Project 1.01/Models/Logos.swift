import Foundation

/// Submodel for MovieFrames
struct Logos : Codable {
    let aspectRatio : Double?
    let height : Int?
    let filePath : String?
    let voteAverage : Double?
    let voteCount : Int?
    let width : Int?

    enum CodingKeys: String, CodingKey {

        case aspectRatio = "aspect_ratio"
        case height = "height"
        case filePath = "file_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case width = "width"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        aspectRatio = try values.decodeIfPresent(Double.self, forKey: .aspectRatio)
        height = try values.decodeIfPresent(Int.self, forKey: .height)
        filePath = try values.decodeIfPresent(String.self, forKey: .filePath)
        voteAverage = try values.decodeIfPresent(Double.self, forKey: .voteAverage)
        voteCount = try values.decodeIfPresent(Int.self, forKey: .voteCount)
        width = try values.decodeIfPresent(Int.self, forKey: .width)
    }
}
