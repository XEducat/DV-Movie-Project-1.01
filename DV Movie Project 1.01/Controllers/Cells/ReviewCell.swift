import UIKit
import Alamofire
import Foundation

class ReviewCell: UITableViewCell {
    private let containerView: UIView = {  // Задній фон до коментаря
        let view = UIView()
        let backgroundColor = UIColor(#colorLiteral(red: 0.1685389876, green: 0.2090523839, blue: 0.2594455481, alpha: 1))
        view.backgroundColor = backgroundColor
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let triangleToContainer: TriangleView = {  // Трикунтна частина фону до коментаря
        let triangleView = TriangleView()
        triangleView.backgroundColor = .clear
        return triangleView
    }()
    
    private let starsStackView: UIStackView =  {  // Оцінка глядача
        let stackView = UIStackView()
        
        return stackView
    }()
    
    private let authorComment: UILabel = {  // Коментар глядача
        let label = UILabel()
        let commentColor = UIColor(#colorLiteral(red: 0.7463386655, green: 0.761274755, blue: 0.778211236, alpha: 1))
        label.textColor = commentColor
        label.numberOfLines = 0
        return label
    }()
    
    private let avatarImage: UIImageView = {  // Аватарка корістувача
        let imageView = UIImageView()
        imageView.backgroundColor = .black
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 30
        return imageView
    }()
    
    private let authorName: UILabel = {  // Ім'я корстувача
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    
    private let dateLabel: UILabel = {  // Дата коментаря 
        let label = UILabel()
        let dateColor = UIColor(#colorLiteral(red: 0.5297212601, green: 0.5496682525, blue: 0.5879128575, alpha: 1))
        label.textColor = dateColor
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .darkBlue
        
        [containerView, authorComment, avatarImage, authorName, dateLabel, starsStackView, triangleToContainer].forEach{
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        setupConstraints()
    }
    
    /// Виставляє обмеження ( constraints ) для елементів cell
    private func setupConstraints(){
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            containerView.bottomAnchor.constraint(equalTo: avatarImage.topAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            triangleToContainer.widthAnchor.constraint(equalToConstant: 20),
            triangleToContainer.heightAnchor.constraint(equalToConstant: 15),
            triangleToContainer.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 37),
            triangleToContainer.topAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            starsStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 30),
            starsStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            starsStackView.heightAnchor.constraint(equalToConstant: 22)
        ])
        
        NSLayoutConstraint.activate([
            authorComment.topAnchor.constraint(equalTo: starsStackView.bottomAnchor, constant: 10),
            authorComment.leadingAnchor.constraint(equalTo: starsStackView.leadingAnchor),
            authorComment.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            authorComment.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            avatarImage.leadingAnchor.constraint(equalTo: starsStackView.leadingAnchor),
            avatarImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            avatarImage.heightAnchor.constraint(equalToConstant: 60),
            avatarImage.widthAnchor.constraint(equalTo: avatarImage.heightAnchor)
            
        ])
        
        NSLayoutConstraint.activate([
            authorName.topAnchor.constraint(equalTo: avatarImage.topAnchor, constant: 5),
            authorName.leadingAnchor.constraint(equalTo: avatarImage.trailingAnchor, constant: 20),
            authorName.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: authorName.bottomAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: authorName.leadingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: avatarImage.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Формує блок ( cell )
    func configure(with reviewResult: ReviewResult) {
        if let author = reviewResult.author {
            authorName.text = author
        }
        
        if let avatarPath = reviewResult.author_details?.avatar_path {
            setAvatarImage(avatarPath)
        }
        
        let rating = reviewResult.author_details?.rating
        setStarRating(rating)
        
        if let content = reviewResult.content {
            authorComment.text = content
        }
        
//        if let totalRewiews = reviewResult.
        
        if let createdAt = reviewResult.created_at {
            setDateInFormat(createdAt)
        }
    }
    
    /// Виводить аватарку користувача на екран
    private func setAvatarImage(_ path:String){
        var pathToImage = path
        
        if(pathToImage.first == "/" && pathToImage.contains("http")) {
            pathToImage.removeFirst()
        }
        else {
            pathToImage = "https://secure.gravatar.com/avatar" + pathToImage
        }
        
        AF.download(pathToImage).responseData { response in
            if let data = response.value {
                DispatchQueue.main.async {
                    self.avatarImage.image = UIImage(data: data)
                }
            }
        }
    }
    
    /// Виводить оцінку глядача на екран
    private func setStarRating(_ rating:Double? ){
        if(rating != nil) {
            setupStarsStackView(rating: Int(rating! / 2))
        } else {
            setupStarsStackView(rating: 0)
        }
    }
    
    /// Виводить дану написання коментаря
    private func setDateInFormat(_ date: String){
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        if let inputDate = inputDateFormatter.date(from: date) {
            let outputDateFormatter = DateFormatter()
            outputDateFormatter.dateFormat = "MMM d, yyyy"
            
            let outputDateStr = outputDateFormatter.string(from: inputDate)
            dateLabel.text = outputDateStr
        } else {
            print("Неможливо розпізнати дату.")
        }
    }
    
    private func setupStarsStackView(rating: Int) {
        if rating >= 0 && rating <= 5 {
            starsStackView.distribution = .equalSpacing
            
            let filllStarImage = UIImage(systemName: "star.fill")
            let starImage = UIImage(systemName: "star")
            let starTintColor = UIColor(#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1))
            
            for count in 1...5 {
                let starView = UIImageView(image: count <= rating ? filllStarImage : starImage)
                starView.widthAnchor.constraint(equalToConstant: 22).isActive = true
                starView.tintColor = starTintColor
                
                starView.image = rating < count ? starImage : filllStarImage
                if starsStackView.arrangedSubviews.count < 5 {
                    starsStackView.addArrangedSubview(starView)
                }
            }
        }
    }
}



import UIKit

class TriangleView: UIView {
    /// Добавленно для виставлення Constraints екземплярам
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: UIView.noIntrinsicMetric)
    }
    
    override func draw(_ rect: CGRect) {
       guard let context = UIGraphicsGetCurrentContext() else { return }
       
       context.beginPath()
       context.move(to: CGPoint(x: rect.minX, y: rect.minY))
       context.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
       context.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
       context.closePath()
       
       // Задайте бажану заливку та обводку для вашого трьохкутника
       let fillColor = UIColor(#colorLiteral(red: 0.1685389876, green: 0.2090523839, blue: 0.3103633803, alpha: 1)).cgColor
       context.setFillColor(fillColor)
       context.setStrokeColor(UIColor.black.cgColor)
       
       // Заповніть трьохкутник
       context.fillPath()
       
       // Намалюйте контур трьохкутника
        context.strokePath()
   }
}
