//
//  UICollectionGridViewSortDelegate.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/6/4.
//  Copyright © 2021 TKY co. All rights reserved.
//

import Foundation
import UIKit

protocol UICollectionGridViewSortDelegate: AnyObject {

    func sort(colIndex: Int, asc: Bool, rows: [[Any]]) -> [[Any]]
}

class UICollectionGridViewController: UICollectionViewController {

    var cols: [String]! = []

    var rows: [[Any]]! = []
    
    weak var sortDelegate: UICollectionGridViewSortDelegate?
    
    private var selectedColIdx = -1

    private var asc = true
    
    init() {

        let layout = UICollectionGridViewLayout()

        super.init(collectionViewLayout: layout)

        layout.viewController = self

        collectionView!.backgroundColor = UIColor.white

        collectionView!.register(UICollectionGridViewCell.self,
                                      forCellWithReuseIdentifier: "cell")

        collectionView!.delegate = self

        collectionView!.dataSource = self

        collectionView!.isDirectionalLockEnabled = true

        collectionView!.bounces = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("UICollectionGridViewController.init(coder:) has not been implemented")
    }
    
    func setColumns(columns: [String]) {

        cols = columns
    }
    
    func addRow(row: [Any]) {

        rows.append(row)

        collectionView!.collectionViewLayout.invalidateLayout()

        collectionView!.reloadData()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        
        collectionView!.frame = CGRect(x: 0, y: 0,
                                       width: view.frame.width, height: view.frame.height)
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {

        if cols.isEmpty {
        
            return 0
        }

        return rows.count + 1
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        
        return cols.count
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: "cell",
                                     for: indexPath) as? UICollectionGridViewCell
        
        else { print("UICollectionGridViewCell not found"); return UICollectionViewCell() }
         
        if indexPath.section == 0 {

            cell.label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.bold)
            
            cell.label.text = cols[indexPath.row]
            
            cell.label.textColor = UIColor.white
        
        } else {
        
            cell.label.font = UIFont.systemFont(ofSize: 15)
            
            cell.label.text = "\(rows[indexPath.section-1][indexPath.row])"
            
            cell.label.textColor = UIColor.black
        }
        
        if indexPath.section == 0 {
            
            cell.backgroundColor = UIColor(red: 0x91/255, green: 0xDA/255,
                                           blue: 0x51/255, alpha: 1)

            if indexPath.row != selectedColIdx {
                
                cell.imageView.image = nil
            }
            
        } else {

            if indexPath.row == selectedColIdx {

                cell.backgroundColor = UIColor(red: 0xCC/255, green: 0xF8/255,
                                               blue: 0xFF/255, alpha: 1)
            } else if indexPath.section % 2 == 0 {

                cell.backgroundColor = UIColor(white: 242/255.0, alpha: 1)

            } else {

                cell.backgroundColor = UIColor.white
            }
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 didSelectItemAt indexPath: IndexPath) {

        print("tapped indexPath: [\(indexPath.section),\(indexPath.row)]")
        
        if indexPath.section == 0 && sortDelegate != nil {

            asc = (selectedColIdx != indexPath.row) ? true : !asc

            selectedColIdx = indexPath.row

            rows = sortDelegate?.sort(colIndex: indexPath.row, asc: asc, rows: rows)

            collectionView.reloadData()
        }
    }
}
