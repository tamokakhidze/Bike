//
//  AllBikesViewController.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 18.07.24.
//

import UIKit

// MARK: - AllBikesViewController

final class AllBikesViewController: UIViewController {
    
    // MARK: - UI Components and Properties
    
    private var titleLabel = CustomUiLabel(
        fontSize: titleLabelFontSize,
        text: Titles.allBikes,
        tintColor: .primaryText,
        textAlignment: .center
    )
    
    private lazy var popularBikesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = Sizing.collectionViewLineSpacing
        layout.minimumInteritemSpacing = Sizing.collectionViewInteritemSpacing
        layout.itemSize = Sizing.popularBikesItemSize
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(BikeCollectionViewCell.self,
                                forCellWithReuseIdentifier: BikeCollectionViewCell.identifier)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: Titles.segmentItems)
        segmentControl.frame = .zero
        segmentControl.addTarget(self, action: #selector(segmentControlChanged), for: .valueChanged)
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.selectedSegmentTintColor = Colors.segmentSelectedTintColor
        segmentControl.setTitleTextAttributes([.foregroundColor: Colors.segmentTitleTextColor], for: .normal)
        segmentControl.setTitleTextAttributes([.foregroundColor: Colors.segmentTitleTextColor], for: .selected)
        segmentControl.layer.borderWidth = Sizing.segmentControlBorder
        segmentControl.layer.borderColor = Colors.segmentBorderColor
        segmentControl.layer.cornerRadius = Sizing.segmentControlCornerRadius
        segmentControl.selectedSegmentIndex = .zero
        return segmentControl
    }()
    
    private var viewModel = HomeViewModel()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setDelegates()
        fetchData()
    }
    
    // MARK: - Fetching
    
    private func fetchData() {
        viewModel.fetchData { [weak self] in
            DispatchQueue.main.async {
                self?.popularBikesCollectionView.reloadData()
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
        view.addSubview(popularBikesCollectionView)
        view.addSubview(segmentControl)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            segmentControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Sizing.segmentControlTopPadding),
            segmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Sizing.segmentControlLeadingTrailingPadding),
            segmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Sizing.segmentControlLeadingTrailingPadding),
            segmentControl.heightAnchor.constraint(equalToConstant: Sizing.segmentControlHeight),
            
            popularBikesCollectionView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: Sizing.popularBikesCollectionViewTopPadding),
            popularBikesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Sizing.popularBikesCollectionViewSidePadding),
            popularBikesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Sizing.popularBikesCollectionViewSidePadding),
            popularBikesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Set delegates
    
    private func setDelegates() {
        popularBikesCollectionView.dataSource = self
        popularBikesCollectionView.delegate = self
    }
    
    // MARK: - Actions
    
    @objc private func segmentControlChanged() {
        let selectedGeometry: String
        switch segmentControl.selectedSegmentIndex {
        case 0:
            selectedGeometry = "road"
        case 1:
            selectedGeometry = "mountain"
        case 2:
            selectedGeometry = "hybrid"
        default:
            selectedGeometry = "road"
        }
        
        viewModel.getBikesByGeometryType(geometry: selectedGeometry)
        popularBikesCollectionView.reloadData()
    }
    
}

// MARK: - CollectionView datasource and delegate

extension AllBikesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let bikesArray = viewModel.filteredBikes
        guard let customCell = collectionView.dequeueReusableCell(withReuseIdentifier: BikeCollectionViewCell.identifier, for: indexPath) as? BikeCollectionViewCell else {
            return UICollectionViewCell()
        }
        customCell.configureBikeCell(image: bikesArray[indexPath.row].image, price: bikesArray[indexPath.row].price)
        return customCell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.filteredBikes.count
    }
}

extension AllBikesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailsViewController(bike: viewModel.filteredBikes[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension AllBikesViewController {
    enum Colors {
        static let segmentSelectedTintColor = UIColor.black
        static let segmentTitleTextColor = UIColor.white
        static let segmentBorderColor = UIColor.white.cgColor
    }
    
    enum Sizing {
        static let titleLabelFontSize: CGFloat = 18
        static let segmentControlTopPadding: CGFloat = 10
        static let segmentControlLeadingTrailingPadding: CGFloat = 70
        static let segmentControlHeight: CGFloat = 30
        static let segmentControlBorder: CGFloat = 1
        static let segmentControlCornerRadius: CGFloat = 50
        static let popularBikesCollectionViewTopPadding: CGFloat = 10
        static let popularBikesCollectionViewSidePadding: CGFloat = 10
        static let popularBikesItemSize = CGSize(width: 115, height: 160)
        static let collectionViewLineSpacing: CGFloat = 4
        static let collectionViewInteritemSpacing: CGFloat = 4
    }
    
    enum Titles {
        static let allBikes = "All bikes"
        static let segmentItems = ["Road", "Mountain", "Hybrid"]
    }
}
