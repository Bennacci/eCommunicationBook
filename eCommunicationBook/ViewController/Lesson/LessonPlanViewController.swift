//
//  TCommunicationBookViewController.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/5/26.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit
import Lottie

class LessonPlanViewController: UIViewController, SavedLessonDelegate {
    
    @IBOutlet weak var viewCourseNotFound: UIView!
    
    @IBOutlet weak var viewCourseNotFoundLottie: UIView!
    
    @IBOutlet weak var labelNotFound: UILabel!
    
    @IBOutlet weak var buttonRedeem: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    private var animationView: AnimationView?
    
    var viewModel = LessonPlanViewModel()
    
    var lessonCollectionViewCellHeight: CGFloat = UIScreen.height / 5
    
    private let collectionViewSectionInsets = UIEdgeInsets(
        top: 0.0,
        left: 0.0,
        bottom: 0.0,
        right: 0.0)
    
    var pickedCourseIndexPath: IndexPath?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.registerCellWithNib(identifier: CourseTableViewCell.identifier, bundle: nil)
        
        tableView.registerCellWithNib(identifier: LessonsTableViewCell.identifier, bundle: nil)
        
        viewModel.fetchData()
        
        viewModel.courseViewModel.bind { [weak self] _ in
            
            self?.pickedCourseIndexPath = nil
            
            if self?.viewModel.courseViewModel.value.count == 0 {
                
                self?.addCourseNotFoundView()
                
                if UserManager.shared.user.userType == "teacher" {
                    
                    self?.buttonRedeem.isHidden = true
                    
                    self?.labelNotFound.text = "You haven't own any class"
                }
                
            } else {
                
                self?.viewCourseNotFound.isHidden = true
            }
            
            DispatchQueue.main.async {
                
                self?.tableView.reloadData()
            }
        }
        
        viewModel.onStudentAdded = { [weak self] () in
            
            self?.viewModel.fetchData()
            
            DispatchQueue.main.async {
                
                self?.tableView.reloadData()
            }
        }
    }
    
    func onSaved() {
        
        viewModel.fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        tableView.reloadData()
    }
    
    @IBAction func popViewController(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendAndQuitViewController(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func redeem(_ sender: Any) {
        
        let controller = UIAlertController(title: "Redeem Code",
                                           message: "Enter your invitation code to continue.",
                                           preferredStyle: .alert)
        
        controller.addTextField { (textField) in
            
            textField.placeholder = "code"
            
            textField.keyboardType = .default
        }
        
        let okAction = UIAlertAction(title: "ok", style: .default) { (_) in
            
            BTProgressHUD.show()
            
            guard let code = controller.textFields?[0].text else {return}
            
            if code != String.empty {
                
                self.viewModel.onVerifyInvitationCode(code: code)
            }
        }
        
        controller.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        
        controller.addAction(cancelAction)
        
        present(controller, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "lessonPlanDetail",
           
           let lessonPlanDetailViewController = segue.destination as? LessonPlanDetailViewController {
            
            if let button = sender as? UIButton {
                
                lessonPlanDetailViewController.navigationItem.title =
                    "Lesson \( self.viewModel.lessonViewModel.value[button.tag].number)"
                
                lessonPlanDetailViewController.delegate = self
                
                lessonPlanDetailViewController.viewModel.course =
                    
                    self.viewModel.courseViewModel.value[pickedCourseIndexPath!.row - 1].course
                
                if button.tag > 0 {
                    
                    lessonPlanDetailViewController.viewModel.previousLesson =
                        self.viewModel.lessonViewModel.value[button.tag - 1].lesson
                    
                    lessonPlanDetailViewController.viewModel.lesson =
                        self.viewModel.lessonViewModel.value[button.tag].lesson
                }
                
                lessonPlanDetailViewController.viewModel.lesson =
                    self.viewModel.lessonViewModel.value[button.tag].lesson
            }
            
        } else if segue.identifier == "lessonPerformancesReview",
                  let lessonPerformancesReviewViewController = segue
                    .destination as? LessonPerformancesReviewViewController {
            
            lessonPerformancesReviewViewController.viewModel.courseName =
                self.viewModel.courseViewModel.value[pickedCourseIndexPath!.row - 1].course.name
            
            if let button = sender as? UIButton {
                
                lessonPerformancesReviewViewController.viewModel.courseLesson =
                    self.viewModel.lessonViewModel.value[button.tag].lesson.number
            }
        }
    }
    
    func addCourseNotFoundView() {
        
        viewCourseNotFound.isHidden = false
        
        animationView = .init(name: "Error404")
        
        animationView!.frame = viewCourseNotFoundLottie.bounds
        
        animationView!.contentMode = .scaleAspectFit
        
        animationView!.loopMode = .loop
        
        animationView!.animationSpeed = 0.5
        
        viewCourseNotFoundLottie.addSubview(animationView!)
        
        viewCourseNotFoundLottie.layoutIfNeeded()
        
        viewCourseNotFound.layoutIfNeeded()
        
        animationView!.play()
    }
}

extension LessonPlanViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if pickedCourseIndexPath != nil {
            
            return viewModel.courseViewModel.value.count + 1
            
        } else {
            
            return viewModel.courseViewModel.value.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath == pickedCourseIndexPath {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LessonsTableViewCell.identifier,
                                                           for: indexPath) as? LessonsTableViewCell
            
            else {
                
                assertionFailure("LessonsTableViewCell not found")
                
                return UITableViewCell()
            }
            
            cell.collectionView.dataSource = self
            
            cell.collectionView.delegate = self
            
            cell.collectionView.reloadData()
            
            cell.collectionView.isPagingEnabled = true
            
            return cell
            
        } else {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CourseTableViewCell.identifier,
                                                           for: indexPath) as? CourseTableViewCell
            else {
                
                assertionFailure("CourseTableViewCell not found")
                
                return UITableViewCell()
            }
            
            var index: Int
            
            if let pickedCourseIndexPath = pickedCourseIndexPath,
               pickedCourseIndexPath.row <= indexPath.row {
                
                index = indexPath.row - 1
                
            } else {
                
                index = indexPath.row
                
            }
            
            cell.setup(viewModel: self.viewModel.courseViewModel.value[index])
            
            return cell
        }
    }
}

