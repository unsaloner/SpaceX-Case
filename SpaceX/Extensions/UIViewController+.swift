//
//  UIViewController+.swift
//  SpaceX
//
//  Created by Unsal Oner on 19.11.2023.
//

import UIKit

extension UIViewController {
    func setupNavigationBar(withTitle title: String) -> UINavigationBar {
        let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        navigationBar.tintColor = UIColor.white
        navigationBar.isTranslucent = false
        let navigationItem = UINavigationItem(title: title)
        navigationBar.items = [navigationItem]
        return navigationBar
    }
    func setupDetailImageView(withImageURL imageURL: URL?) -> UIImageView {
            let imageView = UIImageView()
            imageView.layer.cornerRadius = 12
            imageView.contentMode = .scaleAspectFit

            if let imageURL = imageURL {
                imageView.kf.setImage(with: imageURL, completionHandler: { result in
                    switch result {
                    case .success(let value):
                        print("Image downloaded successfully: \(value)")
                    case .failure(let error):
                        print("Image download failed: \(error)")
                    }
                })
            }
            return imageView
        }
    func setupDetailNameLabel(withText text: String?) -> UILabel {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.text = text
        return label
    }

    func createInfoLabel(withTitle title: String, value: String?) -> UILabel {
        let label = UILabel()
        label.text = "\(title)\n\n\(value ?? "-")"
        label.numberOfLines = 3
        label.textAlignment = .natural
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }

    func setupInfoStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.spacing = 16
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .leading
        stackView.layer.borderColor = UIColor.systemGray4.cgColor
        stackView.layer.borderWidth = 1
        stackView.layer.cornerRadius = 5
        return stackView
    }
    func setupYouTubeButton(withLink url: String?) -> UIButton {
            guard let socialURL = url,
                  !socialURL.isEmpty,
                  let youtubeURL = URL(string: "https://www.youtube.com/watch?v=\(socialURL)") else {
                
                return UIButton()
            }

            let button = UIButton(type: .custom)
            button.setImage(UIImage(named: "youtube_icon"), for: .normal)
            button.setTitle("YouTube", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.font = .boldSystemFont(ofSize: 14)
            button.addTarget(self, action: #selector(openURL(_:)), for: .touchUpInside)
            button.tag = 1
            button.layer.borderColor = UIColor.systemGray4.cgColor
            button.layer.borderWidth = 1
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
            button.accessibilityIdentifier = youtubeURL.absoluteString
            return button
        }

        func setupPressKitButton(withLink url: String?) -> UIButton {
            guard let presskitLink = url,
                  let presskitURL = URL(string: presskitLink) else {
                
                return UIButton()
            }
            let button = UIButton(type: .system)
            button.setImage(UIImage(named: "presskit_icon"), for: .normal)
            button.setTitle("Press Kit", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.font = .boldSystemFont(ofSize: 14)
            button.addTarget(self, action: #selector(openURL(_:)), for: .touchUpInside)
            button.tag = 2
            button.layer.borderColor = UIColor.systemGray4.cgColor
            button.layer.borderWidth = 1
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
            button.accessibilityIdentifier = presskitURL.absoluteString
            return button
        }

        @objc func openURL(_ sender: UIButton) {
            guard let urlString = sender.accessibilityIdentifier,
                  let url = URL(string: urlString) else {
                return
            }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }

    }

