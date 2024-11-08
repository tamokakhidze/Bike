//
//  ScannerViewController.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 20.07.24.
//

import UIKit
import VisionKit

// MARK: - ScannerViewController

final class ScannerViewController: UIViewController {
    
    // MARK: - UI Components and Properties
    
    let scanButton = CustomButton(
        title: Titles.scannerButtonTitle,
        hasBackground: true,
        width: Sizing.buttonWidth
    )
    
    private var viewModel = ScannerViewModel()
    
    var scannerAvailable: Bool {
        DataScannerViewController.isSupported && DataScannerViewController.isAvailable
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addTargets()
        setDelegates()
    }
    
    // MARK: - UI Setup

    private func setupUI() {
        setupView()
        setupViewHierarchy()
        setConstraints()
    }
    
    private func setupView() {
        view.backgroundColor = .loginBackground
    }
    
    private func setupViewHierarchy() {
        view.addSubview(scanButton)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            scanButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scanButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - Add Targets
    private func addTargets() {
        scanButton.addTarget(self, action: #selector(scanButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Set Delegates
    
    private func setDelegates() {
        viewModel.delegate = self
    }
    
    // MARK: - Methods
    
    private func setupScanner() {
        let dataScanner = DataScannerViewController(
            recognizedDataTypes: [.barcode()],
            isHighlightingEnabled: true)
        dataScanner.delegate = self
        present(dataScanner, animated: true) {
            try? dataScanner.startScanning()
        }
    }
    
    // MARK: - Action methods
    
    @objc func scanButtonTapped() {
        if scannerAvailable {
            setupScanner()
        } else {
            let alert = UIAlertController(
                title: Titles.alertTitle,
                message: Titles.alertMessage,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
}

// MARK: - DataScannerViewControllerDelegate

extension ScannerViewController: DataScannerViewControllerDelegate {
    func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
        switch item {
        case .text(let text):
            print("\(text)")
        case .barcode(let barcode):
            guard let bikeId = barcode.payloadStringValue?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            DispatchQueue.main.async {
                self.viewModel.fetchBikes(bikeId: bikeId)
                print("Scanned bike ID: '\(bikeId)'")
            }
        default:
            print("Unknown item recognized")
        }
    }
}

// MARK: - ScannerViewModelDelegate

extension ScannerViewController: ScannerViewModelDelegate {
    func bikeFetched(bike: Bike) {
        let Vc = DetailsViewController(bike: bike)
        navigationController?.pushViewController(Vc, animated: true)
        self.dismiss(animated: true, completion: nil)
    }
}

extension ScannerViewController {
    enum Sizing {
        static let buttonWidth: CGFloat = 350
    }
    
    enum Titles {
        static let scannerButtonTitle = "Scan bike"
        static let alertTitle = "Scanner Not Available"
        static let alertMessage = "The data scanner is not supported or not available on this device."
    }
}
