import UIKit
import Alamofire

class PageOfMovieVC: UIViewController {
    var scrollView = UIScrollView()
    
    var backImage = UIImageView()
    
    var posterImageView = UIImageView()
    
    var titleOfMovieLabel = UILabel()
    
    var releaseAndRatingMovieLabel = UILabel()
    var genreOfMovie = UILabel()
    var RatingAndStarsStackView = UIStackView()
    
    var descriptionOfMovieLabel = UILabel()
    var descriptionTextOfMovieLabel = UILabel()
    
    var castAndCrewStackView = UIStackView()
    var castAndCrewTableView = UITableView()
    
    var photosStackView = UIStackView()
    
    var photosScrollView = UIScrollView()
    var firstPhoto = UIImageView()
    var secondPhoto = UIImageView()
    var theerdPhoto = UIImageView()
    var fourPhoto = UIImageView()
    var fivePhoto = UIImageView()
    
    var videoStackView = UIStackView()
    var videoScrollView = UIScrollView()
    
    var firstVideo = UIImageView()
    var secondVideo = UIImageView()
    var theerdVideo = UIImageView()
    var fourVideo = UIImageView()
    var fiveVideo = UIImageView()
//    var filmId: Int?
    
    var filmInfo: MovieInfoResult?
    
    let apiKey = "f5fc273d435f10ca0130435f60524443"
    
    var cast: [Cast] = []
    var backdrops: [Backdrops] = []
    
