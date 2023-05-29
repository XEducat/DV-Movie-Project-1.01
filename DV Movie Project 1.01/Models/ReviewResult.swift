import Foundation

struct ReviewResult : Codable {
    let author : String?
    let author_details : ReviewAuthorDetails?
    let content : String?
    let created_at : String?
    let id : String?
    let updated_at : String?
    let url : String?

    enum CodingKeys: String, CodingKey {

        case author = "author"
        case author_details = "author_details"
        case content = "content"
        case created_at = "created_at"
        case id = "id"
        case updated_at = "updated_at"
        case url = "url"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        author = try values.decodeIfPresent(String.self, forKey: .author)
        author_details = try values.decodeIfPresent(ReviewAuthorDetails.self, forKey: .author_details)
        content = try values.decodeIfPresent(String.self, forKey: .content)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        url = try values.decodeIfPresent(String.self, forKey: .url)
    }

}
