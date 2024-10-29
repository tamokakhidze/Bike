//
//  ScannerViewController.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 20.07.24.
//

import UIKit
import VisionKit

// MARK: - ScannerViewController

class ScannerViewController: UIViewController {
    
    // MARK: - Properties

    private var viewModel = ScannerViewModel()
    
    var scannerAvailable: Bool {
        DataScannerViewController.isSupported && DataScannerViewController.isAvailable
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.delegate = self
    }
    
    // MARK: - Ui setup

    func setupUI() {
        view.backgroundColor = .loginBackground
        let scanButton = CustomButton(title: "Scan bike", hasBackground: true, width: 350)
        scanButton.addTarget(self, action: #selector(scanButtonTapped), for: .touchUpInside)
        
        view.addSubview(scanButton)
        
        NSLayoutConstraint.activate([
            scanButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scanButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            scanButton.widthAnchor.constraint(equalToConstant: 350),
            scanButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Methods
    
    func setupScanner() {
        let dataScanner = DataScannerViewController(recognizedDataTypes: [.barcode()], isHighlightingEnabled: true)
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
            let alert = UIAlertController(title: "Scanner Not Available", 
                                          message: "The data scanner is not supported or not available on this device.",
                                          preferredStyle: .alert)
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


