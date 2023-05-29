import UIKit

class TabBarController: UITabBarController {
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
           return .portrait
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tabBarAppearance = UITabBarAppearance()
                tabBarAppearance.backgroundColor = .darkBlue
                tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkBlue]
                tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkBlue]

        tabBar.standardAppearance = tabBarAppearance
        tabBar.scrollEdgeAppearance = tabBarAppearance

//        self.tabBar.layer.borderColor = UIColor.white.cgColor
          //      self.tabBar.layer.borderWidth = 1.0
        let firstViewController = MovieNavigationController()
        firstViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "ImageFirstTabBar"), selectedImage: UIImage(named: "ImageFirstTabBarSelect"))
        
        let secondViewController = HomeViewController()
        secondViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "ImageSecondTabBar"), selectedImage: UIImage(named: "ImageSecondTabBarSelect"))
        
        let theerdViewController = TheerdTabBarVC()
        theerdViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "ImageTheerdTabBar"), selectedImage: UIImage(named: "ImageTheerdTabBarActivate"))
        
        let fourViewController = FourTabBarVC()
        fourViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "ImageFourTabBar"), selectedImage: UIImage(named: "ImageFourTabBarActivate"))
        
        viewControllers = [firstViewController, secondViewController, theerdViewController, fourViewController]
    }
}



