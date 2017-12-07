//
//  LessonViewCell.swift
//  Vocabulary
//
//  Created by Nguyen Nhat  Loc on 6/17/17.
//  Copyright © 2017 bktech. All rights reserved.
//

import UIKit

class LessonViewCell: UICollectionViewCell {

    @IBOutlet weak var imageLessonView: UIImageView!
    @IBOutlet weak var selectedView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initViewCell()
    }
    
    func initViewCell(){
        guard let image = imageLessonView else {
            print("Can not load image")
            return
        }
        
        image.layer.cornerRadius = self.imageLessonView.layer.frame.size.width/3
        image.clipsToBounds = true
        image.layer.borderWidth = WidthBorderLessonCell
        image.layer.borderColor = BackgroundColor.BorderGrayColor.cgColor
        image.backgroundColor =  .clear //.black //.white
        selectedView.isHidden = true
        
        
    }
    
    func setSelectedView(bool: Bool){
        selectedView.isHidden = false
        if bool {
            selectedView.image = #imageLiteral(resourceName: "passStick")
        }else{
            selectedView.image = #imageLiteral(resourceName: "failStick")
        }
    }
}
