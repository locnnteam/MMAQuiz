//
//  fronView.swift
//  VocabularyGame
//
//  Created by Nguyen Nhat  Loc on 10/3/17.
//  Copyright © 2017 bktech. All rights reserved.
//

import UIKit

protocol FrontViewDelegate {
    func audioDictPlay()
    func favoriteDictAdd()
}

class FrontView: UIView {
    @IBOutlet weak var definationLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var favoritesButton: UIButton!
    var delegate: FrontViewDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
    }
    
    func loadViewFromNib() {
        let height = 0
        self.frame = CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.width), height: height)
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "FrontView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
    }

    @IBAction func favoritesButtonTapped(_ sender: Any) {
        self.delegate.favoriteDictAdd()
    }
}
