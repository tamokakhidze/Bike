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
    
    // MARK: - Ui components and properties

    private var scrollView = UIScrollView()
    private var contentView = UIView()
    private var mainStackView = CustomStackView(axis: .vertical, spacing: 20, alignment: .fill)
    private var headerStackView = CustomStackView(axis: .horizontal, spacing: 10, alignment: .center, distribution: .fillProportionally)
    private var popularsSegmentStackView = CustomStackView(axis: .horizontal, spacing: 10, alignment: .center, distribution: .equalSpacing)
    private var sliderCollectionView: Slider!
    
    private var nameLabel = CustomUiLabel(fontSize: 14, text: "", tintColor: .black, textAlignment: .left, fontWeight: .medium)
    private var titleLabel = CustomUiLabel(fontSize: 18, text: "Affordable bikes", tintColor: .black, textAlignment: .left)
    private var viewAllButton = CustomButton(title: "View All", width: 80)
    private var mainTitleLabel = CustomUiLabel(fontSize: 30, text: "Find your next bike", tintColor: .black, textAlignment: .left)
    private var fullMapButton = SmallCustomButton(width: 40, height: 40, backgroundImage: "fullMapIcon", backgroundColor: .white)
    private var scannerButton = SmallCustomButton(width: 50, height: 50, backgroundImage: "scanBikeIcon", backgroundColor: .white)
    
    private var bottomButtonsStackView = CustomStackView(axis: .horizontal, spacing: 0, alignment: .center, distribution: .equalSpacing)

    private var customBackgroundView = CustomRectangleView(color: .white)
    private var shareButton = SmallCustomButton(width: 40, height: 40, backgroundImage: "reminderImage", backgroundColor: .white)
    private var emailButton = SmallCustomButton(width: 40, height: 40, backgroundImage: "emailImage", backgroundColor: .white)
    private var messageButton = SmallCustomButton(width: 40, height: 40, backgroundImage: "messageImage", backgroundColor: .white)

    
    private lazy var popularBikesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: 140, height: 181)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(BikeCollectionViewCell.self, forCellWithReuseIdentifier: BikeCollectionViewCell.identifier)
        collectionView.tag = 1
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = viewModel.salesImagesArray.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = .gray
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
        
        viewModel.fetchData { [weak self] in
            DispatchQueue.main.async {
                self?.popularBikesCollectionView.reloadData()
            }
        }
        
        AuthService.shared.getUser { [weak self] user, error in
            guard let self = self else { return }
            if let user = user {
                self.nameLabel.text = "Hello, \(user.username)"
            }
        }
        
    }
    
    // MARK: - Ui setup

    private func setupUI() {
        view.backgroundColor = .loginBackground
        
        sliderCollectionView = Slider(
            itemWidth: 350,
            cell: SliderCollectionViewCell.self,
            identifier: SliderCollectionViewCell.identifier,
            tag: 2)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(customBackgroundView)
        contentView.sendSubviewToBack(customBackgroundView)
        scrollView.showsVerticalScrollIndicator = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        configureStackViews()
    }
    
    private func configureStackViews() {
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
        setConstraints()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            
            headerStackView.heightAnchor.constraint(equalToConstant: 50),
            nameLabel.leadingAnchor.constraint(equalTo: scannerButton.trailingAnchor, constant: 80),
            
            customBackgroundView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            customBackgroundView.heightAnchor.constraint(equalToConstant: 1000),
            customBackgroundView.topAnchor.constraint(equalTo: mainStackView.topAnchor, constant: 150),
            
            sliderCollectionView.heightAnchor.constraint(equalToConstant: 200),
            sliderCollectionView.topAnchor.constraint(equalTo: customBackgroundView.topAnchor, constant: 50),
            
            popularBikesCollectionView.heightAnchor.constraint(equalToConstant: 180)
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
        let textToShare = "Check out this amazing bike rental app!"
        let urlToShare = URL(string: "https://github.com/tamokakhidze/BikeRentalApp")
        let imageToShare = UIImage(named: "logoImage")
        
        let activityItems: [Any] = [textToShare, urlToShare, imageToShare].compactMap { $0 }
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
            mailComposer.setSubject("Subject")
            mailComposer.setMessageBody("Dear BikeRental Team,", isHTML: false)
            mailComposer.setToRecipients(["bikerental.georgia1@gmail.com"])
            present(mailComposer, animated: true, completion: nil)
        } else {
            print("can not show mail composer")
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


#Preview {
    HomeViewController()
}
