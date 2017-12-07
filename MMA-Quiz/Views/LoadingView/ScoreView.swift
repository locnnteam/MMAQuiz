//
//  ScoreView.swift
//  MMA-Quiz
//
//  Created by Nguyen Nhat  Loc on 11/30/17.
//  Copyright © 2017 locnnteam. All rights reserved.
//

import UIKit
import FacebookShare
import GameKit

class ScoreView: UIView {
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var rateUs: UIButton!
    @IBOutlet weak var facebook: UIButton!
    
    let AppID = "id1317506711"
    let AppURL = "https://itunes.apple.com/vn/app/voca-quiz/id1317506711?mt=8"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
        //
        if score == 0 {
            score = UserDefaults.standard.integer(forKey: ScoreData)
        }
        self.scoreLabel.text = "\(score)"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
    }
    
    func loadViewFromNib() {
        let height = UIScreen.main.bounds.height - 64
        let width = UIScreen.main.bounds.width
        self.frame = CGRect(x: 0, y: 64, width: width, height: height)
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ScoreView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
    }
    
    
    @IBAction func rateUs(_ sender: Any) {
        rateApp(appId: AppID){ success in
            debugPrint("RateApp \(success)")
        }
    }
    
    @IBAction func facebook(_ sender: Any) {
        let url = URL(string: AppURL)
        let content = LinkShareContent(url: url!)
        let shareDialog = ShareDialog(content: content)
        shareDialog.mode = .native
        shareDialog.failsOnInvalidData = true
        shareDialog.completion = { result in
            // Handle share results
        }
        
        do {
            _ = try shareDialog.show()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    fileprivate func rateApp(appId: String, completion: @escaping ((_ success: Bool)->())) {
        guard let url = URL(string : "itms-apps://itunes.apple.com/app/" + appId) else {
            completion(false)
            return
        }
        guard #available(iOS 10, *) else {
            completion(UIApplication.shared.openURL(url))
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: completion)
    }
}
