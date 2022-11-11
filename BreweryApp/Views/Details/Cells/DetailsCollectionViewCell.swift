import Foundation
import UIKit

class DetailsCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "DetailsCollectionViewCell"
    
    lazy var breweryImage: UIImageView = {
        let breweryImage = UIImageView()
        breweryImage.image = UIImage(named: "Background-splash")
        breweryImage.contentMode = .scaleToFill
        breweryImage.layer.cornerRadius = 10
        breweryImage.clipsToBounds = true
        breweryImage.translatesAutoresizingMaskIntoConstraints = false
        return breweryImage
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0))
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setup()
    }
    
    func setup() {
        contentView.addSubview(breweryImage)
        
        NSLayoutConstraint.activate([
            breweryImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            breweryImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            breweryImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            breweryImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
