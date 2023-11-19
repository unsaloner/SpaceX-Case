//
//  UpcomingDetailViewController.swift
//  SpaceX
//
//  Created by Unsal Oner on 18.11.2023.
//

import UIKit
import SnapKit


class UpcomingDetailViewController: UIViewController {
    
    // MARK: Variables

    private lazy var navigationBar: UINavigationBar = {
        return setupNavigationBar(withTitle: "Upcoming Launch")
    }()

    private lazy var detailImageView: UIImageView = {
        return setupDetailImageView(withImageURL:URL(string:launch?.links.patch.small ?? ""))
    }()

    private lazy var detailNameLabel: UILabel = {
        return setupDetailNameLabel(withText: launch?.name)
    }()
    private lazy var youtubeButton: UIButton = {
        let button = self.setupYouTubeButton(withLink: launch?.links.youtubeID)
        return button
    }()

    private lazy var pressKitButton: UIButton = {
        let button = self.setupPressKitButton(withLink: launch?.links.presskit)
        return button
    }()

    
    private lazy var dateStackView: UIStackView = {
        let stackView = UIStackView()
            stackView.layer.cornerRadius = 12
            stackView.backgroundColor = .black
            stackView.spacing = 16
            stackView.axis = .horizontal
            stackView.distribution = .fill
            stackView.alignment = .center
     return stackView
    }()
    private lazy var dateLabel: UILabel = {
        let lbl = UILabel()
            lbl.numberOfLines = 4
            lbl.textColor = .white
        if let launchDate = launch?.dateUTC {
            let labelText = "LAUNCH DATE\n\(launchDate)"
            let attributedText = NSMutableAttributedString(string: labelText)
            
            attributedText.addAttribute(
                .font,
                value: UIFont.systemFont(ofSize: 12, weight: .bold),
                range: (labelText as NSString).range(of: "LAUNCH DATE")
            )

            attributedText.addAttribute(
                .font,
                value: UIFont.systemFont(ofSize: 8),
                range: (labelText as NSString).range(of: launchDate)
            )
            
            lbl.attributedText = attributedText
        }
            else {
                lbl.text = "LAUNCH DATE\n\nTarih bilgisi yok"
            }
     return lbl
    }()
    
    private lazy var countDownLabel: UILabel = {
        let label = UILabel()
            label.textColor = .white
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 20,weight: .bold)
     return label
    }()
    private lazy var infoStackView: UIStackView = {
     return setupInfoStackView()
    }()
    private lazy var infoStackView2: UIStackView = {
     return setupInfoStackView()
    }()
    private lazy var infoStackView3: UIStackView = {
     return setupInfoStackView()
    }()
    private(set) var countdownTimer: Timer?
    private var launch: Launch?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    private func setupUI(){
        /// Add Subviews
        view.addSubview(navigationBar)
        view.addSubview(detailImageView)
        view.addSubview(detailNameLabel)
        view.addSubview(dateStackView)
        view.addSubview(infoStackView)
        view.addSubview(infoStackView2)
        view.addSubview(infoStackView3)
        view.addSubview(youtubeButton)
        view.addSubview(pressKitButton)
        
        infoStackView.addArrangedSubview(createInfoLabel(withTitle: "Landing Attempt", value: launch?.cores.first?.landingAttempt?.description ?? "-"))
        infoStackView.addArrangedSubview(createInfoLabel(withTitle: "Landing Success", value: launch?.cores.first?.landingSuccess?.description ?? "-"))

        infoStackView2.addArrangedSubview(createInfoLabel(withTitle: "Landing Type", value: launch?.cores.first?.landingType ?? "-"))
        infoStackView2.addArrangedSubview(createInfoLabel(withTitle: "Flight Number", value: launch?.flightNumber?.description ?? "-"))

        infoStackView3.addArrangedSubview(createInfoLabel(withTitle: "Upcoming", value: launch?.upcoming.description ?? "-"))
        infoStackView3.addArrangedSubview(createInfoLabel(withTitle: "Date Precision", value: launch?.datePrecision.rawValue ?? "-"))

        dateStackView.addArrangedSubview(dateLabel)
        dateStackView.addArrangedSubview(countDownLabel)
        
        startCountdownTimer()
        updateUIWithRemainingTime()
        
        view.backgroundColor = .systemBackground
    }
     func setLaunch(_ launch: Launch) {
            self.launch = launch
        }
    
    private func setupConstraints(){
        /// Add Constraints

        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(-42)
          make.leading.equalToSuperview().offset(36)
          make.trailing.equalToSuperview().offset(-36)
          make.height.equalTo(40)
        }
        
        detailImageView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(24)
            make.width.height.equalTo(60)
        }
        
        detailNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(detailImageView.snp.centerY)
            make.leading.equalTo(detailImageView.snp.trailing).offset(12)
            
        }
        
        dateStackView.snp.makeConstraints { make in
            make.top.equalTo(detailImageView.snp.bottom).offset(16)
            make.trailing.equalToSuperview().offset(-24)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(72)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(dateStackView.snp.leading).offset(12)
        }
        
        infoStackView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-24)
            make.leading.equalToSuperview().offset(24)
            make.top.equalTo(dateStackView.snp.bottom).offset(24)
            make.height.equalTo(120)
        }
        infoStackView2.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-24)
            make.leading.equalToSuperview().offset(24)
            make.top.equalTo(infoStackView.snp.bottom)
            make.height.equalTo(120)
        }
        infoStackView3.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-24)
            make.leading.equalToSuperview().offset(24)
            make.top.equalTo(infoStackView2.snp.bottom)
            make.height.equalTo(120)
        }
        youtubeButton.snp.makeConstraints { make in
            make.top.equalTo(infoStackView3.snp.bottom).offset(16)
            make.trailing.equalToSuperview().offset(-24)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(60)
        }
        pressKitButton.snp.makeConstraints { make in
            make.top.equalTo(youtubeButton.snp.bottom).offset(16)
            make.trailing.equalToSuperview().offset(-24)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(60)
        }
    }
    private func startCountdownTimer() {
        guard let launchDate = launch?.dateUTC else { return }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        if let launchDate = dateFormatter.date(from: launchDate.description) {
            let remainingTime = launchDate.timeIntervalSinceNow
            
            if remainingTime > 0 {
                countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
                    guard let self = self else { return }
                    
                    // UI updae
                    self.updateUIWithRemainingTime()
                }
            } else {
            }
        }
    }
    private func updateUIWithRemainingTime() {
        guard let launchDateString = launch?.dateUTC else { return }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        guard let launchDate = dateFormatter.date(from: launchDateString.description) else { return }
            
        let remainingTime = launchDate.timeIntervalSinceNow
        let hours = Int(remainingTime) / 3600
        let minutes = (Int(remainingTime) % 3600) / 60
        let seconds = Int(remainingTime) % 60

        countDownLabel.text = String(format: "%02d : %02d : %02d", hours, minutes, seconds)

        
    }
}


