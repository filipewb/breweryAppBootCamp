import Foundation
import UIKit
import Cosmos

class BreweryRatingViewCell: UITableViewCell {
    
    static let identifier: String = "BreweryRatingViewCell"
    
    lazy var letterContainerView: UIView = {
        let view = UIView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = BreweryDesignSystem.Colors.black
        titleLabel.font = BreweryDesignSystem.FontTypes.robotoRegular
        titleLabel.numberOfLines = 1
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    lazy var letterLabel: UILabel = {
        let letterLabel = UILabel()
        let size = 40.0
        letterLabel.layer.backgroundColor = BreweryDesignSystem.Colors.yellowLight.cgColor
        letterLabel.textAlignment = .center
        letterLabel.layer.cornerRadius = size/2
        letterLabel.textColor = BreweryDesignSystem.Colors.yellowLetter
        letterLabel.font = BreweryDesignSystem.FontTypes.robotoBlack
        letterLabel.center = letterContainerView.center
        letterLabel.translatesAutoresizingMaskIntoConstraints = false
        return letterLabel
    }()
    
    lazy var ratingNumbers: UILabel = {
        let label = UILabel()
        label.textColor = BreweryDesignSystem.Colors.black
        label.font = BreweryDesignSystem.FontTypes.quicksandMedium
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var ratingStars: CosmosView = {
        var view = CosmosView()
        view.settings.updateOnTouch = true
        view.settings.emptyImage = UIImage(named: "empty-star")?.withRenderingMode(.alwaysOriginal)
        view.settings.filledImage = UIImage(named: "star")?.withRenderingMode(.alwaysOriginal)
        view.settings.disablePanGestures = true
        view.settings.totalStars = 5
        view.settings.starSize = 20
        view.settings.updateOnTouch = false
        view.settings.starMargin = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 28
        view.backgroundColor = BreweryDesignSystem.Colors.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0))
    }
    
    private func setupView() {
        self.selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(letterContainerView)
        letterContainerView.addSubview(letterLabel)
        containerView.addSubview(titleLabel)
        containerView.addSubview(ratingNumbers)
        containerView.addSubview(ratingStars)
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 28
        contentView.layer.masksToBounds = false
        contentView.layer.shadowColor = BreweryDesignSystem.Colors.black.cgColor
        contentView.layer.shadowOpacity = 0.8
        contentView.layer.shadowRadius = 0.2
        contentView.layer.shadowOffset = CGSize(width: 0.1, height: 0.3)
        
        NSLayoutConstraint.activate([
            containerView.heightAnchor.constraint(equalToConstant: 64.0),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            letterContainerView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8.0),
            letterContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 7.0),
            
            letterLabel.widthAnchor.constraint(equalToConstant: 40.0),
            letterLabel.heightAnchor.constraint(equalToConstant: 40.0),
            
            titleLabel.leadingAnchor.constraint(equalTo: letterContainerView.leadingAnchor, constant: 52),
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -150),
            
            ratingNumbers.trailingAnchor.constraint(equalTo: ratingStars.leadingAnchor, constant: -2),
            ratingNumbers.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            ratingStars.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            ratingStars.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
        ])
    }
    
    func setupHomeCell(_ viewModel: RatingViewModel, _ index: IndexPath) {
        letterLabel.text = viewModel.getBreweryNameFirstLetter(forIndex: index)
        titleLabel.text = viewModel.getFullNameBrewery(index: index)
        ratingNumbers.text = viewModel.formatAverage(index: index)
        ratingStars.rating = Double(viewModel.getAverage(index: index)) ?? 0.0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder) has not been implemented")
    }
}
