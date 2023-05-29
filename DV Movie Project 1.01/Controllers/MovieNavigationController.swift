import UIKit

class MovieNavigationController: UINavigationController {
    let movievc = MovieVC()
    override func viewDidLoad() {
        super.viewDidLoad()
       // hideNavigationBar()
        self.pushViewController(movievc, animated: false)
        self.view.backgroundColor = .white
        self.navigationBar.isHidden = true
    }
    func hideNavigationBar() {
           self.setNavigationBarHidden(true, animated: true)
       }
}
