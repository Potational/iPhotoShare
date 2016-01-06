//
//  DownloadDetailCollectionViewCell.swift
//  PhotoShare
//
//  Created by kawanamitakanori on 2015/12/23.
//  Copyright © 2015年 ie4a. All rights reserved.
//

import UIKit

class DownloadDetailCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var DownloadDetailImage: UIImageView!

    override init(frame: CGRect){
        super.init(frame: frame)
    }
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)!
    }
}
