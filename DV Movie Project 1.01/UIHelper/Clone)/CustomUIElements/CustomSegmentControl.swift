import UIKit

class CustomSegmentControl: UISegmentedControl {
    
    ///позиціювання CustomSegmentControl на view
    func setConstraintCustomSegmControl(in viewController: MovieVC) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor, constant: 18).isActive = true
        
        self.topAnchor.constraint(equalTo: viewController.searchText.bottomAnchor, constant: 29).isActive = true
        self.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor, constant: -18).isActive = true
        self.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
    
}
