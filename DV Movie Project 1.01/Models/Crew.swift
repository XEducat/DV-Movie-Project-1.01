import Foundation

/// Submodel for Film
struct Crew : Codable {
    let adult : Bool?
    let gender : Int?
    let id : Int?
    let knownForDepartment : String?
    let name : String?
    let originalName : String?
    let popularity : Double?
    let profilePath : String?
    let creditId : String?
    let department : String?
    let job : String?

    enum CodingKeys: String, CodingKey {

        case adult = "adult"
        case gender = "gender"
        case id = "id"
        case knownForDepartment = "known_for_department"
        case name = "name"
        case originalName = "original_name"
        case popularity = "popularity"
        case profilePath = "profile_path"
        case creditId = "credit_id"
        case department = "department"
        case job = "job"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        adult = try values.decodeIfPresent(Bool.self, forKey: .adult)
        gender = try values.decodeIfPresent(Int.self, forKey: .gender)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        knownForDepartment = try values.decodeIfPresent(String.self, forKey: .knownForDepartment)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        originalName = try values.decodeIfPresent(String.self, forKey: .originalName)
        popularity = try values.decodeIfPresent(Double.self, forKey: .popularity)
        profilePath = try values.decodeIfPresent(String.self, forKey: .profilePath)
        creditId = try values.decodeIfPresent(String.self, forKey: .creditId)
        department = try values.decodeIfPresent(String.self, forKey: .department)
        job = try values.decodeIfPresent(String.self, forKey: .job)
    }

}
