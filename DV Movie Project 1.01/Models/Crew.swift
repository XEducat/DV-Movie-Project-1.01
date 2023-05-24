import Foundation

/// Submodel for Film
struct Crew : Codable {
    let adult : Bool?
    let gender : Int?
    let id : Int?
    let known_for_department : String?
    let name : String?
    let original_name : String?
    let popularity : Double?
    let profile_path : String?
    let credit_id : String?
    let department : String?
    let job : String?

    enum CodingKeys: String, CodingKey {

        case adult = "adult"
        case gender = "gender"
        case id = "id"
        case known_for_department = "known_for_department"
        case name = "name"
        case original_name = "original_name"
        case popularity = "popularity"
        case profile_path = "profile_path"
        case credit_id = "credit_id"
        case department = "department"
        case job = "job"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        adult = try values.decodeIfPresent(Bool.self, forKey: .adult)
        gender = try values.decodeIfPresent(Int.self, forKey: .gender)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        known_for_department = try values.decodeIfPresent(String.self, forKey: .known_for_department)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        original_name = try values.decodeIfPresent(String.self, forKey: .original_name)
        popularity = try values.decodeIfPresent(Double.self, forKey: .popularity)
        profile_path = try values.decodeIfPresent(String.self, forKey: .profile_path)
        credit_id = try values.decodeIfPresent(String.self, forKey: .credit_id)
        department = try values.decodeIfPresent(String.self, forKey: .department)
        job = try values.decodeIfPresent(String.self, forKey: .job)
    }

}