    init(filmInfo: MovieInfoResult) {
        super.init(nibName: nil, bundle: nil)
        self.filmInfo = filmInfo
        print("filmInfo: \(filmInfo)")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        castAndCrewTableView.delegate = self
        castAndCrewTableView.dataSource = self
        
        
        addSubviews()
        setConstraints()
        
        self.scrollView.backgroundColor = .blue
        self.view.backgroundColor = .yellow
        castAndCrewTableView.isScrollEnabled = false
        styleElements()
        setTextsForLabels()
        configCastAndCrewStackView()
        confiPhotosStackView()
        confiVideoStackView()
        
        fetchMovieFrames(movieId: filmInfo?.id ?? 0)
        
        fetchCast(movieID: filmInfo?.id ?? 0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configScroll()
        configPhotoScroll()
        configVideoScroll()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    private func addSubviews() {
        self.view.addSubview(scrollView)
        
        [titleOfMovieLabel, backImage, posterImageView, releaseAndRatingMovieLabel, genreOfMovie, RatingAndStarsStackView, descriptionOfMovieLabel,descriptionTextOfMovieLabel,castAndCrewStackView,castAndCrewTableView,photosStackView, photosScrollView,videoStackView,videoScrollView].forEach {
            scrollView.addSubview($0)
        }
       
        [firstPhoto,secondPhoto,theerdPhoto,fourPhoto,fivePhoto].forEach {
            photosScrollView.addSubview($0)
        }
        [firstVideo, secondVideo, theerdVideo, fourVideo, fiveVideo].forEach {
            videoScrollView.addSubview($0)
        }
        
    }
    
    private func styleElements() {
        scrollView.backgroundColor = .darkBlue
        
        if let backImage = filmInfo?.backdrop_path {
            let imageURL = URL(string: "https://image.tmdb.org/t/p/w500" + backImage)!
            URLSession.shared.dataTask(with: imageURL) { [weak self] data, response, error in
                guard let data = data, let image = UIImage(data: data) else { return }
                
                DispatchQueue.main.async {
                    let blurFilter = CIFilter(name: "CIGaussianBlur")
                    blurFilter?.setValue(CIImage(image: image), forKey: kCIInputImageKey)
                    blurFilter?.setValue(4, forKey: kCIInputRadiusKey)
                    if let outputImage = blurFilter?.outputImage {
                    let context = CIContext(options: nil)
                    if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                    let blurredImage = UIImage(cgImage: cgImage)
                    self?.backImage.image = blurredImage
                        }
                    }
                }
             }.resume()
            
        }
        
        //backImage.image = UIImage(named: "ImageTransformers")
        backImage.contentMode = .scaleAspectFill
        backImage.clipsToBounds = true
        
        if let posterPath = filmInfo?.poster_path {
            let imageURL = URL(string: "https://image.tmdb.org/t/p/w500" + posterPath)!
            URLSession.shared.dataTask(with: imageURL) { [weak self] data, response, error in
                guard let data = data, let image = UIImage(data: data) else { return }
                
                DispatchQueue.main.async {
                    self?.posterImageView.image = image
                }
            }.resume()
        }
        
        titleOfMovieLabel.textColor = .white
        titleOfMovieLabel.text = filmInfo?.title ?? ""
        titleOfMovieLabel.font = UIFont(name: "Montserrat-Medium", size: 20)
        
        [releaseAndRatingMovieLabel, genreOfMovie,descriptionTextOfMovieLabel].forEach {
            $0.font = UIFont(name: "Montserrat-Medium", size: 14)
            $0.textColor = .customColorGrayColor
        }
        
        descriptionOfMovieLabel.font = UIFont(name: "Montserrat-Medium", size: 17)
        descriptionOfMovieLabel.textColor = .white
        
        castAndCrewTableView.backgroundColor = .darkBlue
        castAndCrewTableView.register(ActorCell.self, forCellReuseIdentifier: "TableViewCell")
        
        photosScrollView.backgroundColor = .darkBlue
        
        [firstPhoto,secondPhoto,theerdPhoto,fourPhoto,fivePhoto].forEach {
            $0.backgroundColor = .black
        }
        
        videoScrollView.backgroundColor = .darkBlue
        
        [firstVideo, secondVideo, theerdVideo, fourVideo, fiveVideo].forEach {
            $0.backgroundColor = .white
        }
        
    }
    
    private func setConstraints() {
        [titleOfMovieLabel, backImage,posterImageView,releaseAndRatingMovieLabel, genreOfMovie,RatingAndStarsStackView,descriptionOfMovieLabel,descriptionTextOfMovieLabel,castAndCrewStackView,castAndCrewTableView, photosStackView, photosScrollView,firstPhoto,secondPhoto,theerdPhoto,fourPhoto,fivePhoto, videoStackView, videoScrollView, firstVideo, secondVideo, theerdVideo, fourVideo, fiveVideo].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
        NSLayoutConstraint.activate([
            scrollView.contentLayoutGuide.topAnchor.constraint(equalTo: self.view.topAnchor),
            scrollView.contentLayoutGuide.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            scrollView.contentLayoutGuide.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            backImage.topAnchor.constraint(equalTo: self.scrollView.topAnchor,constant: -60),
            backImage.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
            backImage.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            backImage.heightAnchor.constraint(equalToConstant: 250)
        ])
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 72),
            posterImageView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 115),
            posterImageView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor, constant: -115),
            posterImageView.heightAnchor.constraint(equalToConstant: 250)
        ])
        
        NSLayoutConstraint.activate([
            titleOfMovieLabel.topAnchor.constraint(equalTo: self.posterImageView.bottomAnchor, constant: 32),
            titleOfMovieLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            titleOfMovieLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        NSLayoutConstraint.activate ([
            releaseAndRatingMovieLabel.topAnchor.constraint(equalTo: self.titleOfMovieLabel.bottomAnchor, constant: 16),
            releaseAndRatingMovieLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            releaseAndRatingMovieLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
        
        NSLayoutConstraint.activate ([
            genreOfMovie.topAnchor.constraint(equalTo: self.releaseAndRatingMovieLabel.bottomAnchor, constant: 8),
            genreOfMovie.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            genreOfMovie.heightAnchor.constraint(equalToConstant: 18)
        ])
        
        NSLayoutConstraint.activate([
            RatingAndStarsStackView.topAnchor.constraint(equalTo: self.genreOfMovie.bottomAnchor, constant: 29),
            RatingAndStarsStackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            RatingAndStarsStackView.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        NSLayoutConstraint.activate([
            descriptionOfMovieLabel.topAnchor.constraint(equalTo: self.RatingAndStarsStackView.bottomAnchor, constant: 30),
            descriptionOfMovieLabel.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 18),
            descriptionOfMovieLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
        
        NSLayoutConstraint.activate([
            descriptionTextOfMovieLabel.topAnchor.constraint(equalTo: self.descriptionOfMovieLabel.bottomAnchor, constant: 16),
            descriptionTextOfMovieLabel.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 18),
            descriptionTextOfMovieLabel.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor, constant: -18),
            descriptionTextOfMovieLabel.heightAnchor.constraint(equalToConstant: 120)
        ])
        
        NSLayoutConstraint.activate([
            castAndCrewStackView.topAnchor.constraint(equalTo: self.descriptionTextOfMovieLabel.bottomAnchor, constant: 20),
            castAndCrewStackView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 18),
            castAndCrewStackView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor, constant: -18),
            castAndCrewStackView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            castAndCrewTableView.topAnchor.constraint(equalTo: self.castAndCrewStackView.bottomAnchor, constant: 10),
            castAndCrewTableView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            castAndCrewTableView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
            castAndCrewTableView.heightAnchor.constraint(equalToConstant: 400)
        ])
        
        NSLayoutConstraint.activate([
            photosStackView.topAnchor.constraint(equalTo: self.castAndCrewTableView.bottomAnchor, constant: 30),
            photosStackView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 18),
            photosStackView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor, constant: -18),
            photosStackView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            photosScrollView.topAnchor.constraint(equalTo: self.photosStackView.topAnchor,constant: 50),
            photosScrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            photosScrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            photosScrollView.heightAnchor.constraint(equalToConstant: 250)
        ])
        
        NSLayoutConstraint.activate([
            firstPhoto.topAnchor.constraint(equalTo: self.photosScrollView.topAnchor,constant: 10),
            firstPhoto.leadingAnchor.constraint(equalTo: self.photosScrollView.leadingAnchor, constant: 25),
            firstPhoto.heightAnchor.constraint(equalToConstant: 230),
            firstPhoto.widthAnchor.constraint(equalToConstant: 300)
        ])
        
        NSLayoutConstraint.activate([
            secondPhoto.topAnchor.constraint(equalTo: self.photosScrollView.topAnchor,constant: 10),
            secondPhoto.leadingAnchor.constraint(equalTo: self.firstPhoto.trailingAnchor, constant: 10),
            secondPhoto.heightAnchor.constraint(equalToConstant: 230),
            secondPhoto.widthAnchor.constraint(equalToConstant: 300)
        ])
        
        NSLayoutConstraint.activate([
            theerdPhoto.topAnchor.constraint(equalTo: self.photosScrollView.topAnchor,constant: 10),
            theerdPhoto.leadingAnchor.constraint(equalTo: self.secondPhoto.trailingAnchor, constant: 10),
            theerdPhoto.heightAnchor.constraint(equalToConstant: 230),
            theerdPhoto.widthAnchor.constraint(equalToConstant: 300)
        ])
        
        NSLayoutConstraint.activate([
            fourPhoto.topAnchor.constraint(equalTo: self.photosScrollView.topAnchor,constant: 10),
            fourPhoto.leadingAnchor.constraint(equalTo: self.theerdPhoto.trailingAnchor, constant: 10),
            fourPhoto.heightAnchor.constraint(equalToConstant: 230),
            fourPhoto.widthAnchor.constraint(equalToConstant: 300)
        ])
        
        NSLayoutConstraint.activate([
            fivePhoto.topAnchor.constraint(equalTo: self.photosScrollView.topAnchor,constant: 10),
            fivePhoto.leadingAnchor.constraint(equalTo: self.fourPhoto.trailingAnchor, constant: 10),
            fivePhoto.heightAnchor.constraint(equalToConstant: 230),
            fivePhoto.widthAnchor.constraint(equalToConstant: 300)
        ])
        
        NSLayoutConstraint.activate([
            videoStackView.topAnchor.constraint(equalTo: self.photosScrollView.bottomAnchor,constant: 10),
            videoStackView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 18),
            videoStackView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor, constant: -18),
            videoStackView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            videoScrollView.topAnchor.constraint(equalTo: self.videoStackView.topAnchor,constant: 50),
            videoScrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            videoScrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            videoScrollView.heightAnchor.constraint(equalToConstant: 250)
        ])
        
        NSLayoutConstraint.activate([
            firstVideo.topAnchor.constraint(equalTo: self.videoScrollView.topAnchor,constant: 10),
            firstVideo.leadingAnchor.constraint(equalTo: self.videoScrollView.leadingAnchor, constant: 25),
            firstVideo.heightAnchor.constraint(equalToConstant: 230),
            firstVideo.widthAnchor.constraint(equalToConstant: 300)
        ])
        
        NSLayoutConstraint.activate([
            secondVideo.topAnchor.constraint(equalTo: self.videoScrollView.topAnchor,constant: 10),
            secondVideo.leadingAnchor.constraint(equalTo: self.firstVideo.trailingAnchor, constant: 10),
            secondVideo.heightAnchor.constraint(equalToConstant: 230),
            secondVideo.widthAnchor.constraint(equalToConstant: 300)
        ])
        
        NSLayoutConstraint.activate([
            theerdVideo.topAnchor.constraint(equalTo: self.videoScrollView.topAnchor,constant: 10),
            theerdVideo.leadingAnchor.constraint(equalTo: self.secondVideo.trailingAnchor, constant: 10),
            theerdVideo.heightAnchor.constraint(equalToConstant: 230),
            theerdVideo.widthAnchor.constraint(equalToConstant: 300)
        ])
        
        NSLayoutConstraint.activate([
            fourVideo.topAnchor.constraint(equalTo: self.videoScrollView.topAnchor,constant: 10),
            fourVideo.leadingAnchor.constraint(equalTo: self.theerdVideo.trailingAnchor, constant: 10),
            fourVideo.heightAnchor.constraint(equalToConstant: 230),
            fourVideo.widthAnchor.constraint(equalToConstant: 300)
        ])
        
        NSLayoutConstraint.activate([
            fiveVideo.topAnchor.constraint(equalTo: self.videoScrollView.topAnchor,constant: 10),
            fiveVideo.leadingAnchor.constraint(equalTo: self.fourVideo.trailingAnchor, constant: 10),
            fiveVideo.heightAnchor.constraint(equalToConstant: 230),
            fiveVideo.widthAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    private func setTextsForLabels() {
        var releaseData = filmInfo?.release_date ?? ""
        if let adult = filmInfo?.adult{
            let ratingMovie = adult ? "R" : "G"
            releaseAndRatingMovieLabel.text = "\(releaseData) | \(ratingMovie)"
            
            if let genreIds = filmInfo?.genre_ids, genreIds.count >= 3 {
                let firstThreeGenreIds = Array(genreIds.prefix(3))
                
                var genreIdStrings: [String] = []
                for genreId in firstThreeGenreIds {
                    let genreIdString: String
                    switch genreId {
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
                    genreIdStrings.append(genreIdString)
                    
                }
                
                let genreLabelText = genreIdStrings.joined(separator: ", ")
                    genreOfMovie.text = genreLabelText
                
                descriptionOfMovieLabel.text = "Synopsis"
                
                descriptionTextOfMovieLabel.numberOfLines = 0
                
                descriptionTextOfMovieLabel.text = filmInfo?.overview ?? ""
                
                if let voteAverage = filmInfo?.vote_average {
                    if let voteAverage = filmInfo?.vote_average {
                        let ratingLabel = UILabel()
                        ratingLabel.text = String("\(voteAverage / 2)/5")
                        ratingLabel.font = UIFont(name: "Montserrat-Medium", size: 20)
                        ratingLabel.textColor = .white
                        RatingAndStarsStackView.addArrangedSubview(ratingLabel)
                        configStarsStackView(Int(((voteAverage) / Double(2)).rounded()))
                        
                    }
                }
            }
        }
    }
    private func configStarsStackView(_ countOfElements: Int) {
        if countOfElements >= 0 && countOfElements <= 5 {
            RatingAndStarsStackView.distribution = .equalSpacing
            
                let filllStarImage = UIImage(systemName: "star.fill")
                let starImage = UIImage(systemName: "star")
                let starTintColor = UIColor(#colorLiteral(red: 1, green: 0.7529411765, blue: 0.2705882353, alpha: 1))
                
                for count in 0...4 {
                    let starView = UIImageView(image: count < (countOfElements) ? filllStarImage : starImage)
                    starView.widthAnchor.constraint(equalToConstant: 20).isActive = true
                    starView.tintColor = starTintColor
                    
                    if RatingAndStarsStackView.arrangedSubviews.count <= 5 {
                        RatingAndStarsStackView.addArrangedSubview(starView)
                    }
                }
            }
        
    }
    private func configCastAndCrewStackView() {
        let textLabel = UILabel()
        textLabel.text = "Cast & Crew"
        textLabel.font = UIFont(name: "Montserrat-Medium", size: 18)
        textLabel.textColor = .white
        castAndCrewStackView.addArrangedSubview(textLabel)
        
        let viewAllButton = UIButton()
        viewAllButton.setTitle("View All", for: .normal)
        viewAllButton.setTitleColor(.systemTeal, for: .normal)
        castAndCrewStackView.addArrangedSubview(viewAllButton)
        
        viewAllButton.addTarget(self, action: #selector(viewAllButtonTapped), for: .touchUpInside)
    }
    
    @objc private func viewAllButtonTapped() {
        let castAndCrewVC = CastAndCrewVC(movieID: filmInfo?.id ?? 0)
        navigationController?.pushViewController(castAndCrewVC, animated: true)
    }
    
    private func confiPhotosStackView() {
        let textPhotoLabel = UILabel()
        textPhotoLabel.text = "Photos"
        textPhotoLabel.font = UIFont(name: "Montserrat-Medium", size: 18)
        textPhotoLabel.textColor = .white
        photosStackView.addArrangedSubview(textPhotoLabel)
        
        let viewAllPhotosButton = UIButton()
        viewAllPhotosButton.setTitle("View All", for: .normal)
        viewAllPhotosButton.setTitleColor(.systemTeal, for: .normal)
        photosStackView.addArrangedSubview(viewAllPhotosButton)
        
        viewAllPhotosButton.addTarget(self, action: #selector(viewAllPhotoButtonTapped), for: .touchUpInside)
    }
    
    @objc private func viewAllPhotoButtonTapped() {
        let movieframesvc = MovieFramesVC(movieID: filmInfo?.id ?? 0)
        navigationController?.pushViewController(movieframesvc, animated: true)
    }
    
    
    private func confiVideoStackView() {
        let textVideoLabel = UILabel()
        textVideoLabel.text = "Videos"
        textVideoLabel.font = UIFont(name: "Montserrat-Medium", size: 18)
        textVideoLabel.textColor = .white
        videoStackView.addArrangedSubview(textVideoLabel)
        
        let viewAllVideosButton = UIButton()
        viewAllVideosButton.setTitle("View All", for: .normal)
        viewAllVideosButton.setTitleColor(.systemTeal, for: .normal)
        videoStackView.addArrangedSubview(viewAllVideosButton)
        
        //  viewAllButton.addTarget(self, action: #selector(viewAllButtonTapped), for: .touchUpInside)
    }
    
    
    //    private func configCastAndCrewStackView() {
    //        let textLabel = UILabel()
    //                textLabel.text = "Cast & Crew"
    //                textLabel.font = UIFont(name: "Montserrat-Medium", size: 18)
    //                textLabel.textColor = .white
    //        castAndCrewStackView.addArrangedSubview(textLabel)
    //        let viewAllButton = UIButton()
    //        viewAllButton.setTitle("View All", for: .normal)
    //        viewAllButton.setTitleColor(.systemTeal, for: .normal)
    //        castAndCrewStackView.addArrangedSubview(viewAllButton)
    //
    //        viewAllButton.addTarget(self, action: #selector(viewAllButtonTapped), for: .touchUpInside)
    //
    //        @objc private func viewAllButtonTapped() {
    //            let castAndCrewVC = CastAndCrewVC(filmInfo: filmInfo)
    //            navigationController?.pushViewController(castAndCrewVC, animated: true)
    //        }
    //}
    
    //    public func configCell(_ filmInfo: MovieInfoResult) {
    //        if let voteAverage = filmInfo.vote_average {
    //            configStarsStackView(Int(voteAverage / 2))
    //        }
    //    }
    
    private func configScroll() {
        let contentHeight = castAndCrewTableView.frame.origin.y + castAndCrewTableView.frame.height + 630
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: contentHeight)
    }
    
    private func configPhotoScroll() {
        let contentHeight = castAndCrewTableView.frame.origin.y + castAndCrewTableView.frame.height
        photosScrollView.contentSize = CGSize(width: 1585, height: photosScrollView.frame.height)
    }
    
    private func configVideoScroll() {
        let contentHeight = castAndCrewTableView.frame.origin.y + castAndCrewTableView.frame.height - 30
        videoScrollView.contentSize = CGSize(width: 1585, height: videoScrollView.frame.height)
    }
    
    func fetchCast(movieID: Int) {
        let url = "https://api.themoviedb.org/3/movie/\(movieID)/credits?api_key=\(apiKey)"
        AF.request(url).responseDecodable(of: Film.self) { response in
            switch response.result {
            case .success(let castResponse):
                if let cast = castResponse.cast {
                    self.cast = cast
                    self.castAndCrewTableView.reloadData()
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    private func fetchMovieFrames(movieId: Int) {
        
        let urlString = "https://api.themoviedb.org/3/movie/\(movieId)/images?api_key=\(apiKey)"
        
        AF.request(urlString).responseDecodable(of: MovieFrames.self) { response in
            switch response.result {
            case .success(let imageResponse):
                self.backdrops = imageResponse.backdrops ?? []
                
                let backdropsCount = self.backdrops.count
                
                var i = 0
                while i < backdropsCount {
                    if i <= (self.photosScrollView.subviews.count - 1) {
                        if let photoView = self.photosScrollView.subviews[i] as? UIImageView {
                            let imageUrlString = "https://image.tmdb.org/t/p/w500" + (self.backdrops[i].file_path ?? "")
                            AF.request(imageUrlString).responseData { response in
                                switch response.result {
                                case .success(let imageData):
                                    if let image = UIImage(data: imageData) {
                                        photoView.image = image
                                    }
                                case .failure(let error):
                                    print("Error downloading image: \(error)")
                                }
                            }
                        }

                        
                    }
                    i += 1
                }
                
                //                let imageUrlString = "https://image.tmdb.org/t/p/w500" + filePath
                //                AF.request(imageUrlString).responseData { response in
                //                    switch response.result {
                //                    case .success(let imageData):
                //                        if let image = UIImage(data: imageData) {
                //                            self.frameImageView.image = image
                //                        }
                //                    case .failure(let error):
                //                        print("Error downloading image: \(error)")
                //                    }
                //                }
                // self.photosScrollView.reloadData()
            case .failure(let error):
                print("Error fetching movie frames: \(error)")
            }
        }
    }
}
extension UIImage {
    func applyBlurEffect() -> UIImage? {
        let context = CIContext(options: nil)
        guard let ciImage = CIImage(image: self) else { return nil }
        
        let filter = CIFilter(name: "CIGaussianBlur")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        filter?.setValue(10, forKey: kCIInputRadiusKey)
        
        guard let outputImage = filter?.outputImage,
              let cgImage = context.createCGImage(outputImage, from: ciImage.extent) else {
            return nil
        }
        
        return UIImage(cgImage: cgImage)
    }
}
extension PageOfMovieVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? ActorCell {
            let backgroundView = UIView()
            backgroundView.backgroundColor = .darkBlue
            cell.selectedBackgroundView = backgroundView
            cell.configCell(cast: cast[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return min(4, cast.count)
        //return cast.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
