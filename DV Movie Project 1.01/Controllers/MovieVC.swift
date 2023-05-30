import UIKit
import Alamofire

class MovieVC: UIViewController{
    
    var searchText = UILabel()
    var searchImage = UIImageView(image: UIImage(systemName: "magnifyingglass"))
    //    var movieInfo = MovieInfoVC()
    var movieCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    var segControl = CustomSegmentControl()
    
    var moviesInfo: [MovieInfoResult] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchMoviesInfo()
        addSubViews()
        setConstraints()
        configChildElements()
        self.view.backgroundColor = .darkBlue
        segControl.backgroundColor = .darkBlue
        self.tabBarController?.delegate = self
        
        segControl.addTarget(self, action: #selector(segmentValueChanged(_:)), for: .valueChanged)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        segControl.layoutSubviews()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setConstraints()
    }
    @objc private func segmentValueChanged(_ sender: UISegmentedControl) {
        if segControl.selectedSegmentIndex == 0 {
            
            fetchMoviesInfo()
            let indexPath = IndexPath(item: 0, section: 0)
            movieCollectionView.scrollToItem(at: indexPath, at: .top, animated: false)
        } else if segControl.selectedSegmentIndex == 1 {
            
            fetchMoviesInfoComingSoon()
            let indexPath = IndexPath(item: 0, section: 0)
            movieCollectionView.scrollToItem(at: indexPath, at: .top, animated: false)
        }
    }
    private func addSubViews() {
        self.view.addSubview(searchText)
        self.view.addSubview(searchImage)
        self.view.addSubview(segControl)
        self.view.addSubview(movieCollectionView)
    }
    
    private func configSegControl() {
        let font = UIFont(name: "Montserrat-Medium", size: 16)
        let normalAttributes: [NSAttributedString.Key: Any] = [.font: font!, .foregroundColor: UIColor.white]
        let selectedAttributes: [NSAttributedString.Key: Any] = [.font: font!, .foregroundColor: UIColor.black]

        segControl.setTitleTextAttributes(normalAttributes, for: .normal)
        segControl.setTitleTextAttributes(selectedAttributes, for: .selected)
        segControl.insertSegment(withTitle: "Now Showing", at: 0, animated: false)
        segControl.insertSegment(withTitle: "Coming Soon", at: 1, animated: false)
        segControl.selectedSegmentIndex = 0
        //                segControl.addTarget(self, action: #selector(segmentValueChanged(_:)), for: .valueChanged)
        
    }
    private func configLabel() {
        searchText.text = "Star Movie"
        searchText.font = UIFont(name: "Montserrat-Medium", size: 24)
        searchText.textColor = .white
        searchImage.tintColor = .white
    }
    
    private func configMovieCollectionView() {
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
        movieCollectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: "MovieCollectionViewCell")
        movieCollectionView.backgroundColor = .darkBlue
    }
    
    private func configChildElements() {
        configSegControl()
        configLabel()
        configMovieCollectionView()
    }
    
    //    @objc private func segmentValueChanged(_ sender: UISegmentedControl) {
    //        movieCollectionView.reloadData()
    //        let indexPath = IndexPath(item: 0, section: 0)
    //        movieCollectionView.scrollToItem(at: indexPath, at: .top, animated: false)
    //
    //    }
    //    @objc private func pageMovie() {
    //        let pagemovie = PageOfMovieVC()
    //        self.navigationController?.pushViewController(pagemovie, animated: true)
    //    }
    
    
    ///позиціювання елементів на view
    private func setConstraints() {
        segControl.setConstraintCustomSegmControl(in: self)
        [searchText,searchImage,movieCollectionView].forEach
        { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        //
        searchText.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 57).isActive = true
        searchText.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -231).isActive = true
        searchText.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        searchImage.centerYAnchor.constraint(equalTo: self.searchText.centerYAnchor).isActive = true
        searchImage.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -24).isActive = true
        searchImage.heightAnchor.constraint(equalToConstant: 24).isActive = true
        searchImage.widthAnchor.constraint(equalTo: self.searchImage.heightAnchor, multiplier: 1).isActive = true
        
        movieCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        movieCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        movieCollectionView.topAnchor.constraint(equalTo: segControl.bottomAnchor, constant: 30).isActive = true
        movieCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    
}
extension MovieVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        moviesInfo.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = movieCollectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as? MovieCollectionViewCell {
            cell.configCell(moviesInfo[indexPath.row])
            
            return cell
            
        }
        
        let testCell = UICollectionViewCell(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        return testCell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let filmInfo = moviesInfo[indexPath.row]
        let page = PageOfMovieVC(filmInfo: filmInfo)
        
        navigationController?.pushViewController(page, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (movieCollectionView.frame.width / 2) - 4, height: 380)
    }
    
    /// Заповнює масив moviesInfo інформацію про фильм
    func fetchMoviesInfo() {
        let urlString = "https://api.themoviedb.org/3/movie/popular?api_key=b8541e6f0d360a89fe91881fcb73d439"
        
        AF.request(urlString).responseDecodable(of: MoviesInfo.self) { response in
            switch response.result {
            case .success(let movieInfo):
                if let results = movieInfo.results {
                    
                    self.moviesInfo = results
                    // Обновите вашу коллекцию данных или выполните другие действия с полученными результатами
                    self.movieCollectionView.reloadData()
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    func fetchMoviesInfoComingSoon() {
        let urlString = "https://api.themoviedb.org/3/movie/upcoming?api_key=871ddc96a542d766d2b0fe03fc0ac3d1"
        
        AF.request(urlString).responseDecodable(of: MoviesInfo.self) { response in
            switch response.result {
            case .success(let movieInfo):
                if let results = movieInfo.results {
                    
                    self.moviesInfo = results
                    // Обновите вашу коллекцию данных или выполните другие действия с полученными результатами
                    results.forEach {
                        print("NEW OBJECT \n")
                        print($0)
                    }
                    self.movieCollectionView.reloadData()
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
}



extension MovieVC: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController == self {
            if segControl.selectedSegmentIndex == 0 {
                movieCollectionView.reloadData()
                let indexPath = IndexPath(item: 0, section: 0)
                movieCollectionView.scrollToItem(at: indexPath, at: .top, animated: true)
            } else if segControl.selectedSegmentIndex == 1 {
                movieCollectionView.reloadData()
                let indexPath = IndexPath(item: 0, section: 0)
                movieCollectionView.scrollToItem(at: indexPath, at: .top, animated: true)
            }
        }
    }
}



//
//// https://api.themoviedb.org/3/movie/upcoming?api_key=871ddc96a542d766d2b0fe03fc0ac3d1
//// https://api.themoviedb.org/3/movie/popular?api_key=871ddc96a542d766d2b0fe03fc0ac3d1
