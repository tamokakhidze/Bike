//
//  SliderPopUpViewController.swift
//  FirebaseLoginPage
//
//  Created by Tamuna Kakhidze on 07.07.24.
//

import UIKit

// MARK: - SliderPopUpViewController (not using for details page anymore but keeping it here)

final class SliderPopUpViewController: UIViewController {
    
    // MARK: - Ui components and properties

    private var stackView = UIStackView()
    private var sliderCollectionView: UICollectionView!
    private var pageControl = UIPageControl()
    var currentIndex = 0
    var timer: Timer?
    var bike: Bike
    
    // MARK: - Lifecycle

    init(bike: Bike) {
        self.bike = bike
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startTimer()
        setupUI()
        setDelegates()
        pageControl.addTarget(self, action: #selector(pageControlChanged(_:)), for: .valueChanged)
    }
    
    // MARK: - Ui setup

    private func setupUI() {
        view.backgroundColor = .white
        
        configureSlider()
        
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(sliderCollectionView)
        stackView.addArrangedSubview(pageControl)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            sliderCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8)
        ])
        
        pageControl.numberOfPages = bike.detailedImages.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .gray
        pageControl.pageIndicatorTintColor = .lightGray
    }
    
    // MARK: - Delegates

    private func setDelegates() {
        sliderCollectionView.dataSource = self
    }
    
    
    // MARK: - Actions

    private func configureSlider() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let itemWidth: CGFloat = view.frame.width
        let itemHeight: CGFloat = view.bounds.height
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        sliderCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        sliderCollectionView.register(SliderCollectionViewCell.self, forCellWithReuseIdentifier: SliderCollectionViewCell.identifier)
        sliderCollectionView.isPagingEnabled = true
        sliderCollectionView.showsHorizontalScrollIndicator = false
        sliderCollectionView.backgroundColor = .clear
        sliderCollectionView.translatesAutoresizingMaskIntoConstraints = false
    }

    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 3.5, target: self, selector: #selector(automateSlider), userInfo: nil, repeats: true)
    }
    
    @objc func automateSlider() {
        let nextPage = currentIndex + 1
        let positionToScroll: IndexPath
        
        if nextPage < bike.detailedImages.count {
            positionToScroll = IndexPath(item: nextPage, section: 0)
        } else {
            positionToScroll = IndexPath(item: 0, section: 0)
        }
        
        sliderCollectionView.scrollToItem(at: positionToScroll, at: .centeredHorizontally, animated: true)
        currentIndex = positionToScroll.item
        
        pageControl.currentPage = currentIndex
    }
    
    @objc func pageControlChanged(_ sender: UIPageControl) {
        let selectedPage = sender.currentPage
        let positionToScroll = IndexPath(item: selectedPage, section: 0)
        
        sliderCollectionView.scrollToItem(at: positionToScroll, at: .centeredHorizontally, animated: true)
        currentIndex = selectedPage
    }
    
}

// MARK: - UICollectionViewDataSource

extension SliderPopUpViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let customCell = collectionView.dequeueReusableCell(withReuseIdentifier: SliderCollectionViewCell.identifier, for: indexPath) as? SliderCollectionViewCell else {
            return UICollectionViewCell()
        }
        customCell.configureSliderCell(imageURL: bike.detailedImages[indexPath.row], text: "", subtext: "")
        return customCell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bike.detailedImages.count
    }
}
