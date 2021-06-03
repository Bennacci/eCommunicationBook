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
  
  //  private let itemsPerRow: CGFloat = 3
  //
  //  private let itemsPerColumn: CGFloat = 2
  
  var bannerCell = BannerTableViewCell()
  
  var hotCell = ServicesTableViewCell()
  
  var viewModel = HomePageViewModel()
  
  var hotCellHeight: CGFloat = UIScreen.height / 7
  
  var recommendedCellHeight: CGFloat = UIScreen.height / 5
  
  private let collectionViewSectionInsets = UIEdgeInsets(
    top: 10.0,
    left: 20.0,
    bottom: 10.0,
    right: 20.0)
  
  override func viewDidLoad() {
    
    self.navigationController?.setNavigationBarHidden(true, animated: true)
    
    tableView.registerCellWithNib(identifier: ServicesTableViewCell.identifier, bundle: nil)
    
    tableView.registerCellWithNib(identifier: BannerTableViewCell.identifier, bundle: nil)
    
    tableView.registerCellWithNib(identifier: NewsTableViewCell.identifier, bundle: nil)
    
    super.viewDidLoad()
  }
}

extension HomePageViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 4
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
    case 0:
      return ""
    case 1:
      return "Popular features"
    case 2:
      return "Recommanded for you"
    default:
      return "New events"
    }
  }
  
  func tableView(_ tableView: UITableView,
                 
                 numberOfRowsInSection section: Int) -> Int {
    
    return [1, 1, 1, 5][section]
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath == [0, 0] {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: BannerTableViewCell.identifier,
                                                     for: indexPath) as? BannerTableViewCell
        else { fatalError("Unexpected Table View Cell") }
      
      bannerCell = cell
      
      cell.setBannerView()
      
      cell.bannerView.scrollView.delegate = self
      
      return cell
      
    } else if indexPath == [1, 0] || indexPath == [2, 0] {
      
      guard let cell = tableView.dequeueReusableCell(withIdentifier: ServicesTableViewCell.identifier,
                                                     for: indexPath) as? ServicesTableViewCell
        else { fatalError("Unexpected Table View Cell") }
      
      cell.collectionView.delegate = self
      
      cell.collectionView.dataSource = self
            
      if indexPath == [1, 0] {
        
        hotCell = cell
        
        cell.height.constant = hotCellHeight
        
      } else {
        
        cell.height.constant = recommendedCellHeight
        
      }
      
      return cell
    } else {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier,
                                                     for: indexPath) as? NewsTableViewCell
        else { fatalError("Unexpected Table View Cell") }
      return cell
    }
  }
}

extension HomePageViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))

      headerView.backgroundColor = UIColor.clear
      let myLabel = UILabel()
      myLabel.frame = CGRect(x: 16, y: headerView.frame.height / 3, width: tableView.bounds.size.width, height: 30)
      myLabel.font = UIFont.boldSystemFont(ofSize: 18)
      myLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
    headerView.addSubview(myLabel)
    return headerView
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if section == 0 {
      
      return CGFloat.leastNormalMagnitude
      
    } else {
      
      return 35
    }
  }
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    
    return CGFloat.leastNormalMagnitude
  }
}

extension HomePageViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    if collectionView == hotCell.collectionView {
      
      return viewModel.servicesData().items[0].count
      
    } else {
      
      return viewModel.servicesData().items[1].count + viewModel.servicesData().items[2].count
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ServiceCollectionViewCell.identifier,
                                                        for: indexPath) as? ServiceCollectionViewCell
      else { fatalError("Unexpected Table View Cell") }
    if collectionView == hotCell.collectionView {
      cell.height.constant = hotCell.bounds.size.height
      cell.setUp(viewModel: viewModel.servicesData(), indexPath: indexPath, hot: true)

    } else {
    cell.setUp(viewModel: viewModel.servicesData(), indexPath: indexPath, hot: false)
    }
    return cell
  }
  
}

extension HomePageViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if collectionView == hotCell.collectionView {
      let title = viewModel.servicesData().items[0][indexPath.item].title
      
      switch title {
      case "Communication Book":
        if let nextVC = UIStoryboard.lessonPlan.instantiateInitialViewController() {
          
          nextVC.modalPresentationStyle = .fullScreen
          self.navigationController?.show(nextVC, sender: nil)
          
        } else { return }
      case "Student Time In / Out":
        if let nextVC = UIStoryboard.scanStudentQR.instantiateInitialViewController() {
          
          nextVC.modalPresentationStyle = .fullScreen
          
          self.navigationController?.show(nextVC, sender: nil)
          
        } else { return }
      case "Where's my children":
        if let nextVC = UIStoryboard.studentTimeInAndOut.instantiateInitialViewController() {
          
          nextVC.modalPresentationStyle = .fullScreen
          
          self.navigationController?.show(nextVC, sender: nil)
          
        } else { return }
        
      default:
        return
      }
    
    }
    

  }
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
    let size: CGSize
    if collectionView == hotCell.collectionView {
      size = collectionView.calculateCellsize(viewHeight: hotCellHeight,
                                              sectionInsets: collectionViewSectionInsets,
                                              itemsPerRow: 2,
                                              itemsPerColumn: 1)
    } else {
      size = collectionView.calculateCellsize(viewHeight: recommendedCellHeight,
                                              sectionInsets: collectionViewSectionInsets,
                                              itemsPerRow: 3,
                                              itemsPerColumn: 2)
    }
    
    return size
  }
  
  /// 滑動方向為「垂直」的話即「上下」的間距(預設為重直)
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    if collectionView == hotCell.collectionView {
      return 15
    } else {
      return 12
    }
  }
  
  /// 滑動方向為「垂直」的話即「左右」的間距(預設為重直)
  
//  func collectionView(_ collectionView: UICollectionView,
//                      layout collectionViewLayout: UICollectionViewLayout,
//                      minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//    return 8
//  }
}

extension HomePageViewController: UIScrollViewDelegate {
  
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    
    //    guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? BannerTableViewCell
    //
    //      else { fatalError("Unexpected Table View Cell") }
    
    bannerCell.bannerView.timer.invalidate()
  }
  
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    
    //    guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? BannerTableViewCell
    
    //      else { fatalError("Unexpected Table View Cell") }
    
    let imageCount = bannerCell.bannerView.imageArray.count
    
    if imageCount > 0 {
      // 向右拖動
      if bannerCell.bannerView.scrollView.contentOffset.x > bannerCell.bannerView.width {
        
        bannerCell.bannerView.currentIndex = (bannerCell.bannerView.currentIndex + 1) % imageCount
      }
      // 向左拖動
      if bannerCell.bannerView.scrollView.contentOffset.x < bannerCell.bannerView.width {
        
        bannerCell.bannerView.currentIndex = (bannerCell.bannerView.currentIndex - 1 + imageCount) % imageCount
      }
      // 更新小圓點當前位置
      bannerCell.bannerView.pageControl.currentPage = (bannerCell.bannerView.currentIndex - 1 + imageCount) % imageCount
      
      bannerCell.bannerView.reloadImage()
    }
    bannerCell.setupTimer()
    
  }
}
