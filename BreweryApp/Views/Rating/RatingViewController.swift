import UIKit
import Resolver

class RatingViewController: UIViewController {
    @Injected var viewModel: RatingViewModel
    
    // MARK: - Header
    private lazy var breweryHeaderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "header")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var appearance = UINavigationBarAppearance()
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.breweryRated
        label.font = BreweryDesignSystem.FontTypes.robotoRegularXL
        label.textColor = BreweryDesignSystem.Colors.black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var headerTextLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.breweryRatedSubtext
        label.font = BreweryDesignSystem.FontTypes.robotoMedium
        label.textColor = BreweryDesignSystem.Colors.black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Email Form
    lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.send
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.attributedPlaceholder = NSAttributedString(
            string: "email",
            attributes: [NSAttributedString.Key.foregroundColor: BreweryDesignSystem.Colors.black]
        )
        textField.textColor = BreweryDesignSystem.Colors.black
        textField.font = BreweryDesignSystem.FontTypes.robotoRegular
        
        textField.layer.borderColor = BreweryDesignSystem.Colors.black.cgColor
        textField.layer.cornerRadius = 10.0
        textField.layer.borderWidth = 1.0
        textField.leftViewMode = .always
        
        let image = UIImage(named: "email")
        let imageView = UIImageView()
        imageView.image = image
        
        textField.rightViewMode = .never
        let alertImage = UIImage(named: "exclamation-mark")
        let alertImageView = UIImageView()
        alertImageView.image = alertImage
        textField.rightView = alertImageView
        
        textField.leftView = imageView
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return textField
    }()
    
    lazy var emailCheckbox: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square")?.withTintColor(BreweryDesignSystem.Colors.black, renderingMode: .alwaysOriginal), for: .normal)
        button.setImage(UIImage(systemName: "checkmark.square.fill")?.withTintColor(BreweryDesignSystem.Colors.green, renderingMode: .alwaysOriginal), for: .selected)
        button.contentMode = .scaleAspectFit
        button.setTitle(Texts.rememberEmail, for: .normal)
        button.titleLabel?.font = BreweryDesignSystem.FontTypes.robotoRegularS
        button.setTitleColor(BreweryDesignSystem.Colors.black, for: .normal)
        button.addTarget(self, action:#selector(buttonSelectChange), for: UIControl.Event.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var emailError: UILabel = {
        let label = UILabel()
        label.text = Texts.emailError
        label.font = BreweryDesignSystem.FontTypes.robotoRegularXS
        label.textColor = BreweryDesignSystem.Colors.red
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = BreweryDesignSystem.Colors.buttonInactive
        button.setTitleColor(BreweryDesignSystem.Colors.buttonLabelColorInactive, for: .normal)
        button.layer.cornerRadius = 20
        button.titleLabel?.font = BreweryDesignSystem.FontTypes.robotoMediumS
        button.clipsToBounds = true
        button.setTitle(Texts.ratingConfirm, for: .normal)
        button.isEnabled = false
        button.addTarget(self, action:#selector(didTapSelectionButton), for: UIControl.Event.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var indicatorView: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView(style: .large)
        activityView.translatesAutoresizingMaskIntoConstraints = false
        return activityView
    }()
    
    // MARK: - Default screen without favorites
    lazy var ratingText: UILabel = {
        let label = UILabel()
        label.text = Texts.ratingTextMessage
        label.font = BreweryDesignSystem.FontTypes.robotoMediumXL
        label.textColor = BreweryDesignSystem.Colors.black
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var ratingMessage: UILabel = {
        let label = UILabel()
        label.text = Texts.ratingSubtextMessage
        label.font = BreweryDesignSystem.FontTypes.robotoLightX
        label.textColor = BreweryDesignSystem.Colors.black
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Favorites screen + Cell
    
    lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.ratingResults
        label.font = BreweryDesignSystem.FontTypes.robotoMediumX
        label.textColor = BreweryDesignSystem.Colors.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var ratingResultsText: UILabel = {
        let label = UILabel()
        label.font = BreweryDesignSystem.FontTypes.robotoLightXL
        label.textColor = BreweryDesignSystem.Colors.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        return filterButton
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.register(BreweryRatingViewCell.self, forCellReuseIdentifier: BreweryRatingViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var filterViewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Setups
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupView()
        setupEmail()
        viewModel.delegate = self
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let email = emailTextField.text else { return }
        let isValidateEmail = viewModel.isValidEmail(email: email)
        viewModel.setStateEmail(isEmail: isValidateEmail)
    }
    
    @objc func buttonSelectChange(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
    
    @objc func didTapSelectionButton(_ sender: UIButton) {
        indicatorView.startAnimating()
        viewModel.getEvaluationByEmail(viewModel.getEmail())
    }
    
    private func setupNavigation() {
        appearance.backgroundColor = BreweryDesignSystem.Colors.yellow
        appearance.shadowColor = .clear
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = BreweryDesignSystem.Colors.black
        navigationController?.navigationBar.isTranslucent = true
    }
    
    private func setupView() {
        view.backgroundColor = BreweryDesignSystem.Colors.background
        
        view.addSubview(breweryHeaderImageView)
        breweryHeaderImageView.addSubview(headerLabel)
        breweryHeaderImageView.addSubview(headerTextLabel)
        
        NSLayoutConstraint.activate([
            breweryHeaderImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            breweryHeaderImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            breweryHeaderImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            breweryHeaderImageView.heightAnchor.constraint(equalToConstant: 180),
            
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            headerTextLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 41),
            headerTextLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headerTextLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -70),
        ])
    }
    
    private func setupEmail() {
        view.addSubview(indicatorView)
        
        view.addSubview(emailTextField)
        view.addSubview(emailError)
        view.addSubview(emailCheckbox)
        view.addSubview(confirmButton)
        
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: breweryHeaderImageView.bottomAnchor, constant: 30),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            emailTextField.heightAnchor.constraint(equalToConstant: 56),
            
            emailError.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 12),
            emailError.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            
            emailCheckbox.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 33),
            emailCheckbox.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 41),
            
            confirmButton.topAnchor.constraint(equalTo: emailCheckbox.bottomAnchor, constant: 45),
            confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            confirmButton.heightAnchor.constraint(equalToConstant: 40),
            
            indicatorView.topAnchor.constraint(equalTo: confirmButton.bottomAnchor, constant: 30),
            indicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupTableView() {
        indicatorView.stopAnimating()
        
        view.addSubview(ratingLabel)
        view.addSubview(ratingResultsText)
        view.addSubview(tableView)
        view.addSubview(orderRuleLabel)
        view.addSubview(filterButton)
        
        headerTextLabel.removeFromSuperview()
        emailTextField.removeFromSuperview()
        emailError.removeFromSuperview()
        emailCheckbox.removeFromSuperview()
        confirmButton.removeFromSuperview()
        
        NSLayoutConstraint.activate([
            ratingLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 21),
            ratingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            ratingResultsText.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 2),
            ratingResultsText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            orderRuleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            orderRuleLabel.topAnchor.constraint(equalTo: ratingResultsText.bottomAnchor, constant: 14),
            
            filterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            filterButton.topAnchor.constraint(equalTo: ratingResultsText.bottomAnchor, constant: 14),
            
            tableView.topAnchor.constraint(equalTo: orderRuleLabel.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupDefaultMessage() {
        indicatorView.stopAnimating()
        
        view.addSubview(ratingText)
        view.addSubview(ratingMessage)
        
        headerTextLabel.removeFromSuperview()
        emailTextField.removeFromSuperview()
        emailError.removeFromSuperview()
        emailCheckbox.removeFromSuperview()
        confirmButton.removeFromSuperview()
        
        NSLayoutConstraint.activate([
            ratingText.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            ratingText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 86),
            ratingText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -87),
            
            ratingMessage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 61),
            ratingMessage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -61),
            ratingMessage.topAnchor.constraint(equalTo: ratingText.bottomAnchor, constant: 16)
        ])
    }
}

