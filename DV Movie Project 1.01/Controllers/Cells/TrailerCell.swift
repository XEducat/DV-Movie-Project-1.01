import UIKit
import Alamofire
import youtube_ios_player_helper

class TrailerCell: UITableViewCell {
    private var playerView: YTPlayerView!
    private var isVideoPlaying = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .darkBlue
        
        setupSubviews()
        setupConstraints()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
                addGestureRecognizer(tapGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Додає елементи на блок ( cell )
    private func setupSubviews() {
        playerView = YTPlayerView()
        playerView.layer.cornerRadius = 20
        playerView.clipsToBounds = true
        self.addSubview(playerView)
    }
    
    /// Виставляє обмеження ( constraints ) для елементів блоку ( cell )
    private func setupConstraints() {
        playerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            playerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            playerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            playerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        ])
    }
    
    
    /// Налаштовує блок ( cell )
    func configure(with result: VideoResults) {
        if let key = result.key {
            playerView.load(withVideoId: key)
        }
    }
    
    /// Включає відео або ставить на паузу 
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        if isVideoPlaying {
            playerView.pauseVideo()
        } else {
            playerView.playVideo()
        }
        
        isVideoPlaying = !isVideoPlaying
    }
}
