//
//  ViewController.swift
//  SpaceX
//
//  Created by Unsal Oner on 18.11.2023.
//

import UIKit
import SnapKit
import Kingfisher

class CollectionViewCell: UICollectionViewCell {
    
    private(set) lazy var customImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private(set) lazy var nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .boldSystemFont(ofSize: 14)
        return lbl
    }()
    
    private(set) lazy var yearMonthDay: UILabel = {
       let lbl = UILabel()
        lbl.textColor = .systemGray2
        lbl.font = .systemFont(ofSize: 14)
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                setupUI()
                setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        ///Add Subviews
        addSubview(nameLabel)
        addSubview(customImageView)
        addSubview(yearMonthDay)
        
    }
    
    override func layoutSubviews() {

        layer.cornerRadius = 12
        layer.borderColor = UIColor.systemGray5.cgColor
        layer.borderWidth = 1.0
        customImageView.layer.cornerRadius = customImageView.bounds.width / 2

    }
    override func prepareForReuse() {
        super.prepareForReuse()
        customImageView.image = nil
    }

    
    private func setupConstraints(){
        
        customImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(12)
            make.height.width.equalTo(48)
            
        }
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(customImageView.snp.trailing).offset(18)
            make.centerY.equalToSuperview().offset(-12)
        }
        yearMonthDay.snp.makeConstraints { make in
            make.leading.equalTo(customImageView.snp.trailing).offset(18)
            make.top.equalTo(nameLabel.snp.bottom).offset(6)
        }
        
    }
    
    func configure(with launch: Launch) {
        if let imageURL = URL(string: launch.links.patch.small ?? "") {
            customImageView.kf.setImage(with: imageURL, completionHandler: { result in
                switch result {
                case .success(let value):
                    print("Image downloaded successfully: \(value)")
                case .failure(let error):
                    print("Image download failed: \(error)")
                }
            })
        } else {
            print("Image URL is nil or empty.")
        }

        nameLabel.text = launch.name
        yearMonthDay.text = launch.dateUTC
    }

    }
