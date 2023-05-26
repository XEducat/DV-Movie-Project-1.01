import UIKit
import Alamofire

class ReviewsVC: UIViewController {
    private let apiKey = "871ddc96a542d766d2b0fe03fc0ac3d1"
    private var reviews: [ReviewResult] = []
    
    private var commentsTable: UITableView = {  // Коментарі до фільму
        let tableView = UITableView()
        tableView.backgroundColor = .darkBlue
        tableView.register(ReviewCell.self, forCellReuseIdentifier: "FrameCellTest")
        return tableView
    }()
    
    private var totalRating: UILabel = {  // Загальний рейтинг
        let label = UILabel()
        label.font = UIFont(name: "Arial", size: 28)
        label.textColor = .white
        return label
    }()
    
    private var totalRatingStars: UIStackView = {  // Загальний рейтинг в зірках
        let stackView = UIStackView()
        
        return stackView
    }()
    
    /// При ініціалізації передається id фільму для завантаження данних
    init(movieID: Int) {
        super.init(nibName: nil, bundle: nil)
        
        self.fetchReviews(movieId: movieID)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .darkBlue
        
        configureController()
        setupConstraints()
    }
    
    /// Добавляє UITableView на view
    private func configureController() {
        commentsTable.delegate = self
        commentsTable.dataSource = self
        
        [commentsTable, totalRating, totalRatingStars].forEach{
            self.view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    /// Виставляє обмеження ( constraints ) для елементів view
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            commentsTable.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 200),
            commentsTable.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            commentsTable.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            commentsTable.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            totalRating.bottomAnchor.constraint(equalTo: self.commentsTable.topAnchor, constant: -60),
            totalRating.leadingAnchor.constraint(equalTo: self.commentsTable.leadingAnchor, constant: 80)
        ])
        
        NSLayoutConstraint.activate([
            totalRatingStars.leadingAnchor.constraint(equalTo: totalRating.trailingAnchor, constant: 10),
            totalRatingStars.centerYAnchor.constraint(equalTo: totalRating.centerYAnchor),
            totalRatingStars.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    /// Підвантажує отзиви з фільму в масив reviews
    private func fetchReviews(movieId: Int) {
        let urlString = "https://api.themoviedb.org/3/movie/\(movieId)/reviews?api_key=\(apiKey)"
        
        AF.request(urlString).responseDecodable(of: Review.self) { response in
            switch response.result {
            case .success(let review):
                if let results = review.results {
                    self.reviews = results
                    self.calculateAverageRating()
                    self.commentsTable.reloadData()
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    /// Підраховує загальний рейтинг
    private func calculateAverageRating() {
        guard !reviews.isEmpty else {
            totalRating.text = "0.0/5"
            return
        }
        
        let sum = reviews.reduce(0.0) { $0 + ($1.author_details?.rating ?? 0.0) }
        let totalAverage = Int((sum / Double(reviews.count)) / 2)
        totalRating.text = "\(totalAverage)/5"
        
        setupStarsStackView(rating: totalAverage)
    }
    
    /// Віставляє зірки в залежності від рейтингу
    private func setupStarsStackView(rating: Int) {
        if rating >= 0 && rating <= 5 {
            totalRatingStars.distribution = .equalSpacing
            
            let filllStarImage = UIImage(systemName: "star.fill")
            let starImage = UIImage(systemName: "star")
            let starTintColor = UIColor(#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1))
            
            for count in 1...5 {
                let starView = UIImageView(image: count <= rating ? filllStarImage : starImage)
                starView.widthAnchor.constraint(equalToConstant: 30).isActive = true
                starView.tintColor = starTintColor
                
                starView.image = rating < count ? starImage : filllStarImage
                if totalRatingStars.arrangedSubviews.count < 5 {
                    totalRatingStars.addArrangedSubview(starView)
                }
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension ReviewsVC: UITableViewDelegate, UITableViewDataSource {
    /// Віставляє кількість блоків в таблиці ( TableView )
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    /// Повертає налаштований блок ( cell )
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FrameCellTest", for: indexPath) as! ReviewCell
        let backgroundView = UIView()
        backgroundView.backgroundColor = .darkBlue
        cell.selectedBackgroundView = backgroundView
        let review = reviews[indexPath.row]
        cell.configure(with: review)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 320
    }
}
