import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    var filmNameLabel = UILabel()
    let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let starsStackView = UIStackView()
    var starImage = UIImageView()
    var underTextLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupElementsOnCell()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    ///UI конфігурація  елементів в collectionViewCell
    func setupElementsOnCell() {
        self.backgroundColor = .darkBlue
        addSubviews()
        setConstraintsForChildElements()
    }
    
    private func addSubviews() {
        [posterImageView,filmNameLabel, starsStackView, underTextLabel].forEach {
            self.addSubview($0)
        }
        
    }
    
    private func setConstraintsForChildElements() {
        [posterImageView, starsStackView, filmNameLabel,underTextLabel].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        }
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: self.topAnchor),
            posterImageView.heightAnchor.constraint(equalToConstant: 285),
            posterImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            starsStackView.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 16),
            starsStackView.widthAnchor.constraint(equalToConstant: 100),
            starsStackView.heightAnchor.constraint(equalToConstant: 16)
        ])
        
        filmNameLabel.topAnchor.constraint(equalTo: starsStackView.bottomAnchor, constant: 8).isActive = true
        
        filmNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15).isActive = true
        underTextLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4).isActive = true
    }
    
    ///створення дизайну для collectionViewCell
    func designOfElements() {
        filmNameLabel.font = UIFont(name: "Montserrat-Medium", size: 15)
        filmNameLabel.textColor = .white
        underTextLabel.font = UIFont(name: "Montserrat-Medium", size: 10)
        underTextLabel.textColor = .customColorGrayColor
    }
    
    private func configStarsStackView(_ countOfElements: Int) {
        if countOfElements >= 0 && countOfElements <= 5 {
            starsStackView.distribution = .equalSpacing
            
                let filllStarImage = UIImage(systemName: "star.fill")
                let starImage = UIImage(systemName: "star")
                let starTintColor = UIColor(#colorLiteral(red: 1, green: 0.7529411765, blue: 0.2705882353, alpha: 1))
                
                for count in 0...4 {
                    let starView = UIImageView(image: count < (countOfElements) ? filllStarImage : starImage)
                    starView.widthAnchor.constraint(equalToConstant: 20).isActive = true
                    starView.tintColor = starTintColor
                    
                    if starsStackView.arrangedSubviews.count <= 5 {
                        starsStackView.addArrangedSubview(starView)
                    }
                }
            }
    }
    public func configCell(_ filmInfo: MovieInfoResult) {
        designOfElements()
        if let title = filmInfo.title {
            filmNameLabel.text = title
            filmNameLabel.numberOfLines = 2
            
            if let voteAverage = filmInfo.vote_average {
                configStarsStackView(Int(((voteAverage) / Double(2)).rounded()))
                
                if let posterPath = filmInfo.poster_path {
                    let imageURL = URL(string: "https://image.tmdb.org/t/p/w500" + posterPath)!
                    URLSession.shared.dataTask(with: imageURL) { [weak self] data, response, error in
                        guard let data = data, let image = UIImage(data: data) else { return }
                        
                        DispatchQueue.main.async {
                            self?.posterImageView.image = image
                        }
                    }.resume()
                    
                    if let genreIds = filmInfo.genre_ids,
                       let firstGenreId = genreIds.first {
                        let genreIdString: String
                        switch firstGenreId {
                        case 28:
                            genreIdString = "Action"
                        case 12:
                            genreIdString = "Adventure"
                        case 16:
                            genreIdString = "Animation"
                        case 35:
                            genreIdString = "Comedy"
                        case 80:
                            genreIdString = "Crime"
                        case 99:
                            genreIdString = "Documentary"
                        case 18:
                            genreIdString = "Drama"
                        case 10751:
                            genreIdString = "Family"
                        case 14:
                            genreIdString = "Fantasy"
                        case 36:
                            genreIdString = "History"
                        case 27:
                            genreIdString = "Horror"
                        case 10402:
                            genreIdString = "Music"
                        case 9648:
                            genreIdString = "Mystery"
                        case 10749:
                            genreIdString = "Romance"
                        case 878:
                            genreIdString = "Science Fiction"
                        case 10770:
                            genreIdString = "TV Movie"
                        case 53:
                            genreIdString = "Thriller"
                        case 10752:
                            genreIdString = "War"
                        case 37:
                            genreIdString = "Western"
                        default:
                            genreIdString = "Unknown Genre"
                        }

                        if let data = filmInfo.release_date {
                            let dataOfMovie = data
                            
                            if let adult = filmInfo.adult{
                                let adultOfMovie = adult ? "R" : "G"
                                
                                underTextLabel.text = "\(genreIdString) • \(data) | \(adultOfMovie)"
                            }
                        }
                    }
                }
            }
        }
    }
}