extension RatingViewController: RatingViewControllerDelegate {
    func reloadTableView() {
        DispatchQueue.main.async {
            self.setupTableView()
            self.ratingResultsText.text = self.viewModel.getResultLabelText()
        }
    }
    
    func showDefaultMessage() {
        DispatchQueue.main.async {
            self.setupDefaultMessage()
        }
    }
    
    func showValidEmail() {
        emailTextField.layer.borderColor = BreweryDesignSystem.Colors.green.cgColor
        emailTextField.layer.borderWidth = 2.0
        confirmButton.backgroundColor = BreweryDesignSystem.Colors.yellowButton
        confirmButton.setTitleColor(BreweryDesignSystem.Colors.buttonLabelColor, for: .normal)
        confirmButton.isEnabled = true
        emailError.isHidden = true
        emailTextField.rightViewMode = .never
    }
    
    func showInvalidEmail() {
        emailTextField.layer.borderColor = BreweryDesignSystem.Colors.red.cgColor
        emailTextField.layer.borderWidth = 2.0
        confirmButton.backgroundColor = BreweryDesignSystem.Colors.buttonInactive
        confirmButton.setTitleColor(BreweryDesignSystem.Colors.buttonLabelColorInactive, for: .normal)
        confirmButton.isEnabled = false
        emailError.isHidden = false
        emailTextField.rightViewMode = .always
    }
    
    func showDefaultEmail() {
        emailTextField.layer.borderColor = BreweryDesignSystem.Colors.black.cgColor
        emailTextField.layer.cornerRadius = 10.0
        emailTextField.layer.borderWidth = 1.0
        confirmButton.backgroundColor = BreweryDesignSystem.Colors.buttonInactive
        confirmButton.isEnabled = false
        emailError.isHidden = true
        emailTextField.leftViewMode = .always
        emailTextField.rightViewMode = .never
    }
}

extension RatingViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getBreweryCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: BreweryRatingViewCell.identifier, for: indexPath) as? BreweryRatingViewCell {
            
            cell.setupHomeCell(viewModel, indexPath)
            
            return cell
        }
        return UITableViewCell()
    }
}
