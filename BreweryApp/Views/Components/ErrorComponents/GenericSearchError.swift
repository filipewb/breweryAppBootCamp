import Foundation
import UIKit

class GenericSearchError: UIView {
    
    var error: String
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = self.error
        titleLabel.textColor = BreweryDesignSystem.Colors.black
        titleLabel.frame = CGRect(x: 0, y: 0, width: 300, height: 46)
        titleLabel.font = BreweryDesignSystem.FontTypes.robotoMediumXL
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        let attributedString = NSMutableAttributedString(string: Texts.searchErrorSubtitle)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.39
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range:NSMakeRange(0, attributedString.length))
        descriptionLabel.attributedText = attributedString
        descriptionLabel.textColor = BreweryDesignSystem.Colors.black
        descriptionLabel.frame = CGRect(x: 0, y: 0, width: 300, height: 46)
        descriptionLabel.font = BreweryDesignSystem.FontTypes.robotoLight
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.textAlignment = .center
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        return descriptionLabel
    }()
    
    init(error: String = Texts.searchNoResultsTitle) {
        self.error = error
        
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        
        setupView()
    }
    
    private func setupView() {
        self.addSubview(titleLabel)
        self.addSubview(descriptionLabel)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 120.0),
            descriptionLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

