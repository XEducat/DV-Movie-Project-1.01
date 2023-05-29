import UIKit
import youtube_ios_player_helper

class TrailerCell: UITableViewCell {
    private var playerView = YTPlayerView()
    private var isVideoPlaying = false

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    public func configCell(result: VideoResults) {
        self.addSubview(playerView)
        self.backgroundColor = .darkBlue
        
        playerView.backgroundColor = .darkBlue
        playerView.translatesAutoresizingMaskIntoConstraints = false
        playerView.clipsToBounds = true
        playerView.layer.cornerRadius = 30
        
        NSLayoutConstraint.activate([
            playerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            playerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            playerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            playerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20)
        ])
        
        if let key = result.key {
            playerView.load(withVideoId: key)
        }
    }
}
