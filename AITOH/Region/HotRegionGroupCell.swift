//
//  HotRegionGroupCell.swift
//  AITOH
//
//  Created by Jerry Kwok on 4/3/2020.
//  Copyright © 2020 AITOH. All rights reserved.
//

import UIKit

class HotRegionGroupCell: UICollectionViewCell {
    
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    func initElement(region:RegionGroup){
        print(region.name)
        title.text = region.name
        print("IN cell" + region.bgImagePath)
        let url = URL(string: region.bgImagePath)
        do{
        self.bgImage.downloadImage(from: url!)
        }catch{
            print("error")
        }
        bgImage.layer.cornerRadius = 10
    }
    
    func initLast(){
     print("last Elet")
        title.text = ""
        bgImage.image = UIImage(named: "regionGroupMore")
    }
}
