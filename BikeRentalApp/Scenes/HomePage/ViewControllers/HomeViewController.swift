//
//  HomeViewController.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 03.07.24.
//

import UIKit
import MessageUI

// MARK: - HomeViewController

final class HomeViewController: UIViewController {
    
    // MARK: - UI Components and properties
    
    private var scrollView = UIScrollView()
    
    private var contentView = UIView()
    
    private var mainStackView = CustomStackView(
        axis: .vertical,
        spacing: Sizing.mainStackViewSpacing,
        alignment: .fill
    )
    
    private var headerStackView = CustomStackView(
        axis: .horizontal,
        spacing: Sizing.headerStackViewSpacing,
        alignment: .center,
        distribution: .fillProportionally
    )
    
    private var popularsSegmentStackView = CustomStackView(
        axis: .horizontal,
        spacing: Sizing.popularsSegmentStackViewSpacing,
        alignment: .center,
        distribution: .equalSpacing
    )
    
    private var sliderCollectionView = Slider(
        itemWidth: Sizing.sliderItemWidth,
        cell: SliderCollectionViewCell.self,
        identifier: SliderCollectionViewCell.identifier,
        tag: 2
    )
    
    private var nameLabel = CustomUiLabel(
        fontSize: Sizing.nameLabelFontSize,
        text: "",
        tintColor: Colors.defaultTintColor,
        fontWeight: .medium
    )
    
    private var titleLabel = CustomUiLabel(
        fontSize: Sizing.titleLabelFontSize,
        text: Titles.titleLabelText,
        tintColor: Colors.defaultTintColor
    )
    
    private var viewAllButton = CustomButton(
        title: Titles.viewAllButtonTitle,
        width: Sizing.viewAllButtonWidth
    )
    
    private var mainTitleLabel = CustomUiLabel(
        fontSize: Sizing.mainTitleLabelFontSize,
        text: Titles.mainTitleLabelText,
        tintColor: Colors.defaultTintColor
    )
    
    private var fullMapButton = SmallCustomButton(
        width: Sizing.fullMapButtonWidth,
        height: Sizing.fullMapButtonHeight,
        backgroundImage: Images.fullMapIcon,
        backgroundColor: Colors.buttonBackgroundColor
    )
    
    private var scannerButton = SmallCustomButton(
        width: Sizing.scannerButtonWidth,
        height: Sizing.scannerButtonHeight,
        backgroundImage: Images.scanBikeIcon,
        backgroundColor: Colors.buttonBackgroundColor
    )
    
    private var bottomButtonsStackView = CustomStackView(
        axis: .horizontal,
        spacing: Sizing.bottomButtonsStackViewSpacing,
        alignment: .center,
        distribution: .equalSpacing
    )
    
    private var customBackgroundView = CustomRectangleView(color: .white)
    
    private var shareButton = SmallCustomButton(
        width: Sizing.smallButtonWidth,
        height: Sizing.smallButtonHeight,
        backgroundImage: Images.reminderImage,
        backgroundColor: .white
    )
    
    private var emailButton = SmallCustomButton(
        width: Sizing.smallButtonWidth,
        height: Sizing.smallButtonHeight,
        backgroundImage: Images.emailImage,
        backgroundColor: Colors.buttonBackgroundColor
    )
    
    private var messageButton = SmallCustomButton(
        width: Sizing.smallButtonWidth,
        height: Sizing.smallButtonHeight,
        backgroundImage: Images.messageImage,
        backgroundColor: Colors.buttonBackgroundColor
    )
    
