import UIKit
import Cosmos
import Resolver

class RatingModalViewController: UIViewController {
        
    @Injected var viewModel: RatingModalViewModel
    var breweryDetails: BreweryDetailsModel? = nil
    
    // MARK: - Container View
    let maxDimmedAlpha: CGFloat = 0.4
    var containerViewHeightConstraint: NSLayoutConstraint?
    var containerViewBottomConstraint: NSLayoutConstraint?
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 32
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
    
    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.tintColor = BreweryDesignSystem.Colors.black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action:#selector(handleCloseAction), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    // MARK: - Email View
    lazy var ratingBreweryLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.rateBreweryModal + "\(breweryDetails?.brewery?.name ?? "")"
        label.textColor = BreweryDesignSystem.Colors.black
        label.font = BreweryDesignSystem.FontTypes.robotoMediumXL
        
        label.numberOfLines = 0
        label.textAlignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var ratingView: CosmosView = {
        var view = CosmosView()
        view.settings.updateOnTouch = true
        view.settings.emptyImage = UIImage(named: "empty-star")?.withRenderingMode(.alwaysOriginal)
        view.settings.filledImage = UIImage(named: "star")?.withRenderingMode(.alwaysOriginal)
        view.settings.disablePanGestures = true
        view.settings.totalStars = 5
        view.settings.starSize = 33
        view.rating = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
        textField.keyboardType = .emailAddress
        
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
    
    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = BreweryDesignSystem.Colors.background
        button.setTitleColor(BreweryDesignSystem.Colors.buttonLabelColorInactive, for: .normal)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.setTitle(Texts.ratingSave, for: .normal)
        button.isEnabled = false
        button.addTarget(self, action: #selector(saveButtonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Success and Error Views
    lazy var successLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.ratingSuccessTitle
        label.font = BreweryDesignSystem.FontTypes.robotoMediumXL
        label.textColor = BreweryDesignSystem.Colors.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var successImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Beer-ok")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var successText: UILabel = {
        let label = UILabel()
        label.text = Texts.ratingSuccess
        label.font = BreweryDesignSystem.FontTypes.robotoLightX
        label.textColor = BreweryDesignSystem.Colors.green
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.ratingErrorTitle
        label.font = BreweryDesignSystem.FontTypes.robotoMediumXL
        label.textColor = BreweryDesignSystem.Colors.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var errorImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Beer-fail")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var errorText: UILabel = {
        let label = UILabel()
        label.text = Texts.ratingError
        label.font = BreweryDesignSystem.FontTypes.robotoLightX
        label.textColor = BreweryDesignSystem.Colors.red
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    
    // MARK: - View Configuration
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addContainerView()
        addEmailForm()
        setupConstraints()
        setupEmailConstraints()
        
        viewModel.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateShowDimmedView()
        animatePresentContainer()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func handleCloseAction() {
        animateDismissView()
    }
    
    @objc func buttonSelectChange(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let email = emailTextField.text else { return }
        
        viewModel.validateEmail(email: email)
    }
    
    @objc func saveButtonAction(sender: UIButton!) {
        
        ratingView.didTouchCosmos = { rating in
            self.ratingView.rating = rating
        }
        
        let evaluationGrade = ratingView.rating
        
        let breweryID = breweryDetails?.brewery?.id ?? ""
                
        viewModel.saveRating(breweryID: breweryID, evaluationGrade: evaluationGrade)
    }
    
    func addContainerView() {
        view.addSubview(dimmedView)
        view.addSubview(containerView)
        view.addSubview(closeButton)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleCloseAction))
        dimmedView.addGestureRecognizer(tapGesture)
    }
    
    func addEmailForm() {
        view.addSubview(ratingView)
        view.addSubview(ratingBreweryLabel)
        view.addSubview(emailTextField)
        view.addSubview(emailError)
        view.addSubview(emailCheckbox)
        view.addSubview(saveButton)
    }
    
    func addSuccessCard() {
        view.addSubview(successLabel)
        view.addSubview(successImage)
        view.addSubview(successText)
    }
    
