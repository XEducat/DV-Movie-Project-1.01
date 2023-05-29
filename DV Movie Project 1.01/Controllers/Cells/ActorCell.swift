import UIKit
import Alamofire

class ActorCell: UITableViewCell {
    let lblName = UILabel()       // Імя актора
    let lblCharacter = UILabel()    // Роль
    let actorImageView = UIImageView()   // Фото
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    /// Налаштовує cell(клітінку)
    public func configCell(cast: Cast) {
        self.backgroundColor = .darkBlue
        
        setupImageView()
        if let profileImagePath = cast.profilePath {
            let profileImageURL = "https://image.tmdb.org/t/p/w500" + profileImagePath
            uploadImage(URL: profileImageURL)
        }
        setupLabelName(text: cast.name!)
        setupLabelCharacter(text: cast.character?.uppercased() ?? "")
        
        setupConstraints()
    }
    
    /// Виставляє параметри до actorImageView
    private func setupImageView() {
        actorImageView.backgroundColor = .black
        actorImageView.layer.cornerRadius = 30
        actorImageView.contentMode = .scaleAspectFill
        actorImageView.clipsToBounds = true
    }
    
    /// Завантажує зображення в actorImageView за данною URL
    private func uploadImage(URL imageURL: String) {
        AF.request(imageURL).responseData { response in
            switch response.result {
            case .success(let imageData):
                if let image = UIImage(data: imageData) {
                    self.actorImageView.image = image
                }
            case .failure(let error):
                print("Error downloading image: \(error)")
            }
        }
    }
    
    /// Виставляє параметри до lblName
    private func setupLabelName(text: String) {
        lblName.textColor = .white
        lblName.SetWithLimit(text: text, characterLimit: 13)
        lblName.font = UIFont(name: "Arial", size: 14) // TODO: Заменить на нормальный шрифт
    }
    
    
    /// Виставляє параметри до lblCharacter
    private func setupLabelCharacter(text: String) {
        lblCharacter.lineBreakMode = .byWordWrapping
        lblCharacter.SetWithLimit(text: text, characterLimit: 12)
        lblCharacter.textColor = .gray
        lblCharacter.font = UIFont(name: "Arial", size: 12) // TODO: Заменить на нормальный шрифт
    }
    
    /// Налаштовує обмеження (constraints) всіх елементів на клітінці (сell)
    /// Елементи: actorImageView, lblName, lblCharacter
    private func setupConstraints() {
        [actorImageView, lblName, lblCharacter].forEach{
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            actorImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            actorImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            actorImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            actorImageView.widthAnchor.constraint(equalTo: actorImageView.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            lblName.leadingAnchor.constraint(equalTo: actorImageView.trailingAnchor, constant: 20),
            lblName.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            lblCharacter.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            lblCharacter.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            lblCharacter.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 260)
        ])
    }
}
