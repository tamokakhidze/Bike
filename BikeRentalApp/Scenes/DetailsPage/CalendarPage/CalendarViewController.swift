//
//  CalendarViewController.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 10.07.24.
//

import UIKit
import FirebaseAuth
import PassKit
import ActivityKit

// MARK: - CalendarViewController

final class CalendarViewController: UIViewController {
    
    // MARK: - UI components and Properties
    
    private let dividers: [UIView] = {
        return (0..<3).map { _ in
            let divider = UIView()
            divider.translatesAutoresizingMaskIntoConstraints = false
            divider.backgroundColor = .input
            divider.layer.cornerRadius = Sizing.dividerCornerRadius
            return divider
        }
    }()
    
    private let startTimeView: UIDatePicker = {
        let datePickerView = UIDatePicker()
        datePickerView.preferredDatePickerStyle = .compact
        datePickerView.datePickerMode = .dateAndTime
        datePickerView.tintColor = .white
        datePickerView.backgroundColor = .darkBlue
        datePickerView.overrideUserInterfaceStyle = .dark
        datePickerView.locale = Locale(identifier: "ka-GE")
        datePickerView.layer.cornerRadius = Sizing.datePickerCornerRadius
        datePickerView.translatesAutoresizingMaskIntoConstraints = false
        return datePickerView
    }()
    
