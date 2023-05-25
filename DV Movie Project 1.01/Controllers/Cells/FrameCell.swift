import UIKit
import Alamofire

class FrameCell: UITableViewCell {
    private var frameImageView: UIImageView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .darkBlue
        setupSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Додає елементи на блок ( cell )
    private func setupSubviews() {
        frameImageView = UIImageView()
        frameImageView.layer.cornerRadius = 10
        frameImageView.contentMode = .scaleToFill
        frameImageView.clipsToBounds = true
        self.addSubview(frameImageView)
    }
    
    /// Виставляє обмеження ( constraints ) для елементів блоку ( cell )
    private func setupConstraints() {
        frameImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            frameImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            frameImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            frameImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            frameImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
        ])
    }
    
    /// Налаштовує блок ( cell )
    func configure(with backdrop: Backdrops) {
        if let filePath = backdrop.filePath {
            let imageUrlString = "https://image.tmdb.org/t/p/w500" + filePath
            AF.request(imageUrlString).responseData { response in
                switch response.result {
                case .success(let imageData):
                    if let image = UIImage(data: imageData) {
                        self.frameImageView.image = image
                    }
                case .failure(let error):
                    print("Error downloading image: \(error)")
                }
            }
        }
    }
}
