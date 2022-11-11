import Foundation
import UIKit
import Cosmos
import Combine
import Resolver

class DetailsBreweryViewController: UIViewController {
    
    var collectionViewHeight: NSLayoutConstraint?
    var imagePicker = UIImagePickerController()
    var breweryDetails: BreweryDetailsModel? = nil
    var breweryDetailsId: String? = nil
    @Injected var viewModel: BreweryDetailsViewModel
    
    private var cancellables: Set<AnyCancellable> = []
    
    lazy var appearance = UINavigationBarAppearance()
    
    // MARK: - HeaderView
    lazy var breweryHeaderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "header")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.breweryDetails
        label.font = BreweryDesignSystem.FontTypes.robotoRegularXL
        label.textColor = BreweryDesignSystem.Colors.black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - SecondView
    
    lazy var contentScrollView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentSize = CGSize(width: self.view.bounds.width, height: self.view.bounds.height * 2)
        scrollView.bounces = scrollView.contentOffset.y > 100
        return scrollView
    }()
    
    lazy var breweryDetailView: UIView = {
        let viewDetail = UIView()
        viewDetail.translatesAutoresizingMaskIntoConstraints = false
        viewDetail.backgroundColor = .white
        viewDetail.layer.cornerRadius = 36
        viewDetail.layer.shadowColor = UIColor.black.cgColor
        viewDetail.layer.shadowOpacity = 0.2
        viewDetail.layer.shadowOffset = .zero
        viewDetail.layer.shadowRadius = 10
        return viewDetail
    }()
    
    lazy var backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = BreweryDesignSystem.Colors.yellowLight
        view.clipsToBounds = true
        view.layer.cornerRadius = 25
        return view
    }()
    
    lazy var initialLetter: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = BreweryDesignSystem.FontTypes.robotoBlack
        label.textColor = BreweryDesignSystem.Colors.yellowLetter
        label.numberOfLines = 0
        return label
    }()
    
    lazy var nameAndTypeStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [breweryNameLabel, breweryTypeLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 6
        
        return stack
    }()
    
    lazy var breweryNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = BreweryDesignSystem.FontTypes.quicksandBold
        label.textColor = BreweryDesignSystem.Colors.black
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    lazy var breweryTypeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = BreweryDesignSystem.FontTypes.quicksandRegular
        label.textColor = BreweryDesignSystem.Colors.black
        label.numberOfLines = 0
        return label
    }()
    
    lazy var evaluationStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [breweryEvaluationLabel, ratingStackView])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 6
        stack.alignment = .center
        return stack
    }()
    
    lazy var breweryEvaluationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = BreweryDesignSystem.FontTypes.quicksandRegular
        label.textColor = BreweryDesignSystem.Colors.blackLight
        label.numberOfLines = 0
        return label
    }()
    
    lazy var breweryStarRatingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = BreweryDesignSystem.FontTypes.quicksandMedium
        label.textColor = BreweryDesignSystem.Colors.black
        label.numberOfLines = 0
        return label
    }()
    
    lazy var ratingView: CosmosView = {
        var view = CosmosView()
        view.settings.updateOnTouch = true
        view.settings.emptyImage = UIImage(named: "empty-star")?.withRenderingMode(.alwaysOriginal)
        view.settings.filledImage = UIImage(named: "star")?.withRenderingMode(.alwaysOriginal)
        view.settings.disablePanGestures = true
        view.settings.totalStars = 5
        view.settings.starSize = 13
        view.settings.updateOnTouch = false
        view.settings.starMargin = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var ratingStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [breweryStarRatingLabel, ratingView])
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 1.5
        return stack
    }()
    
    lazy var globeImageView: UIImageView = {
        let uiImage = UIImageView()
        uiImage.translatesAutoresizingMaskIntoConstraints = false
        uiImage.image = UIImage(systemName: "globe")
        uiImage.tintColor = .black
        return uiImage
    }()
    
    lazy var urlLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = BreweryDesignSystem.FontTypes.robotoLight
        label.textColor = BreweryDesignSystem.Colors.black
        label.numberOfLines = 0
        return label
    }()
    
    lazy var firstSeparatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = BreweryDesignSystem.Colors.separatorColor
        return view
    }()
    
    lazy var addressStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [pointerImageView, addressLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 20
        stack.alignment = .center
        return stack
    }()
    
    lazy var pointerImageView: UIImageView = {
        let uiImage = UIImageView()
        uiImage.translatesAutoresizingMaskIntoConstraints = false
        uiImage.image = UIImage(named: "location")
        uiImage.tintColor = .black
        return uiImage
    }()
    
    lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = BreweryDesignSystem.FontTypes.robotoLight
        label.textColor = BreweryDesignSystem.Colors.black
        label.numberOfLines = 0
        return label
    }()
    
    lazy var secondSeparatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = BreweryDesignSystem.Colors.separatorColor
        return view
    }()
    
    lazy var mapStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [mapImageView, mapButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 18
        stack.alignment = .center
        return stack
    }()
    
    lazy var mapImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "map")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var mapButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        button.setTitle(Texts.findOnMap, for: .normal)
        button.titleLabel?.font = BreweryDesignSystem.FontTypes.robotoMediumS
        button.setTitleColor(UIColor.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var thirdSeparatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = BreweryDesignSystem.Colors.separatorColor
        return view
    }()
    
    lazy var photosCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 121, height: 101)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(DetailsCollectionViewCell.self, forCellWithReuseIdentifier: DetailsCollectionViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    lazy var addPhotosButton: UIButton = {
        var filled = UIButton.Configuration.bordered()
        filled.buttonSize = .mini
        filled.image = UIImage(systemName: "photo.on.rectangle")
        filled.imagePlacement = .leading
        filled.imagePadding = 9.5
        filled.baseBackgroundColor = BreweryDesignSystem.Colors.white
        filled.attributedTitle = AttributedString(Texts.addPicture, attributes: AttributeContainer([NSAttributedString.Key.font : BreweryDesignSystem.FontTypes.robotoMediumS!]))
        filled.baseForegroundColor = BreweryDesignSystem.Colors.black
        
        let button = UIButton(configuration: filled, primaryAction: nil)
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        button.layer.borderColor = BreweryDesignSystem.Colors.black.cgColor
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(self.uploadPhoto(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var evaluationButton: UIButton = {
        var filled = UIButton.Configuration.filled()
        filled.buttonSize = .mini
        filled.image = UIImage(named: "star-filled")
        filled.imagePlacement = .leading
        filled.imagePadding = 9.5
        filled.baseBackgroundColor = BreweryDesignSystem.Colors.yellowButton
        filled.attributedTitle = AttributedString(Texts.rateThisBrewery, attributes: AttributeContainer([NSAttributedString.Key.font : BreweryDesignSystem.FontTypes.robotoMediumS!]))
        filled.baseForegroundColor = BreweryDesignSystem.Colors.buttonLabelColor
        
        let button = UIButton(configuration: filled, primaryAction: nil)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(didTapButtonEvaluation), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var successStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [successImageView, successLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 20
        stack.alignment = .center
        return stack
    }()
    
    lazy var successImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "Beer-ok")
        return image
    }()
    
    lazy var successLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Texts.isEvaluated
        label.font = BreweryDesignSystem.FontTypes.robotoRegular
        label.textColor = BreweryDesignSystem.Colors.green
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var heartButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "heart")?.withTintColor(BreweryDesignSystem.Colors.black, renderingMode: .alwaysOriginal), for: .normal)
        button.setImage(UIImage(systemName: "heart.fill")?.withTintColor(BreweryDesignSystem.Colors.red, renderingMode: .alwaysOriginal), for: .selected)
        button.contentMode = .scaleToFill
        button.imageView?.layer.transform = CATransform3DMakeScale(1.2, 1.2, 1.2)
        button.addTarget(self, action:#selector(buttonSelectChange), for: UIControl.Event.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
        sinkBreweryDetails()
        
        setBreweryDetailsId()
        
        setupView()
        setupNavigation()
        setupBarButtonItens()
        setupConstraints()
        
    }
    
    private func setBreweryDetailsId() {
        if let id = breweryDetailsId {
            viewModel.getBreweryDetailsBy(id: id)
            viewModel.fetchBreweryImages(breweryId: id)
        }
    }
    
    private func sinkBreweryDetails() -> Void {
        viewModel.$state.sink { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                    
                case .initial: break
                    
                case .loading: break
                    
                case .retrievePhotos(let photos):
                    self?.reloadCollectionView(photos)
                    self?.setupConstraints()
                    
                case .retrieveDetails(let breweryDetails):
                    self?.setup(breweryDetails)
                    self?.setupFavoriteButton(breweryDetails)
                    DispatchQueue.main.async {
                        self?.updateConstraintsForCollectionView(breweryDetails: breweryDetails)
                    }
                    if (breweryDetails.isEvaluation == true) {
                        DispatchQueue.main.async {
                            self?.configureConstraintStackViewSuccess()
                        }
                    
                    }
                    
                case .failure: break
                    
                }
            }
        }.store(in: &cancellables)
    }
    
    func setupFavoriteButton(_ breweryDetails: BreweryDetailsModel) {
        viewModel.getFavoriteBreweries()
        
        guard let brewery = breweryDetails.getBrewery() else { return }
        
        heartButton.isSelected = viewModel.isFavorited(brewery: brewery)
    }
    
    private func reloadCollectionView(_ photos: BreweryDetailsModel) {
        photosCollectionView.reloadData()
    }
    
    private func setup(_ breweryDetails: BreweryDetailsModel) {
        self.breweryDetails = breweryDetails
        initialLetter.text = breweryDetails.getFirstLetterNameBrewery()
        breweryNameLabel.text = breweryDetails.getFullNameBrewery()
        breweryTypeLabel.text = breweryDetails.getBreweryType()
        breweryEvaluationLabel.text = breweryDetails.getSizeEvaluations()
        breweryStarRatingLabel.text = breweryDetails.formatAverage()
        ratingView.rating = Double(breweryDetails.getAverage())
        urlLabel.text = breweryDetails.getBreweryWebSite()
        addressLabel.text = breweryDetails.getBreweryAddress()
        
        if breweryDetails.isLocationAvailable() {
            mapButton.addTarget(self, action: #selector(openMapButtonAction), for: .touchUpInside)
        } else {
            mapStackView.isHidden = true
            self.thirdSeparatorView.topAnchor.constraint(equalTo: self.addressStackView.bottomAnchor, constant: 8).isActive = true
        }
        photosCollectionView.reloadData()
    }
    
    private func setupView() {
        view.backgroundColor = BreweryDesignSystem.Colors.white
        view.addSubview(scrollView)
        scrollView.addSubview(contentScrollView)
        contentScrollView.addSubview(breweryHeaderImageView)
        breweryHeaderImageView.addSubview(detailLabel)
        contentScrollView.addSubview(breweryDetailView)
        
        breweryDetailView.addSubview(backgroundView)
        breweryDetailView.addSubview(nameAndTypeStackView)
        breweryDetailView.addSubview(evaluationStackView)
        breweryDetailView.addSubview(globeImageView)
        breweryDetailView.addSubview(urlLabel)
        breweryDetailView.addSubview(firstSeparatorView)
        breweryDetailView.addSubview(addressStackView)
        breweryDetailView.addSubview(secondSeparatorView)
        
        breweryDetailView.addSubview(mapStackView)
        mapButton.underline()
        
        breweryDetailView.addSubview(thirdSeparatorView)
        breweryDetailView.addSubview(photosCollectionView)
        
        breweryDetailView.addSubview(addPhotosButton)
        
        breweryDetailView.addSubview(evaluationButton)
        
        backgroundView.addSubview(initialLetter)
        
        evaluationStackView.addSubview(ratingStackView)
        
    }
    
    private func setupNavigation() {
        appearance.backgroundColor = BreweryDesignSystem.Colors.yellow
        appearance.shadowColor = .clear
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = BreweryDesignSystem.Colors.black
        navigationController?.navigationBar.isTranslucent = true
    }
    
    private func setupBarButtonItens() {
        let barButtonHeart = UIBarButtonItem(customView: heartButton)
        navigationItem.rightBarButtonItems = [barButtonHeart]
    }
    
    override func viewDidLayoutSubviews() {
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: self.view.bounds.width, height: self.view.bounds.height)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentScrollView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentScrollView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            contentScrollView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentScrollView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentScrollView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentScrollView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            breweryHeaderImageView.topAnchor.constraint(equalTo: contentScrollView.topAnchor),
            breweryHeaderImageView.leadingAnchor.constraint(equalTo: contentScrollView.leadingAnchor),
            breweryHeaderImageView.trailingAnchor.constraint(equalTo: contentScrollView.trailingAnchor),
            breweryHeaderImageView.heightAnchor.constraint(equalToConstant: 180),
            
            detailLabel.topAnchor.constraint(equalTo: breweryHeaderImageView.topAnchor, constant: 5),
            detailLabel.leadingAnchor.constraint(equalTo: breweryHeaderImageView.leadingAnchor, constant: 16),
            
            breweryDetailView.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: 48),
            breweryDetailView.leadingAnchor.constraint(equalTo: contentScrollView.leadingAnchor, constant: 16),
            breweryDetailView.trailingAnchor.constraint(equalTo: contentScrollView.trailingAnchor, constant: -16),
            
            nameAndTypeStackView.topAnchor.constraint(equalTo: breweryDetailView.topAnchor, constant: 16),
            nameAndTypeStackView.leadingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: 7),
            nameAndTypeStackView.trailingAnchor.constraint(equalTo: evaluationStackView.leadingAnchor, constant: -6),
            
            evaluationStackView.topAnchor.constraint(equalTo: breweryDetailView.topAnchor, constant: 16),
            evaluationStackView.trailingAnchor.constraint(equalTo: breweryDetailView.trailingAnchor, constant: -16),
            
            globeImageView.topAnchor.constraint(equalTo: initialLetter.bottomAnchor, constant: 47),
            globeImageView.leadingAnchor.constraint(equalTo: breweryDetailView.leadingAnchor, constant: 18),
            
            urlLabel.topAnchor.constraint(equalTo: initialLetter.bottomAnchor, constant: 47),
            urlLabel.leadingAnchor.constraint(equalTo: globeImageView.trailingAnchor, constant: 18),
            
            firstSeparatorView.heightAnchor.constraint(equalToConstant: 1),
            firstSeparatorView.topAnchor.constraint(equalTo: globeImageView.bottomAnchor, constant: 8),
            firstSeparatorView.leadingAnchor.constraint(equalTo: breweryDetailView.leadingAnchor, constant: 16),
            firstSeparatorView.trailingAnchor.constraint(equalTo: breweryDetailView.trailingAnchor, constant: -16),
            
            addressStackView.topAnchor.constraint(equalTo: firstSeparatorView.bottomAnchor, constant: 22),
            addressStackView.leadingAnchor.constraint(equalTo: breweryDetailView.leadingAnchor, constant: 21),
            addressStackView.trailingAnchor.constraint(equalTo: breweryDetailView.trailingAnchor, constant: -18),
            
            addressLabel.leadingAnchor.constraint(equalTo: pointerImageView.trailingAnchor, constant: 21),
            addressLabel.trailingAnchor.constraint(equalTo: addressStackView.trailingAnchor, constant: -16),
            
            secondSeparatorView.heightAnchor.constraint(equalToConstant: 1),
            secondSeparatorView.topAnchor.constraint(equalTo: addressStackView.bottomAnchor, constant: 8),
            secondSeparatorView.leadingAnchor.constraint(equalTo: breweryDetailView.leadingAnchor, constant: 16),
            secondSeparatorView.trailingAnchor.constraint(equalTo: breweryDetailView.trailingAnchor, constant: -16),
            
            mapStackView.topAnchor.constraint(equalTo: secondSeparatorView.bottomAnchor, constant: 29),
            mapStackView.leadingAnchor.constraint(equalTo: breweryDetailView.leadingAnchor, constant: 19),
            
            thirdSeparatorView.topAnchor.constraint(equalTo: mapButton.bottomAnchor, constant: 13),
            thirdSeparatorView.heightAnchor.constraint(equalToConstant: 1),
            thirdSeparatorView.leadingAnchor.constraint(equalTo: breweryDetailView.leadingAnchor, constant: 16),
            thirdSeparatorView.trailingAnchor.constraint(equalTo: breweryDetailView.trailingAnchor, constant: -16),
            
            photosCollectionView.topAnchor.constraint(equalTo: thirdSeparatorView.bottomAnchor, constant: 16),
            photosCollectionView.leadingAnchor.constraint(equalTo: breweryDetailView.leadingAnchor, constant: 16),
            photosCollectionView.trailingAnchor.constraint(equalTo: breweryDetailView.trailingAnchor, constant: -16),
            
            addPhotosButton.heightAnchor.constraint(equalToConstant: 40),
            addPhotosButton.leadingAnchor.constraint(equalTo: breweryDetailView.leadingAnchor, constant: 16),
            addPhotosButton.trailingAnchor.constraint(equalTo: breweryDetailView.trailingAnchor, constant: -16),
            addPhotosButton.topAnchor.constraint(equalTo: photosCollectionView.bottomAnchor, constant: 20),
            
            evaluationButton.topAnchor.constraint(equalTo: addPhotosButton.bottomAnchor, constant: 15),
            evaluationButton.leadingAnchor.constraint(equalTo: breweryDetailView.leadingAnchor, constant: 16),
            evaluationButton.trailingAnchor.constraint(equalTo: breweryDetailView.trailingAnchor, constant: -16),
            evaluationButton.bottomAnchor.constraint(equalTo: breweryDetailView.bottomAnchor, constant: -20),
            evaluationButton.heightAnchor.constraint(equalToConstant: 40),
            
            backgroundView.topAnchor.constraint(equalTo: breweryDetailView.topAnchor, constant: 16),
            backgroundView.leadingAnchor.constraint(equalTo: breweryDetailView.leadingAnchor, constant: 16),
            backgroundView.widthAnchor.constraint(equalToConstant: 48),
            backgroundView.heightAnchor.constraint(equalToConstant: 48),
            
            initialLetter.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            initialLetter.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
        ])
        
    }
    
    private func displayDetailsWithPhotoGallery() {
        
        self.collectionViewHeight = photosCollectionView.heightAnchor.constraint(equalToConstant: 0)
        self.collectionViewHeight?.isActive = true
        self.collectionViewHeight?.constant = 101
  
        photosCollectionView.setNeedsLayout()
        photosCollectionView.layoutIfNeeded()
 
    }
    
    private func updateConstraintsForCollectionView(breweryDetails: BreweryDetailsModel) {
        guard let breweryDetails = breweryDetails.brewery else { return }
        if let photos = breweryDetails.photos, photos.count > 0 {

            displayDetailsWithPhotoGallery()

        }
    }
    
    private func configureConstraintStackViewSuccess() {
        
        evaluationButton.removeFromSuperview()

        contentScrollView.addSubview(successStackView)
        
        NSLayoutConstraint.activate([
            
            successStackView.topAnchor.constraint(equalTo: addPhotosButton.bottomAnchor, constant: 22),
            successStackView.centerXAnchor.constraint(equalTo: breweryDetailView.centerXAnchor),

            breweryDetailView.bottomAnchor.constraint(equalTo: successStackView.bottomAnchor, constant: 20),
            
            successImageView.heightAnchor.constraint(equalToConstant: 60),
            successImageView.widthAnchor.constraint(equalToConstant: 56),
            
            successLabel.leadingAnchor.constraint(equalTo: successImageView.trailingAnchor, constant: 20),
        
        ])

    }
    
    @objc func buttonSelectChange(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        guard
            let breweryDetails = breweryDetails,
            let brewery = breweryDetails.getBrewery()
        else { return }
        
        let isFavorited = viewModel.isFavorited(brewery: brewery)
        
        viewModel.saveOrDeleteFavoriteAtCoreData(viewModel: viewModel, brewery: brewery, isFavorited: isFavorited, isSelected: sender.isSelected)
        
        viewModel.getFavoriteBreweries()
    }
    
    @objc func openMapButtonAction(sender: UIButton!) {
        guard let latitude = breweryDetails?.getLatitude() else { return }
        
        guard let longitude = breweryDetails?.getLongitude() else { return }
        
        let appleUrl = "http://maps.apple.com/?address=\(latitude),\(longitude)"
        let googleUrl = "comgooglemaps://?q=\(latitude),\(longitude)"
        let wazeUrl = "waze://?ll=\(latitude),\(longitude)&navigate=false"
        
        var installedNavigationApps = [(Texts.appleMaps, URL(string:appleUrl)!)]
        
        let googleItem = (Texts.googleMaps, URL(string:googleUrl)!)
        let wazeItem = (Texts.waze, URL(string:wazeUrl)!)
        
        if UIApplication.shared.canOpenURL(googleItem.1) {
            installedNavigationApps.append(googleItem)
        }
        
        if UIApplication.shared.canOpenURL(wazeItem.1) {
            installedNavigationApps.append(wazeItem)
        }
        
        let alert = UIAlertController(
            title: Texts.select,
            message: Texts.navigationApp,
            preferredStyle: .actionSheet
        )
        
        for app in installedNavigationApps {
            let button = UIAlertAction(title: app.0, style: .default, handler: { _ in
                UIApplication.shared.open(app.1, options: [:], completionHandler: nil)
            })
            alert.addAction(button)
        }
        
        let cancel = UIAlertAction(
            title: Texts.cancel,
            style: .cancel,
            handler: nil
        )
        
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    @objc func didTapButtonEvaluation() {
        let openModalRating = RatingModalViewController()
        openModalRating.modalPresentationStyle = .overCurrentContext
        
        if let brewery = breweryDetails {
            openModalRating.breweryDetails = brewery
            self.present(openModalRating, animated: false)
        }
    }
    
    @objc func uploadPhoto(_ sender: Any) {
        let alert = UIAlertController(title: Texts.addPicture, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: Texts.camera, style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: Texts.gallery, style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: Texts.cancel, style: .cancel, handler: nil))
        
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = sender as? UIView
            alert.popoverPresentationController?.sourceRect = sender as! CGRect
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        present(alert, animated: true)
    }
    
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }else {
            let alert  = UIAlertController(title: Texts.warning, message: Texts.cameraUnavailable, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: Texts.ok, style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary() {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func generateImageData(fileName: String, boundary: String, image: UIImage, paramName: String) -> Data {
        let imageCompression = image.compress(to: 300)
        var data = Data()
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(paramName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        data.append(imageCompression)
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        return data
    }
}

extension DetailsBreweryViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard
            let brewery = breweryDetails?.brewery,
            let breweryPhotos = brewery.photos
        else {
            return 0
        }
        return breweryPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailsCollectionViewCell.identifier, for: indexPath) as? DetailsCollectionViewCell {
            
            if let breweryPhotos = breweryDetails?.brewery?.photos {
                let imageUrlString = breweryPhotos[indexPath.row] ?? ""
                if let imageUrl = breweryDetails?.getUrlImage(url: imageUrlString) {
                    cell.breweryImage.load(imageUrl, placeholder: UIImage(named: "brewery-placeholder"))
                }
            }
            return cell
        }
        return DetailsCollectionViewCell()
    }
}

extension DetailsBreweryViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard
            let boundary = self.breweryDetails?.generateBoundary(),
            let breweryDetails = breweryDetails,
            let breweryId = breweryDetails.brewery?.id,
            let breweryName = breweryDetails.brewery?.name
        else { return }
        
        if let editedImage = info[.editedImage] as? UIImage{
            
            let data = self.generateImageData(fileName: breweryName, boundary: boundary, image: editedImage, paramName: "file")
            self.viewModel.uploadImage(data: data, boundary: boundary, breweryId: breweryId) { [weak self] response in
                switch response {
                case .success(_):
                    self?.viewModel.fetchBreweryImages(breweryId: breweryId)
                    self?.viewModel.getBreweryDetailsBy(id: breweryId)
                case .failure(_):
                    break
                }
            }
        }
        
        picker.dismiss(animated: true) {
            
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
}
