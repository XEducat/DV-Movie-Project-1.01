import Foundation


struct ReviewAuthorDetails : Codable {
    let name : String?
    let username : String?
    let avatar_path : String?
    let rating : Double?

    enum CodingKeys: String, CodingKey {

        case name = "name"
        case username = "username"
        case avatar_path = "avatar_path"
        case rating = "rating"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        username = try values.decodeIfPresent(String.self, forKey: .username)
        avatar_path = try values.decodeIfPresent(String.self, forKey: .avatar_path)
        rating = try values.decodeIfPresent(Double.self, forKey: .rating)
    }

}
