//
//  ImagesViewController.swift
//  Twitter Feed
//
//  Created by VIdushi Jaiswal on 01/03/18.
//  Copyright © 2018 Vidushi Jaiswal. All rights reserved.
//

import UIKit

class ImagesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mainImage: UIImageView!
    
    var listOfImages: [UIImage] = [
        UIImage(named: "image1.jpg")!,
        UIImage(named: "image2.jpg")!,
        UIImage(named: "image3.jpg")!,
        UIImage(named: "image4.jpg")!,
        UIImage(named: "image5.jpg")!,
        UIImage(named: "image6.jpg")!,
        UIImage(named: "image7.jpg")!,
        UIImage(named: "image8.jpg")!,
        ]
    
    //MARK: Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //mainImage.layer.masksToBounds = true
        mainImage.layer.cornerRadius = 8
        mainImage.layer.masksToBounds = true
    

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: Helper Functions
    func scrollToNextCell(){
        
        //get cell size
        let cellSize = CGSize(width: self.view.frame.width, height: self.view.frame.height);
        
        //get current content Offset of the Collection view
        let contentOffset = collectionView.contentOffset;
        
        if collectionView.contentSize.width <= collectionView.contentOffset.x + cellSize.width
        {
            collectionView.scrollRectToVisible(CGRect(x: 0, y: contentOffset.y, width: cellSize.width, height: cellSize.height), animated: true);
            
        } else {
            collectionView.scrollRectToVisible(CGRect(x: contentOffset.x + cellSize.width - 30, y: contentOffset.y, width: cellSize.width, height: cellSize.height), animated: true);
            
        }
        
    }
    
    
    //MARK: Collection view functions
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listOfImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! ImageCollectionViewCell
     
        cell.layer.cornerRadius = 8
        
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 3.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = true
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        cell.image.image =  listOfImages[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.right, animated: true)
        //scrollToNextCell()
        //let cell: UICollectionViewCell? = collectionView.cellForItem(at: indexPath)
        if indexPath.item % 2 == 1 {
            scrollToNextCell()
        }
        
        self.mainImage.image = listOfImages[indexPath.row]
        
        
        //let completelyVisible = collectionView.bounds.contains(cellRect)
        // if completelyVisible
        
        
    }

    

    

}
