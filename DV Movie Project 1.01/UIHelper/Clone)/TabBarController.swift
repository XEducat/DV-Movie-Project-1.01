import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBar.backgroundColor = .someDarkOfBlue
       // self.tabBar.layer.borderColor = UIColor.white.cgColor
          //      self.tabBar.layer.borderWidth = 1.0
        let firstViewController = MovieNavigationController()
        firstViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "ImageFirstTabBar"), selectedImage: UIImage(named: "ImageFirstTabBar"))
        
        let secondViewController = HomeViewController()
        secondViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "ImageSecondTabBar"), selectedImage: UIImage(named: "ImageSecondTabBarActivate"))
        
        let theerdViewController = theerdTabBarVC()
        theerdViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "ImageTheerdTabBar"), selectedImage: UIImage(named: "ImageTheerdTabBarActivate"))
        
        let fourViewController = fourTabBarVC()
        fourViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "ImageFourTabBar"), selectedImage: UIImage(named: "ImageFourTabBarActivate"))
        
        viewControllers = [firstViewController, secondViewController, theerdViewController, fourViewController]
    }
}



