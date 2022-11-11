import Foundation
import UIKit
import Resolver

class FavoritesListViewController: UIViewController {
    var filterModalViewController: FilterModalViewController?

    @Injected var viewModel: FavoritesListViewModel
    var filterModalViewModel: FilterModalViewModel? = nil

    //MARK: - Header
    private lazy var breweryHeaderImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "header")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var appearance = UINavigationBarAppearance()
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.favoriteTitle
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = BreweryDesignSystem.FontTypes.robotoRegularXL
        label.textColor = BreweryDesignSystem.Colors.black
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    //MARK: - Default screen without favorites
    private lazy var titleEmpty: UILabel = {
        let label = UILabel()
        label.text = Texts.favoriteErrorTitle
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = BreweryDesignSystem.FontTypes.robotoMediumXL
        label.textColor = BreweryDesignSystem.Colors.blackMedium
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.favoriteErrorSubtitle
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = BreweryDesignSystem.FontTypes.robotoLightX
        label.textColor = BreweryDesignSystem.Colors.blackMedium
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Favorites screen + Cell
    
    private lazy var favoritesLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.favoriteBrewery
        label.font = BreweryDesignSystem.FontTypes.robotoMediumX
        label.textColor = BreweryDesignSystem.Colors.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var favoritesResultsText: UILabel = {
        let label = UILabel()
        label.font = BreweryDesignSystem.FontTypes.robotoLightXL
        label.textColor = BreweryDesignSystem.Colors.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var orderBy: UILabel = {
        let orderRuleLabel = UILabel()
        orderRuleLabel.textColor = BreweryDesignSystem.Colors.black
        orderRuleLabel.text = "\(Texts.orderSearch) \(Texts.name)"
        orderRuleLabel.frame = CGRect(x: 0, y: 0, width: 328, height: 16)
        orderRuleLabel.font = BreweryDesignSystem.FontTypes.robotoLight
        orderRuleLabel.translatesAutoresizingMaskIntoConstraints = false
        return orderRuleLabel
    }()
    
    private lazy var filterButton: UIButton = {
        let filterButton = UIButton()
        filterButton.setImage(UIImage(systemName: "line.3.horizontal.decrease"), for: .normal)
        filterButton.tintColor = BreweryDesignSystem.Colors.black
        filterButton.isEnabled = true
        filterButton.addTarget(self, action: #selector(presentModalController), for: .touchUpInside)
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        return filterButton
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.register(FavoritesListViewCell.self, forCellReuseIdentifier: FavoritesListViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var filterByContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Setups
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigation()
        setupToggleView()
        setupResults()
    }
    
    private func setupView() {
        view.backgroundColor = BreweryDesignSystem.Colors.background
        
        view.addSubview(breweryHeaderImageView)
        breweryHeaderImageView.addSubview(headerLabel)
        
        NSLayoutConstraint.activate([
            breweryHeaderImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            breweryHeaderImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            breweryHeaderImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            breweryHeaderImageView.heightAnchor.constraint(equalToConstant: 180),
            
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    
    private func setupNavigation() {
        appearance.backgroundColor = BreweryDesignSystem.Colors.yellow
        appearance.shadowColor = .clear
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = BreweryDesignSystem.Colors.black
        navigationController?.navigationBar.isTranslucent = true
    }
    
    func setupToggleView() {
        viewModel.getFavoriteBreweries()
        
        if viewModel.getCountFavoriteBreweriesManagedObject() == 0 {
            setupDefaultMessage()
        } else {
            setupTableView()
        }
    }
    
    private func setupDefaultMessage() {
        view.addSubview(titleEmpty)
        view.addSubview(subTitleLabel)
        
        self.favoritesLabel.removeFromSuperview()
        self.favoritesResultsText.removeFromSuperview()
        self.orderBy.removeFromSuperview()
        self.filterButton.removeFromSuperview()
        self.tableView.removeFromSuperview()
        
        NSLayoutConstraint.activate([
            titleEmpty.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleEmpty.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            titleEmpty.widthAnchor.constraint(equalToConstant: 226),
            
            subTitleLabel.topAnchor.constraint(equalTo: titleEmpty.bottomAnchor, constant: 16),
            subTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            subTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
        ])
    }
    
    private func setupTableView() {
        view.addSubview(favoritesLabel)
        view.addSubview(favoritesResultsText)
        view.addSubview(orderBy)
        view.addSubview(filterButton)
        view.addSubview(tableView)
        
        self.titleEmpty.removeFromSuperview()
        self.subTitleLabel.removeFromSuperview()
        
        NSLayoutConstraint.activate([
            favoritesLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 21),
            favoritesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            favoritesResultsText.topAnchor.constraint(equalTo: favoritesLabel.bottomAnchor, constant: 2),
            favoritesResultsText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            orderBy.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            orderBy.topAnchor.constraint(equalTo: favoritesResultsText.bottomAnchor, constant: 14),
            
            filterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            filterButton.topAnchor.constraint(equalTo: favoritesResultsText.bottomAnchor, constant: 14),
            
            tableView.topAnchor.constraint(equalTo: orderBy.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setupResults() {
        viewModel.getFavoriteBreweries()
        favoritesResultsText.text = viewModel.getResultLabelText()
    }
    
    func reloadTable() {
        self.tableView.reloadData()
    }
    
    @objc func presentModalController() {
        guard let filterModalViewModel = filterModalViewModel else {
            return
        }

        filterModalViewController = FilterModalViewController(viewModel: filterModalViewModel, reloadTable: reloadTable)
        filterModalViewController?.delegate = self
        filterModalViewController?.modalPresentationStyle = .overCurrentContext
        self.present(filterModalViewController!, animated: false)
    }
}

extension FavoritesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = viewModel.getCountFavoriteBreweriesManagedObject()
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: FavoritesListViewCell.identifier, for: indexPath) as? FavoritesListViewCell {
            
            let favoriteBreweries = viewModel.favoriteBreweryList
            
            self.filterModalViewModel = FilterModalViewModel(favoriteBreweries: favoriteBreweries)
            self.filterModalViewModel?.delegate = self
            
            let favoriteBrewery = viewModel.getFavoriteBrewery(favoriteBreweries, index: indexPath)
            
            
            let favoritesListTableViewCellViewModel = FavoritesListTableViewCellViewModel(favoriteBrewery: favoriteBrewery)
            
            cell.setupCell(withViewModel: favoritesListTableViewCellViewModel)
            
            cell.delegate = self
            
            return cell
        }
        return UITableViewCell()
    }
}

extension FavoritesListViewController: FavoritesListViewCellDelegate {
    func showModal(index: IndexPath, favoriteBrewery: FavoriteBrewery) {
        let openFavoriteModal = UnFavoriteModalViewController()
        
        openFavoriteModal.index = index
        openFavoriteModal.favoriteBrewery = favoriteBrewery
        openFavoriteModal.delegate = self
        
        openFavoriteModal.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(openFavoriteModal, animated: false, completion: nil)
        
        reloadTableView()
    }
    
    func reloadTableView() {
        viewModel.getFavoriteBreweries()
        tableView.reloadData()
    }
    
    func reloadResults() {
        setupResults()
    }
    
    func showEmptyView() {
        setupDefaultMessage()
    }
}

extension FavoritesListViewController: UnFavoriteModalDelegate {
    func updateTableView() {
        viewModel.getFavoriteBreweries()
        setupResults()
        tableView.reloadData()
        setupToggleView()
    }
}

extension FavoritesListViewController: FilterModalViewDelegate, FilterDelegate {
    func updateBreweryList(sortedBreweryList: Breweries, favoriteBreweries: [FavoriteBrewery]?) {
        viewModel.favoriteBreweryList = favoriteBreweries ?? []
        tableView.reloadData()
    }
    
    func updateFilterLabel(filterLabel: String) {
        orderBy.text = "\(Texts.orderSearch) \(filterLabel)"
    }
}
