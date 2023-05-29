import UIKit
import Alamofire

class CastAndCrewVC: UIViewController {
    let apiKey = "871ddc96a542d766d2b0fe03fc0ac3d1"
    let tableView = UITableView()
    var cast: [Cast] = []
    
    /// При ініціалізації передається id фільму для завантаження данних
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
    
    /// Налаштовує view
    private func configure() {
        view.backgroundColor = UIColor.darkBlue
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setupTableView()
        setupConstraints()
    }
    
    /// Добавляє UITableView на view
    func setupTableView() {
        tableView.backgroundColor = UIColor.darkBlue
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(ActorCell.self, forCellReuseIdentifier: "TableViewCell")
    }
    
    /// Виставляє обмеження ( constraints ) для елементів view
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
    
    /// Підвантажує акторів в масив cast
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
    /// Віставляє кількість блоків в таблиці ( TableView )
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cast.count
    }
    
    /// Повертає налаштований блок ( cell )
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
    
    /// Задає висоту блоку ( cell )
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