    private let endTimeView: UIDatePicker = {
        let datePickerView = UIDatePicker()
        datePickerView.preferredDatePickerStyle = .compact
        datePickerView.datePickerMode = .dateAndTime
        datePickerView.backgroundColor = .darkBlue
        datePickerView.overrideUserInterfaceStyle = .dark
        datePickerView.tintColor = .white
        datePickerView.locale = Locale(identifier: "ka-GE")
        datePickerView.layer.cornerRadius = Sizing.datePickerCornerRadius
        datePickerView.translatesAutoresizingMaskIntoConstraints = false
        return datePickerView
    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Sizing.stackViewSpacing
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let titleLabel = CustomUiLabel(
        fontSize: Sizing.titleFontSize,
        text: Titles.mainTitle,
        tintColor: .darkBlue,
        textAlignment: .center,
        fontWeight: .black
    )
    
    private let checkAvailabilityButton = CustomButton(
        title: Titles.checkAvailabilityButtonTitle,
        hasBackground: true,
        width: Sizing.buttonWidth
    )
    
    private let rentBikeButton = CustomButton(
        title: Titles.rentBikeButtonTitle,
        hasBackground: true,
        width: Sizing.buttonWidth
    )
    
    private var backgroundOne = CustomRectangleView(color: .darkBlue)
    
    private var viewModel = CalendarViewModel()
    
    var bike: Bike
    
    var isHelmetChosen: Bool
    
    var helmetPrice: Double
    
    private var isBikeAvailable: Bool = false {
        didSet {
            rentBikeButton.isEnabled = isBikeAvailable
        }
    }
    
    // MARK: - Lifecycle
    
    init(bike: Bike, isHelmetChosen: Bool, helmetPrice: Double) {
        self.bike = bike
        self.isHelmetChosen = isHelmetChosen
        self.helmetPrice = helmetPrice
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        view.backgroundColor = .white
        rentBikeButton.isEnabled = false
    }
    
    private func setupViewHierarchy() {
        view.addSubviews(backgroundOne, mainStackView)
        mainStackView.addArrangedSubviews(
            titleLabel,
            dividers[0],
            startTimeView,
            endTimeView,
            checkAvailabilityButton,
            rentBikeButton,
            UIView()
        )
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            backgroundOne.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Sizing.backgroundTopConstant),
            backgroundOne.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundOne.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundOne.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Sizing.mainStackViewTopConstant),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Sizing.mainStackViewLeadingConstant),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Sizing.mainStackViewTrailingConstant),
            mainStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor),
            
            dividers[0].widthAnchor.constraint(equalToConstant: Sizing.dividerWidth),
            dividers[0].heightAnchor.constraint(equalToConstant: Sizing.dividerHeight),
            
            startTimeView.widthAnchor.constraint(equalToConstant: Sizing.timeViewWidth),
            startTimeView.heightAnchor.constraint(equalToConstant: Sizing.timeViewHeight),
            
            endTimeView.widthAnchor.constraint(equalToConstant: Sizing.timeViewWidth),
            endTimeView.heightAnchor.constraint(equalToConstant: Sizing.timeViewHeight)
        ])
    }
    
    // MARK: - Add Targets
    
    private func addTargets() {
        startTimeView.addTarget(self, action: #selector(timeChanged), for: .valueChanged)
        endTimeView.addTarget(self, action: #selector(timeChanged), for: .valueChanged)
        checkAvailabilityButton.addTarget(self, action: #selector(checkAvailabilityButtonTapped), for: .touchUpInside)
        rentBikeButton.addTarget(self, action: #selector(rentBikeButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Set Delegates
    
    private func setDelegates() {
        viewModel.delegate = self
    }
    
    // MARK: - Actions
    
    @objc private func timeChanged() {
        print("Start time: \(startTimeView.date), End time: \(endTimeView.date)")
    }
    
    @objc private func checkAvailabilityButtonTapped() {
        print("Self bike on calebar view: \(self.bike)")
        viewModel.checkAvailability(for: bike, startTime: startTimeView.date, endTime: endTimeView.date)
    }
    
    @objc private func rentBikeButtonTapped() {
        guard isBikeAvailable else {
            AlertManager.showAlert(message: "Bike is not available", on: self, title: "Please check availability first")
            return
        }
        viewModel.rentBike(startTime: startTimeView.date, endTime: endTimeView.date, bike: bike, isHelmetChosen: isHelmetChosen)
    }
}

// MARK: - PKPaymentAuthorizationViewControllerDelegate

extension CalendarViewController: PKPaymentAuthorizationViewControllerDelegate {
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        if self.isBikeAvailable {
            let dateFormatter = ISO8601DateFormatter()
            let startTimeString = dateFormatter.string(from: self.startTimeView.date)
            let endTimeString = dateFormatter.string(from: self.endTimeView.date)
            
            let startTime = startTimeView.date
            let endTime = endTimeView.date
            let diffComponents = Calendar.current.dateComponents([.hour], from: startTime, to: endTime)
            guard let hours = diffComponents.hour else { return  }
            let totalPrice = bike.price * Double(hours)
            
            let bookingInfo: [String: Any] = [
                "startTime": startTimeString,
                "endTime": endTimeString,
                "bicycleID": self.bike.bicycleID,
                "userID": Auth.auth().currentUser?.uid ?? "",
                "totalPrice": String(format: "%.2f", totalPrice)
            ]
            
            let booking = Booking(dictionary: bookingInfo)
            
            // MARK: - Booking and adding live activity
            
            BikeService.shared.rentBike(with: booking) { success, error in
                if success {
                    print("Booking added successfully")
                    completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
                    self.navigationController?.pushViewController(SuccessViewController(), animated: false)
                    addLiveActivity()
                } else {
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                        completion(PKPaymentAuthorizationResult(status: .failure, errors: [error]))
                    } else {
                        print("Booking not available")
                        completion(PKPaymentAuthorizationResult(status: .failure, errors: nil))
                        AlertManager.showAlert(message: "Bike not available", on: self, title: "please choose other times")
                    }
                }
            }
            
            func addLiveActivity() {
                let bookingAttributes = BookingAttributes(bookingNumber: 234, bookingItems: isHelmetChosen ? "Bike and helmet" : "\(bike.geometry.capitalized) bike")
                
                let initialContentState = BookingAttributes.ContentState()
                
                do {
                    let activity = try Activity<BookingAttributes>.request(attributes: bookingAttributes, contentState: initialContentState)
                    print("Activity added successfully: \(activity.id)")
                }
                catch {
                    print("could not add live activity \(error.localizedDescription)")
                }
            }
        }
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

// MARK: - CalendarViewModelDelegate

extension CalendarViewController: CalendarViewModelDelegate {
    func showPaymentViewController(viewController: UIViewController, animated: Bool) {
        DispatchQueue.main.async {
            if let paymentVC = viewController as? PKPaymentAuthorizationViewController {
                paymentVC.delegate = self
            }
            self.present(viewController, animated: animated)
        }
    }
    
    func updateAvailability(isAvailable: Bool) {
        self.isBikeAvailable = isAvailable
    }
    
    func showAlert(message: String, title: String) {
        AlertManager.showAlert(message: message, on: self, title: title)
    }
}

// MARK: - Constants Extension

extension CalendarViewController {
    enum Sizing {
        static let dividerCornerRadius: CGFloat = 5
        static let datePickerCornerRadius: CGFloat = 15
        static let stackViewSpacing: CGFloat = 10
        static let buttonWidth: CGFloat = 350
        static let titleFontSize: CGFloat = 34
        static let backgroundTopConstant: CGFloat = 300
        static let mainStackViewTopConstant: CGFloat = 160
        static let mainStackViewLeadingConstant: CGFloat = 20
        static let mainStackViewTrailingConstant: CGFloat = -20
        static let dividerWidth: CGFloat = 300
        static let dividerHeight: CGFloat = 10
        static let timeViewWidth: CGFloat = 170
        static let timeViewHeight: CGFloat = 30
    }
    
    enum Titles {
        static let mainTitle = "Choose start and end times"
        static let checkAvailabilityButtonTitle = "Check Availability"
        static let rentBikeButtonTitle = "Rent Bike"
    }
}
