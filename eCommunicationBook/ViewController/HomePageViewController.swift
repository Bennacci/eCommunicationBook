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
    
    var bannerCell = BannerTableViewCell()
    
    var viewModel = HomePageViewModel()
    
    var bannerViewCurrentIndex: NSInteger = 0
    
    var hotCellHeight: CGFloat = UIScreen.height / 2.8
    
    var recommendedCellHeight: CGFloat = UIScreen.height / 2
    
    private let collectionViewSectionInsets = UIEdgeInsets(
        top: 10.0,
        left: 10.0,
        bottom: 10.0,
        right: 10.0)
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.registerCellWithNib(identifier: ServicesTableViewCell.identifier, bundle: nil)
        
        tableView.registerCellWithNib(identifier: ServiceTableViewCell.identifier, bundle: nil)
        
        tableView.registerCellWithNib(identifier: BannerTableViewCell.identifier, bundle: nil)
        
        tableView.registerCellWithNib(identifier: NewsTableViewCell.identifier, bundle: nil)
        
        viewModel.fetchSign()
        
        viewModel.signViewModel.bind { [weak self] _ in
            
            self?.refreshView()
        }
        
        viewModel.checkUser()
        
        viewModel.onGotUserData = { [weak self] in
            
            self?.refreshView()
        }
    }
    
    func refreshView() {
        
        DispatchQueue.main.async {
            
            self.tableView.reloadData()
        }
    }
}

extension HomePageViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if UserManager.shared.user.userType == UserType.teacher.rawValue {
            
            return 4
            
        } else {
            
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if UserManager.shared.user.userType == UserType.teacher.rawValue {
            
            switch section {
            
            case 0:
                
                return String.empty
                
            case 1:
                
                return "Popular features"
                
            case 2:
                
                return "Recommanded for you"
                
            default:
                
                return "News"
            }
            
        } else {
            
            switch section {
            
            case 0:
                
                return String.empty
                
            case 1:
                
                return "Popular Features"
                
            default:
                
                return "News"
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var sectionThreeRowCount  = 0
        
        if  let servicesData =  viewModel.servicesData {
            
            sectionThreeRowCount = servicesData.items[1].count
        }
        
        let signCount = viewModel.signViewModel.value.count
        
        if UserManager.shared.user.userType == UserType.teacher.rawValue {
            
            return [1, 1, sectionThreeRowCount, signCount][section]
            
        } else {
            
            return [1, 1, signCount][section]
        }
    }
    
    // swiftlint:disable function_body_length
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath == [0, 0] {
            
            guard let cell = tableView
                    .dequeueReusableCell(withIdentifier: BannerTableViewCell.identifier,
                                         for: indexPath) as? BannerTableViewCell
            
            else {
                
                assertionFailure("BannerTableViewCell not found")
                
                return UITableViewCell()
            }
            
            bannerCell = cell
            
            cell.setBannerView()
            
            cell.bannerView.scrollView.delegate = self
            
            bannerCell.onTimeChanged = { [weak self] in
                
                self?.shifBanner()
            }
                        
            return cell
            
        } else if indexPath.section == 1 {
            
            guard let cell = tableView
                    .dequeueReusableCell(withIdentifier: ServicesTableViewCell.identifier,
                                         for: indexPath) as? ServicesTableViewCell
            
            else {
                
                assertionFailure("ServicesTableViewCell not found")
                
                return UITableViewCell()
            }
            
            cell.collectionView.delegate = self
            
            cell.collectionView.dataSource = self
            
            cell.collectionView.reloadData()
            
            if UserManager.shared.user.userType == UserType.teacher.rawValue {
                
                cell.height.constant = hotCellHeight
                
            } else {
                
                cell.height.constant = hotCellHeight / 2
            }
            
            return cell
            
        } else if indexPath.section == 2 && UserManager.shared.user.userType == UserType.teacher.rawValue {
            
            guard let cell = tableView
                    .dequeueReusableCell(withIdentifier: ServiceTableViewCell.identifier,
                                         for: indexPath) as? ServiceTableViewCell
            
            else {
                
                assertionFailure("ServicesTableViewCell not found")
                
                return UITableViewCell()
            }
            
            if  let servicesData =  viewModel.servicesData {
                
                cell.setUp(viewModel: servicesData, indexPath: indexPath)
                
            }
            
            return cell
            
        } else {
            
            guard let cell = tableView
                    .dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier,
                                         for: indexPath) as? NewsTableViewCell
            
            else {
                
                assertionFailure("NewsTableViewCell not found")
                
                return UITableViewCell()
            }
            
            cell.setUp(viewModel: viewModel.signViewModel.value[indexPath.row])
            
            return cell
        }
    }
    // swiftlint:enable function_body_length
    
    func shifBanner() {
        
        bannerViewCurrentIndex += 1
        
        bannerCell.bannerView.currentIndex = bannerViewCurrentIndex
        
        bannerCell.bannerView.reloadImage()
    }
}

