//
//  AvatarPickerVC.swift
//  Smack
//
//  Created by Brett Mayer on 9/2/17.
//  Copyright © 2017 Devslopes. All rights reserved.
//

import UIKit

class AvatarPickerVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    
    //Variables
    var avType = AvatarType.dark  //by default, cuz it is what segment control is set to
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }

    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func segmentCntrlChanged(_ sender: Any) {
        if segmentControl.selectedSegmentIndex == 0 {
            avType = .dark
        } else {
            avType = .light
        }
        collectionView.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 28
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "avatarCell", for: indexPath) as? AvatarCell {
            cell.configureCell(index: indexPath.item, type: avType)
            return cell
        }
        
        return AvatarCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var numOfColumns: CGFloat = 3
        
        if UIScreen.main.bounds.width > 320 {  //320 is size of smallest phone screem, SE
            numOfColumns = 4
        }
        
        let spaceBtwnCells: CGFloat = 10
        let padding: CGFloat = 40 //20 on both sides
        //we're eliminating everything that is not a collection view cell
        
        //this gives us width of each individual cell
        let cellDimension = ((collectionView.bounds.width - padding) - (numOfColumns - 1) * spaceBtwnCells) / numOfColumns
        
        return CGSize(width: cellDimension, height: cellDimension)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if avType == .dark {
            UserDataService.instance.setAvatarName(avatarName: "dark\(indexPath.item)")
        } else {
            UserDataService.instance.setAvatarName(avatarName: "light\(indexPath.item)")
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}