    private lazy var popularBikesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = Sizing.collectionViewLineSpacing
        layout.minimumInteritemSpacing = Sizing.collectionViewItemSpacing
        layout.itemSize = CGSize(width: Sizing.popularBikeItemWidth, height: Sizing.popularBikeItemHeight)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(BikeCollectionViewCell.self,
                                forCellWithReuseIdentifier: BikeCollectionViewCell.identifier)
        collectionView.tag = 1
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = viewModel.salesImagesArray.count
        pageControl.currentPage = .zero
        pageControl.currentPageIndicatorTintColor = Colors.pageControlCurrentPageTintColor
        pageControl.pageIndicatorTintColor = Colors.pageControlIndicatorTintColor
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    private var viewModel = HomeViewModel()
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.startTimer()
        setupUI()
        addTargets()
        setDelegates()
        viewModel.viewDidLoad()
        getUser()
    }
    
    // MARK: - Get user
    
    private func getUser() {
        AuthService.shared.getUser { [weak self] user, error in
            guard let self = self else { return }
            if let user = user {
                self.nameLabel.text = "Hello, \(user.username)"
            }
        }
    }
    
    // MARK: - Ui setup
    
    private func setupUI() {
        setupView()
        setupViewHierarchy()
        setConstraints()
    }
    
    private func setupView() {
        view.backgroundColor = .loginBackground
        
    }
    
    private func setupViewHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(customBackgroundView)
        contentView.sendSubviewToBack(customBackgroundView)
        contentView.addSubview(mainStackView)
        
        mainStackView.addArrangedSubviews(
            headerStackView,
            mainTitleLabel,
            sliderCollectionView,
            pageControl,
            popularsSegmentStackView,
            popularBikesCollectionView,
            bottomButtonsStackView
        )
        
        headerStackView.addArrangedSubviews(
            scannerButton,
            nameLabel,
            fullMapButton
        )
        
        popularsSegmentStackView.addArrangedSubviews(
            titleLabel,
            viewAllButton
        )
        
        bottomButtonsStackView.addArrangedSubviews(
            shareButton,
            emailButton,
            messageButton
        )
    }
    
    private func setConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: Sizing.scrollViewTopAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Sizing.scrollViewLeadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Sizing.scrollViewTrailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: Sizing.scrollViewBottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: Sizing.contentViewTopPadding),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: Sizing.contentViewLeadingPadding),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: Sizing.contentViewTrailingPadding),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: Sizing.contentViewBottomPadding),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: Sizing.contentViewWidthAnchor),
            
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Sizing.mainStackViewHorizontalPadding),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Sizing.mainStackViewHorizontalPadding),
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Sizing.mainStackViewTopPadding),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            headerStackView.heightAnchor.constraint(equalToConstant: Sizing.headerStackViewHeight),
            nameLabel.leadingAnchor.constraint(equalTo: scannerButton.trailingAnchor, constant: Sizing.nameLabelLeadingSpacing),
            
            customBackgroundView.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: Sizing.customBackgroundViewWidth),
            customBackgroundView.heightAnchor.constraint(equalToConstant: Sizing.customBackgroundViewHeight),
            customBackgroundView.topAnchor.constraint(equalTo: mainStackView.topAnchor, constant: Sizing.customBackgroundViewTopPadding),
            
            sliderCollectionView.heightAnchor.constraint(equalToConstant: Sizing.sliderCollectionViewHeight),
            sliderCollectionView.topAnchor.constraint(equalTo: customBackgroundView.topAnchor, constant: Sizing.sliderCollectionViewTopPadding),
            
            popularBikesCollectionView.heightAnchor.constraint(equalToConstant: Sizing.popularBikesCollectionViewHeight)
        ])
        
    }
    
    // MARK: - Set delegates
    
    private func setDelegates() {
        sliderCollectionView.dataSource = self
        popularBikesCollectionView.dataSource = self
        popularBikesCollectionView.delegate = self
        viewModel.delegate = self
    }
    
    // MARK: - Actions
    
    private func addTargets() {
        fullMapButton.addTarget(self, action: #selector(fullMapButtonTapped), for: .touchUpInside)
        pageControl.addTarget(self, action: #selector(pageControlChanged(_:)), for: .valueChanged)
        viewAllButton.addTarget(self, action: #selector(viewAllButtonTapped), for: .touchUpInside)
        scannerButton.addTarget(self, action: #selector(scannerButtonTapped), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        emailButton.addTarget(self, action: #selector(sendEmailButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Action methods
    
    @objc private func pageControlChanged(_ sender: UIPageControl) {
        viewModel.pageControlChanged(to: pageControl.currentPage)
    }
    
    @objc private func fullMapButtonTapped() {
        navigationController?.pushViewController(FullMapViewController(), animated: true)
    }
    
    @objc private func scannerButtonTapped() {
        navigationController?.pushViewController(ScannerViewController(), animated: true)
    }
    
    @objc private func viewAllButtonTapped() {
        let vc = AllBikesViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func shareButtonTapped() {
        
        let activityItems: [Any] = [
            Sharing.textToShare,
            Sharing.urlToShare,
            Sharing.imageToShareName
        ].compactMap { $0 }
        
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        activityViewController.excludedActivityTypes = [.addToReadingList, .print]
        
        if let popover = activityViewController.popoverPresentationController {
            popover.sourceView = self.view
        }
        present(activityViewController, animated: true, completion: nil)
    }
    
    @objc private func sendEmailButtonTapped() {
        if MFMailComposeViewController.canSendMail() {
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            mailComposer.setSubject(Email.subject)
            mailComposer.setMessageBody(Email.messageBody, isHTML: false)
            mailComposer.setToRecipients([Email.recipient])
            present(mailComposer, animated: true, completion: nil)
        } else {
            print("Can not show mail composer")
        }
    }
    
}

// MARK: - CollectionView datasource and delegate

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 1 {
            let bikesArray = viewModel.cheapBikes
            guard let customCell = collectionView.dequeueReusableCell(withReuseIdentifier: BikeCollectionViewCell.identifier, for: indexPath) as? BikeCollectionViewCell else {
                return UICollectionViewCell()
            }
            customCell.configureBikeCell(image: bikesArray[indexPath.row].image, price: bikesArray[indexPath.row].price)
            return customCell
        } else if collectionView.tag == 2 {
            guard let customCell = collectionView.dequeueReusableCell(withReuseIdentifier: SliderCollectionViewCell.identifier, for: indexPath) as? SliderCollectionViewCell else {
                return UICollectionViewCell()
            }
            customCell.configureSliderCell(imageURL: viewModel.salesImagesArray[indexPath.row], text: viewModel.salesHeroTexts[indexPath.row], subtext: viewModel.salesSubtexts[indexPath.row])
            return customCell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1 {
            return viewModel.cheapBikes.count
        } else if collectionView.tag == 2 {
            return viewModel.salesImagesArray.count
        }
        return 0
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailsViewController(bike: viewModel.cheapBikes[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - HomeViewModelDelegate

extension HomeViewController: HomeViewModelDelegate {
    func reloadData() {
        popularBikesCollectionView.reloadData()
    }
    
    func scrollToItem(at indexPath: IndexPath, animated: Bool) {
        sliderCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func updatePageControl(currentPage: Int) {
        pageControl.currentPage = currentPage
    }
}

// MARK: - MFMailComposeViewControllerDelegate

extension HomeViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Constants Extension
extension HomeViewController {
    enum Sizing {
        static let mainStackViewSpacing: CGFloat = 20
        static let headerStackViewSpacing: CGFloat = 10
        static let popularsSegmentStackViewSpacing: CGFloat = 10
        static let bottomButtonsStackViewSpacing: CGFloat = 0
        
        static let nameLabelFontSize: CGFloat = 14
        static let titleLabelFontSize: CGFloat = 18
        static let mainTitleLabelFontSize: CGFloat = 30
        
        static let viewAllButtonWidth: CGFloat = 80
        static let fullMapButtonWidth: CGFloat = 40
        static let fullMapButtonHeight: CGFloat = 40
        static let scannerButtonWidth: CGFloat = 50
        static let scannerButtonHeight: CGFloat = 50
        static let smallButtonWidth: CGFloat = 40
        static let smallButtonHeight: CGFloat = 40
        
        static let sliderItemWidth: CGFloat = 350
        
        static let popularBikeItemWidth: CGFloat = 140
        static let popularBikeItemHeight: CGFloat = 181
        static let collectionViewLineSpacing: CGFloat = 10
        static let collectionViewItemSpacing: CGFloat = 10
        
        static let scrollViewTopAnchor: CGFloat = 0
        static let scrollViewLeadingAnchor: CGFloat = 0
        static let scrollViewTrailingAnchor: CGFloat = 0
        static let scrollViewBottomAnchor: CGFloat = 0
        
        static let contentViewWidthAnchor: CGFloat = 0
        static let contentViewTopPadding: CGFloat = 0
        static let contentViewLeadingPadding: CGFloat = 0
        static let contentViewTrailingPadding: CGFloat = 0
        static let contentViewBottomPadding: CGFloat = 0
        
        static let mainStackViewHorizontalPadding: CGFloat = 20
        static let mainStackViewTopPadding: CGFloat = 10
        static let headerStackViewHeight: CGFloat = 50
        
        static let nameLabelLeadingSpacing: CGFloat = 80
        static let customBackgroundViewWidth: CGFloat = 0
        static let customBackgroundViewHeight: CGFloat = 1000
        static let customBackgroundViewTopPadding: CGFloat = 150
        
        static let sliderCollectionViewHeight: CGFloat = 200
        static let sliderCollectionViewTopPadding: CGFloat = 50
        
        static let popularBikesCollectionViewHeight: CGFloat = 180
        
    }
    
    enum Titles {
        static let titleLabelText = "Affordable bikes"
        static let viewAllButtonTitle = "View All"
        static let mainTitleLabelText = "Find your next bike"
    }
    
    enum Images {
        static let fullMapIcon = "fullMapIcon"
        static let scanBikeIcon = "scanBikeIcon"
        static let reminderImage = "reminderImage"
        static let emailImage = "emailImage"
        static let messageImage = "messageImage"
    }
    
    enum Colors {
        static let defaultTintColor: UIColor = .black
        static let buttonBackgroundColor: UIColor = .white
        static let pageControlCurrentPageTintColor: UIColor = .black
        static let pageControlIndicatorTintColor: UIColor = .gray
        static let customBackgroundViewColor: UIColor = .white
    }
    
    enum Sharing {
        static let textToShare = "Check out this amazing bike rental app!"
        static let urlToShare = URL(string: "https://github.com/tamokakhidze/BikeRentalApp") as Any
        static let imageToShareName = "logoImage"
        static let excludedActivityTypes: [UIActivity.ActivityType] = [.addToReadingList, .print]
    }
    
    enum Email {
        static let subject = "Subject"
        static let messageBody = "Dear BikeRental Team,"
        static let recipient = "bikerental.georgia1@gmail.com"
    }
}

#Preview {
    HomeViewController()
}
