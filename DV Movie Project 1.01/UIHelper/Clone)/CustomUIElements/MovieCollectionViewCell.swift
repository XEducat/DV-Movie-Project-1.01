import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    var titleLabel = UILabel()
    let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    var star = UIImageView()
    var underTextLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupElementsOnCell()
        createDesign()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    ///позиціювання елементів в collectionViewCell
    func setupElementsOnCell() {
        
        self.backgroundColor = .someDarkOfBlue
        [posterImageView,titleLabel,star,underTextLabel].forEach{
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        }
        posterImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        posterImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        posterImageView.heightAnchor.constraint(equalToConstant: 285).isActive = true
        
        star.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 5).isActive = true
        star.heightAnchor.constraint(equalToConstant: 13).isActive = true
        star.widthAnchor.constraint(equalTo: star.heightAnchor, multiplier: 1).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: self.star.bottomAnchor, constant: 10).isActive = true
        
        underTextLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 5).isActive = true
    }
    ///створення дизайну для collectionViewCell
    func createDesign(){
        posterImageView.image = UIImage(named: "ImageTransformers")
        star.image = UIImage(named: "ImageStar")
        titleLabel.text = "Transformers"
        titleLabel.font = UIFont(name: "Montserrat-Medium", size: 16)
        titleLabel.textColor = .white
        underTextLabel.font = UIFont(name: "Montserrat-Medium", size: 12)
        underTextLabel.textColor = .customColorGrayColor
        let genreText = "Action"
        let pointLabelText = "•"
        let timeMovieText = "2hr 30m | R"
        underTextLabel.text = "\(genreText) \(pointLabelText)  \(timeMovieText)"
    }
    func createDesign1(){
        posterImageView.image = UIImage(named: "ImageTransformersLK")
        star.image = UIImage(named: "ImageStar")
        titleLabel.text = "Transformers 5"
        titleLabel.font = UIFont(name: "Montserrat-Medium", size: 16)
        titleLabel.textColor = .white
        underTextLabel.font = UIFont(name: "Montserrat-Medium", size: 12)
        underTextLabel.textColor = .customColorGrayColor
        let genreText = "Action"
        let pointLabelText = "•"
        let timeMovieText = "2hr 49m | R"
        underTextLabel.text = "\(genreText) \(pointLabelText)  \(timeMovieText)"
    }
}

