import UIKit

protocol FilterDelegate: AnyObject {
    func updateBreweryList(sortedBreweryList: Breweries, favoriteBreweries: [FavoriteBrewery]?)
}

class FilterModalViewController: UIViewController {
    
    weak var delegate: FilterDelegate?
    
    var sortedBreweryList: Breweries = []
    var sortedFavoriteBreweries: [FavoriteBrewery] = []
    
    let reloadTable: () -> Void
    
    var viewModel: FilterModalViewModel
    let homeViewController = HomeViewController()
    
    let defaultHeight: CGFloat = 200
    let maxDimmedAlpha: CGFloat = 0.4
    
    var containerViewHeightConstraint: NSLayoutConstraint?
    var containerViewBottomConstraint: NSLayoutConstraint?
    
    init(viewModel: FilterModalViewModel, reloadTable: @escaping () -> Void) {
        self.viewModel = viewModel
        self.reloadTable = reloadTable
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.orderSearch
        label.textAlignment = .center
        label.font = BreweryDesignSystem.FontTypes.robotoRegular
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = BreweryDesignSystem.Colors.background
        lineView.translatesAutoresizingMaskIntoConstraints = false
        return lineView
    }()
    
    lazy var buttonLetterOrder: UIButton = {
        let buttonLetterOrder = UIButton()
        buttonLetterOrder.setTitle(Texts.orderPerName, for: .normal)
        buttonLetterOrder.titleLabel?.font = BreweryDesignSystem.FontTypes.robotoRegularS
        buttonLetterOrder.setTitleColor(BreweryDesignSystem.Colors.black, for: .normal)
        buttonLetterOrder.setImage(UIImage.init(named: "radio-active"), for: .selected)
        buttonLetterOrder.setImage(UIImage.init(named: "radio-inactive"), for: .normal)
        buttonLetterOrder.addTarget(self, action:#selector(buttonSelectChange), for: UIControl.Event.touchUpInside)
        buttonLetterOrder.translatesAutoresizingMaskIntoConstraints = false
        return buttonLetterOrder
    }()
    
    lazy var buttonEvaluationOrder: UIButton = {
        let buttonEvaluationOrder = UIButton()
        buttonEvaluationOrder.setTitle(Texts.orderPerRating, for: .normal)
        buttonEvaluationOrder.titleLabel?.font = BreweryDesignSystem.FontTypes.robotoRegularS
        buttonEvaluationOrder.setTitleColor(BreweryDesignSystem.Colors.black, for: .normal)
        buttonEvaluationOrder.setImage(UIImage.init(named: "radio-active"), for: .selected)
        buttonEvaluationOrder.setImage(UIImage.init(named: "radio-inactive"), for: .normal)
        buttonEvaluationOrder.addTarget(self, action:#selector(buttonSelectChange), for: UIControl.Event.touchUpInside)
        buttonEvaluationOrder.translatesAutoresizingMaskIntoConstraints = false
        return buttonEvaluationOrder
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = maxDimmedAlpha
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addFilterView()
        setupConstraints()
        buttonSetState()
    }
    
    func buttonSetState() {
        if  UserDefaults.standard.bool(forKey: "isAlphabeticFilter") == true {
            buttonLetterOrder.isSelected = true
            buttonEvaluationOrder.isSelected = false
        }else{
            buttonEvaluationOrder.isSelected = true
        }
    }
    
    @objc func buttonSelectChange(_ sender: UIButton) {
        if sender == buttonLetterOrder {
            UserDefaults.standard.set(true, forKey: "isAlphabeticFilter")
            buttonLetterOrder.isSelected = true
            buttonEvaluationOrder.isSelected = false
            
            viewModel.setFilterLabel()
            sortedBreweryList = viewModel.sortBreweriesByLetter()
            sortedFavoriteBreweries = viewModel.sortFavoriteBreweriesByLetter()
            delegate?.updateBreweryList(sortedBreweryList: sortedBreweryList, favoriteBreweries: sortedFavoriteBreweries)
            
        } else {
            UserDefaults.standard.set(false, forKey: "isAlphabeticFilter")
            buttonLetterOrder.isSelected = false
            buttonEvaluationOrder.isSelected = true
            
            viewModel.setFilterLabel()
            sortedFavoriteBreweries = viewModel.sortFavoriteBreweriesByRating()
            sortedBreweryList = viewModel.sortBreweriesByRating()
            delegate?.updateBreweryList(sortedBreweryList: sortedBreweryList, favoriteBreweries: sortedFavoriteBreweries)
        }
        
        self.reloadTable()
        animateRadioSelect()
    }
    
    @objc func handleCloseAction() {
        animateDismissView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateShowDimmedView()
        animatePresentContainer()
    }
    
    func addFilterView() {
        view.addSubview(dimmedView)
        view.addSubview(containerView)
        containerView.addSubview(lineView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(buttonLetterOrder)
        containerView.addSubview(buttonEvaluationOrder)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleCloseAction))
        dimmedView.addGestureRecognizer(tapGesture)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            dimmedView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dimmedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            lineView.topAnchor.constraint(equalTo: buttonLetterOrder.bottomAnchor, constant: 14),
            lineView.heightAnchor.constraint(equalToConstant: 1),
            lineView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            buttonLetterOrder.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            buttonLetterOrder.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30),
            
            buttonEvaluationOrder.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 14),
            buttonEvaluationOrder.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30),
        ])
        
        containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: defaultHeight)
        containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: defaultHeight)
        containerViewHeightConstraint?.isActive = true
        containerViewBottomConstraint?.isActive = true
    }
    
    func animatePresentContainer() {
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func animateShowDimmedView() {
        dimmedView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = self.maxDimmedAlpha
        }
    }
    
    func animateDismissView() {
        dimmedView.alpha = maxDimmedAlpha
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false)
        }
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.constant = self.defaultHeight
            self.view.layoutIfNeeded()
        }
    }
    
    func animateRadioSelect() {
        dimmedView.alpha = maxDimmedAlpha
        UIView.animate(withDuration: 0.7) {
            self.dimmedView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false)
        }
        UIView.animate(withDuration: 0.8) {
            self.containerViewBottomConstraint?.constant = self.defaultHeight
            self.view.layoutIfNeeded()
        }
    }
}