extension HomePageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        
        headerView.backgroundColor = UIColor.clear
        
        let myLabel = UILabel()
        
        myLabel.frame = CGRect(x: 16, y: headerView.frame.height / 2, width: tableView.bounds.size.width, height: 30)
        
        myLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
        myLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
        
        headerView.addSubview(myLabel)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            
            return CGFloat.leastNormalMagnitude
            
        } else {
            
            return 45
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 2 && UserManager.shared.user.userType == UserType.teacher.rawValue {
            
            if let nextVC = UIStoryboard.newAThing.instantiateInitialViewController() {
                
                nextVC.modalPresentationStyle = .fullScreen
                
                guard let viewController = nextVC as? NewAThingViewController else {return}
                
                let services = ServiceManager
                    .init(userType: UserType(rawValue: UserManager.shared.user.userType!)!).services
                
                let servicesItem = services.items[indexPath.section - 1][indexPath.row]
                
                viewController.viewModel.servicesItem = servicesItem
                
                viewController.navigationItem.title = servicesItem.formTitle
                
                self.navigationController?.show(nextVC, sender: nil)
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension HomePageViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if  let servicesData =  viewModel.servicesData {
            
            return servicesData.items[0].count
            
        } else {
            
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: ServiceCollectionViewCell.identifier,
                                     for: indexPath) as? ServiceCollectionViewCell
        
        else {
            
            assertionFailure("ServiceCollectionViewCell not found")
            
            return UICollectionViewCell()
        }
        
        cell.height.constant = cell.bounds.size.height
        
        if  let servicesData =  viewModel.servicesData {
            
            cell.setUp(viewModel: servicesData, indexPath: indexPath, hot: true)
        }
        
        return cell
    }
}

extension HomePageViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let title = viewModel.servicesData?.items[0][indexPath.item].title
        
        switch title {
        
        case TeacherSeviceItem.writeStudentLessonRecord.title:
            
            navigationControllerShow(UIStoryboard.lessonPlan)
            
        case TeacherSeviceItem.writeStudentTimeInAndOut.title:
            
            navigationControllerShow(UIStoryboard.scanStudentQR)
            
        case ParentSeviceItem.checkStudentTimeInAndOut.title:
            
            navigationControllerShow(UIStoryboard.studentTimeInAndOut)
            
        case TeacherSeviceItem.attendanceSheet.title:
            
            navigationControllerShow(UIStoryboard.attendanceSheet)
            
        case TeacherSeviceItem.writeLessonPlan.title:
            
            BTProgressHUD.showFailure(text: "Coming soon")
            
        default:
            
            return
        }
    }
    
    func navigationControllerShow(_ storyBoard: UIStoryboard) {
        
        let storyBoardViewController = storyBoard.instantiateInitialViewController()
        
        if var nextVC = storyBoardViewController {
            
            if let scanStudentVC = nextVC as? ScanStudentQRCodeViewController {
                
                scanStudentVC.hideDropDown = false
                
                nextVC = scanStudentVC
            }
            
            nextVC.modalPresentationStyle = .fullScreen
            
            self.navigationController?.show(nextVC, sender: nil)
            
        } else { return }
    }
}

extension HomePageViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return collectionViewSectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size: CGSize
        
        if UserManager.shared.user.userType == UserType.teacher.rawValue {
            
            size = collectionView.calculateCellsize(viewHeight: hotCellHeight,
                                                    sectionInsets: collectionViewSectionInsets,
                                                    itemsPerRow: 2,
                                                    itemsPerColumn: 2)
        } else {
            
            size = collectionView.calculateCellsize(viewHeight: hotCellHeight / 2,
                                                    sectionInsets: collectionViewSectionInsets,
                                                    itemsPerRow: 2,
                                                    itemsPerColumn: 1)
        }
        
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 15
    }
}

extension HomePageViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        bannerCell.bannerView.timer.invalidate()

        let width = UIScreen.main.bounds.size.width
        
        bannerCell.bannerView.scrollView.contentOffset.x = width
        
        bannerCell.bannerView.scrollView.decelerationRate = UIScrollView.DecelerationRate.fast
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let width = UIScreen.main.bounds.size.width
        
        let imageCount = bannerCell.bannerView.imageArray.count
        
        if bannerCell.bannerView.scrollView.contentOffset.x > width {
            
            bannerViewCurrentIndex = (bannerViewCurrentIndex + 1) % imageCount
        }
        
        if bannerCell.bannerView.scrollView.contentOffset.x < width {
            
            bannerViewCurrentIndex = (bannerViewCurrentIndex - 1 + imageCount) % imageCount
        }
        
        bannerCell.bannerView.currentIndex = bannerViewCurrentIndex
        
        bannerCell.bannerView.reloadImage()
        
        bannerCell.setupTimer()
    }
}
