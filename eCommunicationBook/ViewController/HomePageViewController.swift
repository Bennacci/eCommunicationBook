//
//  LobbuViewController.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/17.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  private let itemsPerRow: CGFloat = 3

  private let itemsPerColumn: CGFloat = 2

  private let collectionViewSectionInsets = UIEdgeInsets(
    top: 10.0,
    left: 20.0,
    bottom: 10.0,
    right: 20.0)
  
  override func viewDidLoad() {
    tableView.registerCellWithNib(identifier: ServicesTableViewCell.identifier, bundle: nil)
    tableView.registerCellWithNib(identifier: BannerTableViewCell.identifier, bundle: nil)

    super.viewDidLoad()
  }
}

extension HomePageViewController: UITableViewDataSource, UIScrollViewDelegate {
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.row == 0 {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: BannerTableViewCell.identifier,
                                                   for: indexPath) as? BannerTableViewCell
      else { fatalError("Unexpected Table View Cell") }
      
      cell.setBannerView()
      
      cell.bannerView.scrollView.delegate = self
//    cell.collectionView.delegate = self
//    cell.collectionView.dataSource = self
    //    cell.layoutCell(title: viewModel.services[indexPath.section][indexPath.row])
    return cell
    
    } else {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: ServicesTableViewCell.identifier,
                                                   for: indexPath) as? ServicesTableViewCell
      else { fatalError("Unexpected Table View Cell") }
    cell.height.constant = 170
    cell.collectionView.delegate = self
    cell.collectionView.dataSource = self
    //    cell.layoutCell(title: viewModel.services[indexPath.section][indexPath.row])
    return cell
  }
  }
}






extension HomePageViewController: UITableViewDelegate {
  
}

extension HomePageViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    5
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ServiceCollectionViewCell.identifier,
                                                        for: indexPath) as? ServiceCollectionViewCell
      else { fatalError("Unexpected Table View Cell") }
    //    cell.layoutCell(title: viewModel.services[indexPath.section][indexPath.row])
    return cell
  }
  
}

extension HomePageViewController: UICollectionViewDelegate {
  
}
// MARK: - 設定 CollectionView Cell 與 Cell 之間的間距、距確 Super View 的距離等等
extension HomePageViewController: UICollectionViewDelegateFlowLayout {
  
  ///  Collection View distance to Super View
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    return collectionViewSectionInsets
  }
  
  /// CollectionViewCell  height / width
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let size = collectionView.calculateCellsize(view: view,
                                                sectionInsets: collectionViewSectionInsets,
                                                itemsPerRow: itemsPerRow,
                                                itemsPerColumn: itemsPerColumn)
    return size
  }
  
  /// 滑動方向為「垂直」的話即「上下」的間距(預設為重直)

  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 8
  }
  
  /// 滑動方向為「垂直」的話即「左右」的間距(預設為重直)

  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 8
  }
}
//
//
// extension LobbyViewController {
//
//  func setupTimer() {
//    lobbyBannerView.timer = Timer.scheduledTimer(timeInterval: 2,
//                                                   target: self,
//                                                   selector: #selector(timeChanged),
//                                                   userInfo: nil,
//                                                   repeats: true)
//      RunLoop.current.add(lobbyBannerView.timer, forMode: RunLoop.Mode.common)
//  }
//  /**
//   * time 事件
//   */
//  @objc func timeChanged() {
//    lobbyBannerView.currentIndex += 1
//// 更新圖片+scrollView
//    lobbyBannerView.reloadImage()
//  }
//
//  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//    lobbyBannerView.timer.invalidate()
//  }
//
//  /**
//   * scrollView 滑動坄停止監聽
//   */
//  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//    let imageCount = lobbyBannerView.imageArray.count
//
//    if imageCount > 0 {
//    // 向右拖動
//    if lobbyBannerView.scrollView.contentOffset.x > lobbyBannerView.width {
//      lobbyBannerView.currentIndex = (lobbyBannerView.currentIndex + 1) % imageCount
//      }
//
//      // 向左拖動
//    if lobbyBannerView.scrollView.contentOffset.x < lobbyBannerView.width {
//      lobbyBannerView.currentIndex = (lobbyBannerView.currentIndex - 1 + imageCount) % imageCount
//      }
//
//      // 更新小圓點當前位置
//    lobbyBannerView.pageControl.currentPage = (lobbyBannerView.currentIndex - 1 + imageCount) % imageCount
//    lobbyBannerView.reloadImage()
//    }
//      setupTimer()
//  }
//
//  func setBannerView() {
//    for data in 0 ..< bannerImageData.count {
//      lobbyBannerView.imageArray.append(bannerImageData[data].picture)
//      lobbyBannerView.sloganArray.append(bannerImageData[data].story)
//    }
//    self.view.addSubview(self.lobbyBannerView.scrollView)
//    self.view.addSubview(self.lobbyBannerView.pageControl)
//    self.view.addSubview(self.lobbyBannerView.closeBanner)
//    setupTimer()
//    setButtonFunc()
//  }
//
//  @objc func hideBanner(_ sender: UIButton) {
//    UIView.animate(withDuration: 0.6, animations: {
//      self.lobbyBannerHeight.constant = 0
//      self.lobbyBannerView.scrollView.isHidden = true
//      self.lobbyBannerView.pageControl.isHidden = true
//      self.lobbyBannerView.closeBanner.isHidden = true
//      self.view.layoutIfNeeded()
//    })
//  }
//
//  func setButtonFunc() {
//    self.lobbyBannerView.closeBanner.addTarget(self, action: #selector(hideBanner(_:)), for: .touchUpInside)
//  }
// }
