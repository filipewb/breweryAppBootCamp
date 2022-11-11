import UIKit

class CarouselCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "CarouselCollectionViewCell"
    
    lazy var breweryImage: UIImageView = {
        let breweryImage = UIImageView()
        breweryImage.contentMode = .scaleToFill
        breweryImage.layer.cornerRadius = 8
        breweryImage.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        breweryImage.clipsToBounds = true
        breweryImage.translatesAutoresizingMaskIntoConstraints = false
        return breweryImage
    }()
    
    lazy var starImage: UIImageView = {
        let starImage = UIImageView()
        starImage.image = UIImage(named: "star")
        starImage.contentMode = .scaleAspectFit
        starImage.translatesAutoresizingMaskIntoConstraints = false
        return starImage
    }()
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = ""
        titleLabel.numberOfLines = 1
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.textColor = BreweryDesignSystem.Colors.black
        titleLabel.font = BreweryDesignSystem.FontTypes.robotoRegular
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    lazy var breweryTypeLabel: UILabel = {
        let breweryTypeLabel = UILabel()
        breweryTypeLabel.text = ""
        breweryTypeLabel.font = BreweryDesignSystem.FontTypes.robotoLight
        breweryTypeLabel.textColor = BreweryDesignSystem.Colors.black
        breweryTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        return breweryTypeLabel
    }()
    
    lazy var averageLabel: UILabel = {
        let averageLabel = UILabel()
        averageLabel.text = ""
        averageLabel.font = BreweryDesignSystem.FontTypes.robotoLight
        averageLabel.textColor = BreweryDesignSystem.Colors.black
        averageLabel.translatesAutoresizingMaskIntoConstraints = false
        return averageLabel
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0))
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }
    
    func setup() {
        contentView.addSubview(breweryImage)
        contentView.backgroundColor = .red
        contentView.addSubview(containerView)
        contentView.addSubview(breweryTypeLabel)
        contentView.addSubview(titleLabel)
        
        containerView.addSubview(starImage)
        containerView.addSubview(averageLabel)
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        contentView.layer.borderColor = BreweryDesignSystem.Colors.black.cgColor
        contentView.layer.borderWidth = 0.1
        contentView.layer.masksToBounds = false
        contentView.layer.shadowColor = BreweryDesignSystem.Colors.black.cgColor
        contentView.layer.shadowOpacity = 0.5
        contentView.layer.shadowRadius = 1.0
        contentView.layer.shadowOffset = CGSize(width: 0.8, height: 0.8)
        
        NSLayoutConstraint.activate([
            breweryImage.widthAnchor.constraint(equalToConstant: 140.0),
            breweryImage.heightAnchor.constraint(equalToConstant: 148.0),
            breweryImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            breweryImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            breweryImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: breweryImage.bottomAnchor, constant: 8.0),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 7.0),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -7.0),
            
            containerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.0),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5.0),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 50.0),
            
            starImage.topAnchor.constraint(equalTo: containerView.topAnchor),
            starImage.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            starImage.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            
            averageLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            averageLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            averageLabel.leadingAnchor.constraint(equalTo: starImage.trailingAnchor, constant: 3.0),
            averageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 50.0),
            
            breweryTypeLabel.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 5.0),
            breweryTypeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 7.0),
            breweryTypeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 50.0),
        ])
    }
    
    func setupHomeCollectionViewCell(withViewModel viewModel: HomeCollectionViewCellViewModel) {
        titleLabel.text = viewModel.getFullNameBrewery()
        averageLabel.text = viewModel.getAverageBrewery()
        breweryTypeLabel.text = viewModel.getBreweryType()
        
        let brewery = viewModel.getBrewery()
        
        let imageUrl = viewModel.getUrlBreweryImage(brewery)
        
        breweryImage.load(imageUrl, placeholder: UIImage(named: "brewery-placeholder"))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