extension LessonPlanViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath) as? CourseTableViewCell != nil {
            
            tableView.beginUpdates()
            
            if let pickedCourseIndexPath = pickedCourseIndexPath, pickedCourseIndexPath.row - 1 == indexPath.row {
                
                tableView.deleteRows(at: [pickedCourseIndexPath], with: .fade)
                
                self.pickedCourseIndexPath = nil
                
            } else {
                
                if let pickedCourseIndexPath = pickedCourseIndexPath {
                    
                    tableView.deleteRows(at: [pickedCourseIndexPath], with: .fade)
                    
                    if indexPath == pickedCourseIndexPath {
                        
                        self.pickedCourseIndexPath = nil
                        
                    } else {
                        
                        self.pickedCourseIndexPath = indexPathToInsertDatePicker(indexPath: indexPath)
                        
                        viewModel.setLessonViewModel(index: self.pickedCourseIndexPath!.row - 1)
                        
                        tableView.insertRows(at: [self.pickedCourseIndexPath!], with: .fade)
                        
                        tableView.deselectRow(at: indexPath, animated: true)
                    }
                    
                } else {
                    
                    pickedCourseIndexPath = indexPathToInsertDatePicker(indexPath: indexPath)
                    
                    viewModel.setLessonViewModel(index: pickedCourseIndexPath!.row - 1)
                    
                    tableView.insertRows(at: [pickedCourseIndexPath!], with: .fade)
                    
                    tableView.deselectRow(at: indexPath, animated: true)
                }
            }
            
            tableView.endUpdates()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 35
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return CGFloat.leastNormalMagnitude
    }
    
    func indexPathToInsertDatePicker(indexPath: IndexPath) -> IndexPath {
        
        if let pickedCourseIndexPath = pickedCourseIndexPath, pickedCourseIndexPath.row < indexPath.row {
            
            return indexPath
            
        } else {
            
            return IndexPath(row: indexPath.row + 1, section: indexPath.section)
        }
    }
}

extension LessonPlanViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewModel.lessonViewModel.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LessonCollectionViewCell.identifier,
                                                            for: indexPath) as? LessonCollectionViewCell
        
        else {
            
            assertionFailure("LessonCollectionViewCell not found")
            
            return UICollectionViewCell()
        }
        
        cell.buttonEdit.addTarget(self, action: #selector(directToLessonPlan(sender:)), for: .touchUpInside)
        
        cell.buttonEdit.tag = indexPath.item
        
        cell.buttonScan.addTarget(self, action: #selector(directToScanQR(sender:)), for: .touchUpInside)
        
        cell.buttonScan.tag = indexPath.item
        
        cell.buttonInspect.tag = indexPath.item
        
        cell.buttonInspect.addTarget(self, action: #selector(directToLessonPerformancesReview(sender:)),
                                     for: .touchUpInside)
        
        cell.setUp(viewModel: self.viewModel.lessonViewModel.value[indexPath.item])
        
        return cell
    }
    
    @objc func directToLessonPlan(sender: UIButton) {
        
        performSegue(withIdentifier: "lessonPlanDetail", sender: sender)
    }
    
    @objc func directToLessonPerformancesReview(sender: UIButton) {
        
        performSegue(withIdentifier: "lessonPerformancesReview", sender: sender)
    }
    
    @objc func directToScanQR(sender: UIButton) {
        
        if let nextVC = UIStoryboard.scanStudentQR.instantiateInitialViewController()
            as? ScanStudentQRCodeViewController {
            
            nextVC.modalPresentationStyle = .fullScreen
            
            nextVC.viewModel.studentExistance.courseLesson = sender.tag + 1
            
            nextVC.viewModel.studentExistance.courseName =
                self.viewModel.courseViewModel.value[pickedCourseIndexPath!.row - 1].course.name
                + ":"
                + "\(viewModel.courseViewModel.value[pickedCourseIndexPath!.row - 1].course.lessonsAmount)"
            
            nextVC.hideDropDown = true
            
            self.navigationController?.show(nextVC, sender: nil)
        }
    }
}

extension LessonPlanViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return collectionViewSectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size: CGSize
        size = collectionView.calculateCellsize(viewHeight: lessonCollectionViewCellHeight,
                                                viewWidth: UIScreen.width - 32.0,
                                                sectionInsets: collectionViewSectionInsets,
                                                itemsPerRow: 1,
                                                itemsPerColumn: 3)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
}
