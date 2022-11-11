import Foundation
import UIKit
import Resolver

protocol FavoritesListViewCellDelegate: AnyObject {
    func showModal(index: IndexPath, favoriteBrewery: FavoriteBrewery)
    func reloadTableView()
    func reloadResults()
    func showEmptyView()
}

class FavoritesListViewCell: UITableViewCell {
    
    weak var delegate: FavoritesListViewCellDelegate?
    
    static let identifier: String = "FavoritesListViewCell"
    
    var viewModel: FavoritesListTableViewCellViewModel?
    var favoriteBrewery: FavoriteBrewery?
    
    lazy var letterContainerView: UIView = {
        let view = UIView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        titleLabel.textColor = BreweryDesignSystem.Colors.black
        titleLabel.font = BreweryDesignSystem.FontTypes.robotoRegular
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    lazy var informationBrewery: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.font = BreweryDesignSystem.FontTypes.robotoLight
        descriptionLabel.textColor = BreweryDesignSystem.Colors.black
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        return descriptionLabel
    }()
    
    lazy var heartButton: UIButton = {
        let heartButton = UIButton()
        heartButton.setImage(UIImage(systemName: "heart")?.withTintColor(BreweryDesignSystem.Colors.black, renderingMode: .alwaysOriginal), for: .normal)
        heartButton.setImage(UIImage(systemName: "heart.fill")?.withTintColor(BreweryDesignSystem.Colors.red, renderingMode: .alwaysOriginal), for: .selected)
        heartButton.addTarget(self, action:#selector(buttonSelectChange), for: UIControl.Event.touchUpInside)
        heartButton.translatesAutoresizingMaskIntoConstraints = false
        return heartButton
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
    
    @objc func buttonSelectChange(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        guard let viewModel = viewModel,
              let favoriteBrewery = favoriteBrewery else { return }
        
        let isFavorited = viewModel.isFavorited(favoriteBrewery: favoriteBrewery)
        
        if sender.isSelected == false && isFavorited == true {
            let index = viewModel.getIndexPathFromCoreData(favoriteBrewery: favoriteBrewery)
            
            delegate?.showModal(index: index, favoriteBrewery: favoriteBrewery)
        }
        
        viewModel.getFavoriteBreweries()
        
        delegate?.reloadTableView()
        
        delegate?.reloadResults()
        
        if viewModel.getCountFavoriteBreweriesManagedObject() == 0 {
            delegate?.showEmptyView()
        }
    }
    
    private func setupView() {
        self.selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(letterContainerView)
        letterContainerView.addSubview(letterLabel)
        containerView.addSubview(titleLabel)
        containerView.addSubview(informationBrewery)
        containerView.addSubview(starImage)
        containerView.addSubview(heartButton)
        
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
            titleLabel.trailingAnchor.constraint(equalTo: heartButton.trailingAnchor, constant: -25),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 7.0),
            
            starImage.leadingAnchor.constraint(equalTo: letterContainerView.trailingAnchor, constant: 53.0),
            starImage.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -9.0),
            starImage.heightAnchor.constraint(equalToConstant: 14.00),
            starImage.widthAnchor.constraint(equalToConstant: 14.00),
            
            informationBrewery.leadingAnchor.constraint(equalTo: letterContainerView.trailingAnchor, constant: 74.0),
            informationBrewery.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -7.0),
            
            heartButton.widthAnchor.constraint(equalToConstant: 20.0),
            heartButton.heightAnchor.constraint(equalToConstant: 20.0),
            heartButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -18.0),
            heartButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20.0),
        ])
    }
    
    func setupCell(withViewModel viewModel: FavoritesListTableViewCellViewModel) {
        viewModel.getFavoriteBreweries()
        
        self.viewModel = viewModel
        let favoriteBrewery = viewModel.getFavoriteBrewery()
        self.favoriteBrewery = favoriteBrewery
        
        letterLabel.text = viewModel.getFirstLetterNameBrewery()
        titleLabel.text = viewModel.getFullNameBrewery()
        informationBrewery.text = viewModel.getDescriptionLabel()
        
        heartButton.isSelected = viewModel.isFavorited(favoriteBrewery: favoriteBrewery)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder) has not been implemented")
    }
}