    func addErrorCard() {
        view.addSubview(errorLabel)
        view.addSubview(errorImage)
        view.addSubview(errorText)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            dimmedView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dimmedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            closeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 33),
            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -33),
            
        ])
        
        containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: 370)
        containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 370)
        containerViewHeightConstraint?.isActive = true
        containerViewBottomConstraint?.isActive = true
        
    }
    
    func setupEmailConstraints() {
        NSLayoutConstraint.activate([
            ratingBreweryLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 60),
            ratingBreweryLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            ratingBreweryLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            
            ratingView.topAnchor.constraint(equalTo: ratingBreweryLabel.bottomAnchor, constant: 11),
            ratingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            emailTextField.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: 25),
            emailTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            emailTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            emailTextField.heightAnchor.constraint(equalToConstant: 56),
            
            emailError.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 40),
            emailError.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 4),
            
            emailCheckbox.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 41),
            emailCheckbox.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: 111),
            
            saveButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            saveButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            saveButton.topAnchor.constraint(equalTo: emailCheckbox.bottomAnchor, constant: 34),
            saveButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func setupSuccessConstraints() {
        NSLayoutConstraint.activate([
            successLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 76),
            successLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            successImage.topAnchor.constraint(equalTo: successLabel.bottomAnchor, constant: 32),
            successImage.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            successText.topAnchor.constraint(equalTo: successImage.bottomAnchor, constant: 20),
            successText.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 98),
            successText.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -98)
        ])
    }
    
    func setupErrorConstraints() {
        NSLayoutConstraint.activate([
            errorLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 76),
            errorLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            errorImage.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 32),
            errorImage.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            errorText.topAnchor.constraint(equalTo: errorImage.bottomAnchor, constant: 20),
            errorText.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 47),
            errorText.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -47)
        ])
    }
    
    // MARK: - Present and dismiss animation
    func animateContainerHeight(_ height: CGFloat) {
        UIView.animate(withDuration: 0.4) {
            self.containerViewHeightConstraint?.constant = height
            self.view.layoutIfNeeded()
        }
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
            self.containerViewBottomConstraint?.constant = 370
            self.view.layoutIfNeeded()
        }
    }
}

extension RatingModalViewController: RatingModalDelegate {
    func updateScreen() {
        DispatchQueue.main.async {
            if let navigationController = self.presentingViewController as? UINavigationController,
                let viewController = navigationController.viewControllers.last {
                viewController.viewDidLoad()
            }
        }
    }
    
    func showSuccessCard() {
        DispatchQueue.main.async {
            self.ratingView.removeFromSuperview()
            self.ratingBreweryLabel.removeFromSuperview()
            self.emailTextField.removeFromSuperview()
            self.emailError.removeFromSuperview()
            self.emailCheckbox.removeFromSuperview()
            self.saveButton.removeFromSuperview()
            
            self.addSuccessCard()
            self.setupSuccessConstraints()
        }
    }
    
    func showErrorCard() {
        DispatchQueue.main.async {
            self.ratingView.removeFromSuperview()
            self.ratingBreweryLabel.removeFromSuperview()
            self.emailTextField.removeFromSuperview()
            self.emailError.removeFromSuperview()
            self.emailCheckbox.removeFromSuperview()
            self.saveButton.removeFromSuperview()
            
            self.addErrorCard()
            self.setupErrorConstraints()
        }
    }
    
    func showValidEmail() {
        emailTextField.layer.borderColor = BreweryDesignSystem.Colors.green.cgColor
        emailTextField.layer.borderWidth = 2.0
        saveButton.backgroundColor = BreweryDesignSystem.Colors.yellowButton
        saveButton.setTitleColor(BreweryDesignSystem.Colors.buttonLabelColor, for: .normal)
        saveButton.isEnabled = true
        emailError.isHidden = true
        emailTextField.rightViewMode = .never
    }
    
    func showInvalidEmail() {
        emailTextField.layer.borderColor = BreweryDesignSystem.Colors.red.cgColor
        emailTextField.layer.borderWidth = 2.0
        saveButton.backgroundColor = BreweryDesignSystem.Colors.buttonInactive
        saveButton.setTitleColor(BreweryDesignSystem.Colors.buttonLabelColorInactive, for: .normal)
        saveButton.isEnabled = false
        emailError.isHidden = false
        emailTextField.rightViewMode = .always
    }
    
    func showDefaultEmail() {
        emailTextField.layer.borderColor = BreweryDesignSystem.Colors.black.cgColor
        emailTextField.layer.cornerRadius = 10.0
        emailTextField.layer.borderWidth = 1.0
        saveButton.backgroundColor = BreweryDesignSystem.Colors.buttonInactive
        saveButton.isEnabled = false
        emailError.isHidden = true
        emailTextField.leftViewMode = .always
        emailTextField.rightViewMode = .never
    }
}
