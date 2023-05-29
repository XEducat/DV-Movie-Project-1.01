import UIKit
import Alamofire

class MovieVC: UIViewController{
    
    var searchText = UILabel()
    var searchImage = UIImageView(image: UIImage(systemName: "magnifyingglass"))
    var movieInfo = MovieInfoVC()
    var movieCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    var segControl = CustomSegmentControl()
    
    var testArr = ["title1", "title2", "title1", "title2", "title1", "title2"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
        setConstraints()
        configChildElements()
        self.view.backgroundColor = .someDarkOfBlue
        self.tabBarController?.delegate = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        segControl.backgroundColor = .someDarkOfBlue
        segControl.layoutSubviews()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        let indexPath = IndexPath(item: 0, section: 0)
        setConstraints()
    }
    
    private func addSubViews() {
        self.view.addSubview(searchText)
        self.view.addSubview(searchImage)
        self.view.addSubview(segControl)
        self.view.addSubview(movieCollectionView)
    }
    
    private func configSegControl() {
        let font = UIFont(name: "Montserrat-Medium", size: 16)
        let attributes: [NSAttributedString.Key: Any] = [ .font: font!, ]
        segControl.setTitleTextAttributes(attributes, for: .normal)
        segControl.insertSegment(withTitle: "Now Showing", at: 0, animated: false)
        segControl.insertSegment(withTitle: "Coming Soon", at: 1, animated: false)
        segControl.selectedSegmentIndex = 0
//        segControl.addTarget(self, action: #selector(segmentValueChanged(_:)), for: .valueChanged)
        
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
        movieCollectionView.backgroundColor = .someDarkOfBlue
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
    
    func testRequest() {}
}
extension MovieVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return moviesArr?.count ?? 0
        1
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        testArr.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if let cell = movieCollectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as? MovieCollectionViewCell {
            return cell
        }
        
        let testCell = UICollectionViewCell(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        return testCell

    }


//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: (movieCollectionView.frame.width / 2) - 4, height: 350)
//    }
}
extension MovieVC: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController == self {
            if segControl.selectedSegmentIndex == 0 {
//                movieCollectionView.reloadData()
                let indexPath = IndexPath(item: 0, section: 0)
//                movieCollectionView.scrollToItem(at: indexPath, at: .top, animated: true)
            } else if segControl.selectedSegmentIndex == 1 {
//                movieCollectionView.reloadData()
                let indexPath = IndexPath(item: 0, section: 0)
//                movieCollectionView.scrollToItem(at: indexPath, at: .top, animated: true)
            }
        }
    }
}
//
//// https://api.themoviedb.org/3/movie/upcoming?api_key=871ddc96a542d766d2b0fe03fc0ac3d1
//// https://api.themoviedb.org/3/movie/popular?api_key=871ddc96a542d766d2b0fe03fc0ac3d1
