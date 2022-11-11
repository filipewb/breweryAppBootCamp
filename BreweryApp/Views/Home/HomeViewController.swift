import UIKit
import Combine
import Resolver
import CoreData

class HomeViewController: UIViewController {
    
    var filterModalViewController: FilterModalViewController?
    
    @Injected var viewModel: HomeViewModel
    
    var filterModalViewModel: FilterModalViewModel? = nil
    
    var breweriesTopTen: BreweryTopTenModel? = nil
    
    var searchParameters = SearchParameters()
    
    var genericError: GenericSearchError?
    
    private var cancellables: Set<AnyCancellable> = []
    
    lazy var appearance = UINavigationBarAppearance()
    
    lazy var filterViewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var orderRuleLabel: UILabel = {
        let orderRuleLabel = UILabel()
        orderRuleLabel.textColor = BreweryDesignSystem.Colors.black
        orderRuleLabel.text = "\(Texts.orderSearch) \(Texts.name)"
        orderRuleLabel.frame = CGRect(x: 0, y: 0, width: 328, height: 16)
        orderRuleLabel.font = BreweryDesignSystem.FontTypes.robotoLight
        orderRuleLabel.translatesAutoresizingMaskIntoConstraints = false
        return orderRuleLabel
    }()
    
    lazy var filterButton: UIButton = {
        let filterButton = UIButton()
        filterButton.setImage(UIImage(systemName: "line.3.horizontal.decrease"), for: .normal)
        filterButton.tintColor = BreweryDesignSystem.Colors.black
        filterButton.isEnabled = true
        filterButton.addTarget(self, action: #selector(presentModalController), for: .touchUpInside)
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        return filterButton
    }()
    
    lazy var carouselCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 160, height: 245)
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = BreweryDesignSystem.Colors.background
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CarouselCollectionViewCell.self, forCellWithReuseIdentifier: CarouselCollectionViewCell.identifier)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    lazy var topTenTitleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = Texts.bestRated
        titleLabel.textColor = BreweryDesignSystem.Colors.black
        titleLabel.frame = CGRect(x: 0, y: 0, width: 328, height: 23)
        titleLabel.font = BreweryDesignSystem.FontTypes.robotoMediumX
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = BreweryDesignSystem.Colors.background
        tableView.register(BreweryViewCell.self, forCellReuseIdentifier: BreweryViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var tableViewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var breweryHeaderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "header")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.appName
        label.font = BreweryDesignSystem.FontTypes.robotoRegularX
        label.textColor = BreweryDesignSystem.Colors.black
        return label
    }()
    
    lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.welcomeTitle
        label.font = BreweryDesignSystem.FontTypes.robotoMediumX
        label.textColor = BreweryDesignSystem.Colors.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var subHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.welcomeSubtitle
        label.font = BreweryDesignSystem.FontTypes.robotoMediumX
        label.textColor = BreweryDesignSystem.Colors.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.searchTextField.layer.cornerRadius = 25
        searchBar.searchTextField.layer.masksToBounds = true
        searchBar.searchTextField.backgroundColor = BreweryDesignSystem.Colors.yellowPale
        searchBar.searchTextField.leftView?.tintColor = BreweryDesignSystem.Colors.black
        searchBar.searchTextField.font = .systemFont(ofSize: 17)
        searchBar.barTintColor = UIColor.clear
        searchBar.backgroundColor = UIColor.clear
        searchBar.isTranslucent = true
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).clearButtonMode = .never
        
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.enablesReturnKeyAutomatically = false
        
        let placeholder = NSAttributedString(string: Texts.searchBarPlaceholder, attributes: [.foregroundColor: UIColor.gray, NSAttributedString.Key.font: BreweryDesignSystem.FontTypes.robotoLight!])
        searchBar.searchTextField.attributedPlaceholder = placeholder
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    lazy var heartButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "heart")?.withTintColor(BreweryDesignSystem.Colors.black, renderingMode: .alwaysOriginal), for: .normal)
        button.imageView?.layer.transform = CATransform3DMakeScale(1.2, 1.2, 1.2)
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(openFavoritesListView), for: .touchUpInside)
        return button
    }()
    
    lazy var starButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "star")?.withTintColor(BreweryDesignSystem.Colors.black, renderingMode: .alwaysOriginal), for: .normal)
        button.imageView?.layer.transform = CATransform3DMakeScale(1.1, 1.1, 1.1)
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(openRatingView), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.getBreweriesBy(city: viewModel.city ?? "") {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sinkBreweryTopTen()
        viewModel.getTopTenBreweries()
        
        setupView()
        setupNavigation()
        setupBarButtonItens()
        setupConstraints()
        setupToggleView()
        viewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func setupView() {
        view.backgroundColor = BreweryDesignSystem.Colors.background
        
        view.addSubview(breweryHeaderImageView)
        view.addSubview(titleLabel)
        view.addSubview(headerLabel)
        view.addSubview(subHeaderLabel)
        view.addSubview(searchBar)
    }
    
    private func setupNavigation() {
        appearance.backgroundColor = BreweryDesignSystem.Colors.yellow
        appearance.shadowColor = .clear
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = BreweryDesignSystem.Colors.black
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.topItem?.title = " "
    }
    
    @objc func buttonReturnAction(sender: UIButton!) {
        viewModel.returnToTopTen(collectionView: configureCollectionView)
    }
    
    @objc func openFavoritesListView(sender: UIButton) {
        let favoritesListViewController = FavoritesListViewController()
        self.navigationController?.pushViewController(favoritesListViewController, animated: true)
    }
    
    @objc func openRatingView(sender: UIButton) {
        let ratingViewController = RatingViewController()
        self.navigationController?.pushViewController(ratingViewController, animated: true)
    }
    
    private func setupBarButtonItens() {
        let barButtonHeart = UIBarButtonItem(customView: heartButton)
        let barButtonStar = UIBarButtonItem(customView: starButton)
        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        space.width = 33
        
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(
                image: UIImage(named: "brewerySmall"),
                style: .done,
                target: self,
                action: #selector(buttonReturnAction)
            ),
            
            UIBarButtonItem(customView: titleLabel)
        ]
        
        navigationItem.rightBarButtonItems = [
            barButtonHeart, space, barButtonStar
        ]
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            breweryHeaderImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            breweryHeaderImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            breweryHeaderImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            breweryHeaderImageView.heightAnchor.constraint(equalToConstant: 180),
            
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 18),
            headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            
            subHeaderLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor),
            subHeaderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            
            searchBar.topAnchor.constraint(equalTo: subHeaderLabel.bottomAnchor, constant: 12),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
        ])
    }
    
    private func setupToggleView() {
        viewModel.toggleViewOnScreen(
            emptySearch: configErrorConstraints,
            notFoundSearch: configErrorConstraints,
            tableView: configTableViewConstraints,
            collectionView: configureCollectionView)
    }
    
    private func configTableViewConstraints() {
        genericError?.removeFromSuperview()
        searchParameters.removeFromSuperview()
        carouselCollectionView.removeFromSuperview()
        topTenTitleLabel.removeFromSuperview()
        
        searchParameters = SearchParameters(tableCount: viewModel.getCountBreweries())
        
        filterViewContainer.addSubview(filterButton)
        filterViewContainer.addSubview(orderRuleLabel)
        
        view.addSubview(searchParameters)
        view.addSubview(filterViewContainer)
        view.addSubview(tableViewContainer)
        tableViewContainer.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            searchParameters.topAnchor.constraint(equalTo: breweryHeaderImageView.bottomAnchor, constant: 20.0),
            searchParameters.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0),
            searchParameters.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            filterViewContainer.topAnchor.constraint(equalTo: searchParameters.bottomAnchor, constant: 55),
            filterViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            filterViewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            filterButton.topAnchor.constraint(equalTo: filterViewContainer.topAnchor),
            filterButton.trailingAnchor.constraint(equalTo: filterViewContainer.trailingAnchor, constant: -19),
            filterButton.bottomAnchor.constraint(equalTo: filterViewContainer.bottomAnchor),
            
            orderRuleLabel.topAnchor.constraint(equalTo: filterViewContainer.topAnchor),
            orderRuleLabel.leadingAnchor.constraint(equalTo: filterViewContainer.leadingAnchor, constant: 20),
            orderRuleLabel.bottomAnchor.constraint(equalTo: filterViewContainer.bottomAnchor),
            
            tableViewContainer.topAnchor.constraint(equalTo: filterViewContainer.bottomAnchor),
            tableViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableViewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableViewContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            tableView.topAnchor.constraint(equalTo: tableViewContainer.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: tableViewContainer.leadingAnchor, constant: 20.0),
            tableView.trailingAnchor.constraint(equalTo: tableViewContainer.trailingAnchor, constant: -20.0),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configErrorConstraints(genericError: GenericSearchError) {
        self.genericError = genericError
        
        searchParameters.removeFromSuperview()
        filterViewContainer.removeFromSuperview()
        
        self.tableViewContainer.removeFromSuperview()
        carouselCollectionView.removeFromSuperview()
        topTenTitleLabel.removeFromSuperview()
        
        view.addSubview(genericError)
        
        NSLayoutConstraint.activate([
            genericError.widthAnchor.constraint(equalToConstant: 300.0),
            genericError.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            genericError.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func configureCollectionView() {
        genericError?.removeFromSuperview()
        searchParameters.removeFromSuperview()
        self.tableViewContainer.removeFromSuperview()
        
        view.addSubview(topTenTitleLabel)
        view.addSubview(carouselCollectionView)
        
        NSLayoutConstraint.activate([
            topTenTitleLabel.topAnchor.constraint(equalTo: breweryHeaderImageView.bottomAnchor, constant: 20.0),
            
            topTenTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0),
            topTenTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            carouselCollectionView.widthAnchor.constraint(equalToConstant: 300.0),
            carouselCollectionView.heightAnchor.constraint(equalToConstant: 260),
            
            carouselCollectionView.topAnchor.constraint(equalTo: topTenTitleLabel.bottomAnchor, constant: 20.0),
            carouselCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0),
            carouselCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
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
    
    func reloadTable() {
        tableView.reloadData()
    }
    
    func sinkBreweryTopTen() -> Void {
        viewModel.$state.sink { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                    
                case .initial: break
                    
                case .loading: break
                    
                case .success(let breweryTopTen):
                    self?.breweriesTopTen = breweryTopTen
                    
                    DispatchQueue.main.async {
                        self?.configureCollectionView()
                        self?.carouselCollectionView.reloadData()
                    }
                    
                case .failure: break
                }
            }
        }.store(in: &cancellables)
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        tableViewContainer.removeFromSuperview()
        genericError?.removeFromSuperview()
        
        UserDefaults.standard.set(true, forKey: "isAlphabeticFilter")
        
        guard let textFromSearchBar = searchBar.text else { return }
        
        let textFormatted = viewModel.getTextFormattedFromSearchBar(textFromSearchBar)
        viewModel.getBreweriesBy(city: textFormatted) {
            
            DispatchQueue.main.async {
                self.filterModalViewModel = FilterModalViewModel(breweries: self.viewModel.breweriesByCity)
                self.filterModalViewModel?.delegate = self
                self.configTableViewConstraints()
                self.tableView.reloadData()
            }
        }
        searchBar.searchTextField.text = ""
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getCountBreweries()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: BreweryViewCell.identifier, for: indexPath) as? BreweryViewCell {
            
            let brewery = viewModel.getBrewery(indexPath)
            let homeTableViewCellViewModel = HomeTableViewCellViewModel(brewery: brewery)
            cell.setupCell(withViewModel: homeTableViewCellViewModel)
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let brewery = viewModel.getBrewery(indexPath)
        let detailViewController = DetailsBreweryViewController()
        detailViewController.breweryDetailsId = brewery.id
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension HomeViewController: HomeViewModelDelegate {
    func reloadView() {
        DispatchQueue.main.async {
            self.setupToggleView()
        }
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return breweriesTopTen?.breweries.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCollectionViewCell.identifier, for: indexPath) as? CarouselCollectionViewCell {
            
            guard let breweriesTopTen = breweriesTopTen else { return UICollectionViewCell() }
            
            let brewery = breweriesTopTen.breweries[indexPath.row]
            
            let viewModel = HomeCollectionViewCellViewModel(brewery)
            cell.setupHomeCollectionViewCell(withViewModel: viewModel)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let brewery = breweriesTopTen?.breweries[indexPath.row]
        
        let detailViewController = DetailsBreweryViewController()
        
        detailViewController.breweryDetailsId = brewery?.id
        
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension HomeViewController: FilterDelegate {
    func updateBreweryList(sortedBreweryList: Breweries, favoriteBreweries: [FavoriteBrewery]?) {
        viewModel.breweriesByCity = sortedBreweryList
        reloadTable()
    }
   
}

extension HomeViewController: FilterModalViewDelegate {
    func updateFilterLabel(filterLabel: String) {
        orderRuleLabel.text = "\(Texts.orderSearch) \(filterLabel)"
    }
}
