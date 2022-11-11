import Foundation
import UIKit
import Resolver

public protocol UnFavoriteModalDelegate: AnyObject {
    func updateTableView()
}

public final class UnFavoriteModalViewController: UIViewController {
    
    var index: IndexPath?
    
    var favoriteBrewery: FavoriteBrewery?
    
    weak var delegate: UnFavoriteModalDelegate?
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 32
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var labelTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "\(Texts.removeFavoriteTitle)"
        label.font = BreweryDesignSystem.FontTypes.robotoRegular
        label.textColor = BreweryDesignSystem.Colors.blackMedium
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var labelText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "\(Texts.removeFavoriteSubtitle)"
        label.font = BreweryDesignSystem.FontTypes.robotoLight
        label.textColor = BreweryDesignSystem.Colors.blackMedium
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var buttonCancel: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 17
        button.layer.borderColor = BreweryDesignSystem.Colors.black.cgColor
        button.setTitle("\(Texts.removeFavoriteCancel)", for: .normal)
        button.setTitleColor(BreweryDesignSystem.Colors.black, for: .normal)
        button.titleLabel?.font = BreweryDesignSystem.FontTypes.robotoMediumS
        button.addTarget(self, action: #selector(self.didTapCancel(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonConfirm: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 17
        button.layer.backgroundColor = BreweryDesignSystem.Colors.yellowButton.cgColor
        button.setTitle("\(Texts.removeFavoriteConfirm)", for: .normal)
        button.setTitleColor(BreweryDesignSystem.Colors.gold, for: .normal)
        button.titleLabel?.font = BreweryDesignSystem.FontTypes.robotoMediumS
        button.addTarget(self, action: #selector(self.didTapConfirm(_:)), for: .touchUpInside)
        return button
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
    }
    
    @objc func didTapCancel(_ btn: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    
    @objc func didTapConfirm(_ btn: UIButton) {
        guard
            let favoriteBrewery = favoriteBrewery,
            let index = index
        else { return }
        
        let viewModel = FavoritesListTableViewCellViewModel(favoriteBrewery: favoriteBrewery)
        
        viewModel.getFavoriteBreweries()
        
        let forData = viewModel.getFavoriteBreweriesManagedObject()
        
        viewModel.deleteFavoriteBrewery(atIndex: index, forData: forData)
        dismiss(animated: false, completion: nil)
        
        delegate?.updateTableView()        
    }
    
    private func setupViews() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        self.view.addSubview(containerView)
        self.containerView.addSubview(labelTitle)
        self.containerView.addSubview(labelText)
        self.containerView.addSubview(buttonCancel)
        self.containerView.addSubview(buttonConfirm)
        
        NSLayoutConstraint.activate([
            self.containerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.containerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.containerView.widthAnchor.constraint(equalToConstant: 352),
            
            self.labelTitle.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 25),
            self.labelTitle.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor),
            
            self.labelText.topAnchor.constraint(equalTo: self.labelTitle.bottomAnchor, constant: 24),
            self.labelText.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 24),
            self.labelText.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -24),
            
            self.buttonCancel.heightAnchor.constraint(equalToConstant: 40),
            self.buttonCancel.topAnchor.constraint(equalTo: self.labelText.bottomAnchor, constant: 28),
            self.buttonCancel.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 30),
            self.buttonCancel.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -30),
            
            self.buttonConfirm.heightAnchor.constraint(equalToConstant: 40),
            self.buttonConfirm.topAnchor.constraint(equalTo: self.buttonCancel.bottomAnchor, constant: 10),
            self.buttonConfirm.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 30),
            self.buttonConfirm.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -30),
            self.buttonConfirm.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -28),
        ])
    }
}
