import UIKit
import Alamofire

class CastAndCrewVC: UIViewController {
    let apiKey = "871ddc96a542d766d2b0fe03fc0ac3d1"
    let tableView = UITableView()
    var cast: [Cast] = []
    
    init(movieID: Int) {
        super.init(nibName: nil, bundle: nil)
        self.fetchCast(movieID: movieID)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        view.backgroundColor = UIColor.darkBlue
        tableView.delegate = self
        tableView.dataSource = self
        setupTableView()
        setupConstraints()
    }
    
    func setupTableView() {
        tableView.backgroundColor = UIColor.darkBlue
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(ActorCell.self, forCellReuseIdentifier: "TableViewCell")
    }
    
    func setupConstraints() {
        [tableView].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    func fetchCast(movieID: Int) {
        let url = "https://api.themoviedb.org/3/movie/\(movieID)/credits?api_key=\(apiKey)"
        AF.request(url).responseDecodable(of: Film.self) { response in
            switch response.result {
            case .success(let castResponse):
                if let cast = castResponse.cast {
                    self.cast = cast
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - Extension
extension CastAndCrewVC: UITableViewDelegate, UITableViewDataSource {
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
        return cast.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}



//import UIKit
//import Alamofire
//
//class CastAndCrewVC: UIViewController {
//    let apiKey = "871ddc96a542d766d2b0fe03fc0ac3d1"
//    let tableView = UITableView()
//    var actors: [Actor] = []
//
//
//    /// Завантажує данні по фільму за його айді(movieID)
//    init(movieID: Int) {
//        super.init(nibName: nil, bundle: nil)
//        self.fetchActors( movieID: movieID )
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        configurate()
//    }
//
//
//    /// Конфігурує елементи на view
//    private func configurate() {
//        view.backgroundColor = UIColor.darkBlue
//
//        tableView.delegate = self
//        tableView.dataSource = self
//
//        setupTableView()
//        setupConstraints()
//    }
//
//    /// Конфігурує TableView на view
//    func setupTableView(){
//        tableView.backgroundColor = UIColor.darkBlue
//        tableView.rowHeight = UITableView.automaticDimension
//        tableView.register(ActorCell.self, forCellReuseIdentifier: "TableViewCell")
//    }
//
//    /// Виставляє обмеження ( constraints ) для елементів view
//    func setupConstraints(){
//        [tableView].forEach{
//            $0.translatesAutoresizingMaskIntoConstraints = false
//            self.view.addSubview($0)
//        }
//
//        NSLayoutConstraint.activate([
//            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
//            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
//            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
//            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
//        ])
//    }
//
//    /// Заповнює массив(actors) інформацією з фільму
//    func fetchActors(movieID:Int) {
//        let url = "https://api.themoviedb.org/3/movie/\(movieID)/credits?api_key=\(apiKey)"
//        AF.request(url).responseJSON { response in
//            switch response.result {
//            case .success(let value):
//                if let json = value as? [String: Any], let cast = json["cast"] as? [[String: Any]] {
//                    for actorData in cast {
//                        if let name = actorData["name"] as? String,
//                           let character = actorData["character"] as? String,
//                           let profileImagePath = actorData["profile_path"] as? String {
//                            let profileImageURL = "https://image.tmdb.org/t/p/w500" + profileImagePath
//                            let actor = Actor(name: name, character: character, profileImageURL: profileImageURL)
//                            self.actors.append(actor)
//                        }
//                    }
//                    self.tableView.reloadData()
//                }
//            case .failure(let error):
//                print("Ошибка запроса: \(error.localizedDescription)")
//            }
//        }
//    }
//}
//
//
//// MARK: Extension
//extension CastAndCrewVC : UITableViewDelegate, UITableViewDataSource {
//
//    /// Повертає сконфігуровану cell(клітінку)
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? ActorCell {
//
//            let backgroundView = UIView()
//            backgroundView.backgroundColor = .darkBlue
//            cell.selectedBackgroundView = backgroundView
//            cell.configCell(actor: actors[indexPath.row])
//
//            return cell
//        }
//        return UITableViewCell()
//    }
//
//    /// Задає кількість cell(клітінок) в section(секції)
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        actors.count
//    }
//
//    /// Задає висоту cell(клітінок)
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        100
//    }
//}
