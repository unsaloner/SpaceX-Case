//
//  ViewController.swift
//  SpaceXApp
//
//  Created by Unsal Oner on 17.11.2023.
//

import UIKit
import SnapKit
import BetterSegmentedControl

final class ViewController: UIViewController {
    
// MARK: Variables
    
    private let launchViewModel = LaunchViewModel()
    
    private lazy var navigationBar : UINavigationBar = {
        return setupNavigationBar(withTitle: "Launches")
    }()
    
    private lazy var segmentedControl: BetterSegmentedControl = {
        let options: [BetterSegmentedControl.Option] = [
            .backgroundColor(.systemGray5),
            .indicatorViewBackgroundColor(.white),
            .cornerRadius(10.0),
            .animationSpringDamping(1.0),
            .indicatorViewInset(2),
            .indicatorViewBorderWidth(1),
            .indicatorViewBorderColor(.white)
        ]

        let segments = LabelSegment.segments(
            withTitles: ["Upcoming", "Past"],
            numberOfLines: 1,
            normalBackgroundColor: .clear,
            normalFont: .systemFont(ofSize: 14),
            normalTextColor: .black,
            selectedBackgroundColor: .clear,
            selectedFont: .boldSystemFont(ofSize: 14),
            selectedTextColor: .black
        )
        let segmentedControl = BetterSegmentedControl(
            frame: CGRect(x: 0, y: 0, width: 164, height: 42),
            segments: segments, index: 0,
            options: options
        )

        segmentedControl.addTarget(self, action: #selector(segmentControlChanged(_:)), for: .valueChanged)

        return segmentedControl
    }()
    
    private lazy var collectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        viewLayout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        viewLayout.itemSize = CGSize(width: view.bounds.width - 72, height: 60)
        
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: viewLayout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        
        setupUI()
        setupConstraints()

        fetchLaunches()
    }
    
    private func setupUI() {
        /// Add Subviews
       view.addSubview(segmentedControl)
       view.addSubview(navigationBar)
       view.addSubview(collectionView)
        
 
    }
    @objc func segmentControlChanged(_ sender: BetterSegmentedControl) {
        switch sender.index {
            case 0:
                launchViewModel.fetchUpcomingLaunches { result in
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            case 1:
                launchViewModel.fetchPastLaunches { result in
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            default:
                break
            }
        
    }
//    MARK: Layouts
    
    private func setupConstraints(){
        
        let screenWidth = UIScreen.main.bounds.width
        
        navigationBar.snp.makeConstraints { make in
          make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(-42)
          make.leading.equalToSuperview().offset(36)
          make.trailing.equalToSuperview().offset(-36)
          make.height.equalTo(40)
        }
        
        segmentedControl.snp.makeConstraints { make in
          make.top.equalTo(navigationBar.snp.bottom).offset(36)
          make.trailing.equalTo(-24)
          make.leading.equalTo(24)
        }
        collectionView.snp.makeConstraints { make in
          make.top.equalTo(segmentedControl.snp.bottom).offset(24)
          make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
          make.left.equalToSuperview().offset(
                        screenWidth > 420 ? 48 : screenWidth > 380 ? 36 : 0
                      )
                     make.right.equalToSuperview().offset(
                        screenWidth > 420 ? -48 : screenWidth > 380 ? -36 : 0
                      )
        }
    }
    private func fetchLaunches() {
            launchViewModel.fetchUpcomingLaunches { result in
                switch result {
                case .success(_):
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                case .failure(let error):
                    print("Error fetching launches: \(error)")
                }
            }
        }
}

//MARK: Extensions
extension ViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let isUpcoming = segmentedControl.index == 0
            
        return isUpcoming ? launchViewModel.numberOfUpcomingLaunches() : launchViewModel.numberOfPastLaunches()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        let isUpcoming = segmentedControl.index == 0
        let launch = launchViewModel.getLaunch(at: indexPath.item, isUpcoming: isUpcoming)

        cell.configure(with: launch)
       
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if segmentedControl.index == 0 {
            let detailVC = UpcomingDetailViewController()
            detailVC.setLaunch(launchViewModel.upcomingLaunches[indexPath.row])
            navigationController?.pushViewController(detailVC, animated: true)
            
        }else {
            let detailVC = PastDetailViewController()
            detailVC.setLaunch(launchViewModel.pastLaunches[indexPath.row])
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }

}


