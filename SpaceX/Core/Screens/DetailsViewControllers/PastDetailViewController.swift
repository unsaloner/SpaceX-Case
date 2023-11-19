//
//  PastDetailViewController.swift
//  SpaceX
//
//  Created by Unsal Oner on 19.11.2023.
//

import UIKit
import SnapKit


class PastDetailViewController: UIViewController {
    // MARK: Variables

    private lazy var navigationBar: UINavigationBar = {
        return setupNavigationBar(withTitle: "Past Launch")
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
    private lazy var dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Launch Date: \(launch?.dateUTC ?? "")"
        lbl.textColor = UIColor.systemGray2
        lbl.font = .systemFont(ofSize: 14)
        return lbl
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
        view.addSubview(dateLabel)
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
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(detailImageView.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(24)
        }
        
        infoStackView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-24)
            make.leading.equalToSuperview().offset(24)
            make.top.equalTo(dateLabel.snp.bottom).offset(24)
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
}



