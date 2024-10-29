//
//  AllBikesViewController.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 18.07.24.
//

import UIKit

// MARK: - AllBikesViewController

final class AllBikesViewController: UIViewController, HomeViewModelDelegate {
    
    func scrollToItem(at indexPath: IndexPath, animated: Bool) {}
    
    func updatePageControl(currentPage: Int) {}
    
    // MARK: - Ui components and properties
    
    private var titleLabel = CustomUiLabel(fontSize: 18, text: "All bikes", tintColor: .black, textAlignment: .center)
    
    private lazy var popularBikesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
        layout.itemSize = CGSize(width: 115, height: 160)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(BikeCollectionViewCell.self, forCellWithReuseIdentifier: BikeCollectionViewCell.identifier)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    private lazy var segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: ["Road", "Mountain", "Hybrid"])
        segmentControl.frame = .zero
        segmentControl.addTarget(self, action: #selector(segmentControlChanged), for: .valueChanged)
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.selectedSegmentTintColor = .black
        
        segmentControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        segmentControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        
        segmentControl.layer.borderWidth = 1
        segmentControl.layer.borderColor = UIColor.white.cgColor
        segmentControl.layer.cornerRadius = 50
        
        segmentControl.selectedSegmentIndex = 0
        return segmentControl
    }()
    
    private var viewModel = HomeViewModel()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setDelegates()
        
        viewModel.fetchData { [weak self] in
            DispatchQueue.main.async {
                self?.popularBikesCollectionView.reloadData()
            }
        }
    }
    
    // MARK: - Ui setup
    
    private func setupUI() {
        view.backgroundColor = .loginBackground
        
        view.addSubview(popularBikesCollectionView)
        view.addSubview(segmentControl)
        popularBikesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            segmentControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            segmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 70),
            segmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -70),
            segmentControl.heightAnchor.constraint(equalToConstant: 30),
            
            popularBikesCollectionView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 10),
            popularBikesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            popularBikesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            popularBikesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
        ])
        
    }
    
    // MARK: - Set delegates
    
    private func setDelegates() {
        popularBikesCollectionView.dataSource = self
        popularBikesCollectionView.delegate = self
        viewModel.delegate = self
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
