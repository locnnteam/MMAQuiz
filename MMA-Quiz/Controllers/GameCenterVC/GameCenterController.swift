//
//  GameCenter.swift
//  VocabularyGame
//
//  Created by Nguyen Nhat  Loc on 11/4/17.
//  Copyright © 2017 bktech. All rights reserved.
//

import UIKit
import GameKit

class GameCenterController: ViewController, GKGameCenterControllerDelegate {
 
    @IBOutlet weak var scoreLabel: UILabel!
    var gcEnabled = Bool()
    var gcDefaultLeaderBoard = String()
    var isAuthenticateLocal: Bool = false
    var score = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        kAppDelegate.bannerAdView.updateBannerFrame(pos: .NoTabbar)
        
        self.authenticateLocalPlayer()
        // Setting view
        let scoreView = ScoreView()
        self.view.addFitSubView(subView: scoreView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        kAppDelegate.bannerAdView.isTabbarShow = false
        LoadingLaunchView.shared.showOverlay(view: self.view)
//        self.scoreView.isHidden = true
        
        //Your score
        let defaults = UserDefaults.standard
        score = defaults.integer(forKey: ScoreData)
        if score == 0 {
            score = UserDefaults.standard.integer(forKey: ScoreData)
        }
        
        if self.isAuthenticateLocal {
            self.addScoreAndSubmitToGC(score: score)
            self.checkGCLeaderboard()
        } else {
//            LoadingLaunchView.shared.showOverlay(view: self.view)
            self.authenticateLocalPlayer()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Delegate to dismiss the GC controller
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
        
        kAppDelegate.bannerAdView.isTabbarShow = true
        kAppDelegate.bannerAdView.updateBannerFrame(pos: .HaveTabbar)
    }
    
    func checkGCLeaderboard() {
        kAppDelegate.bannerAdView.isTabbarShow = false
        kAppDelegate.bannerAdView.updateBannerFrame(pos: .NoTabbar)
        let gcVC = GKGameCenterViewController()
        gcVC.gameCenterDelegate = self
        gcVC.viewState = .leaderboards
        gcVC.leaderboardIdentifier = Leaderboad_Id
        present(gcVC, animated: true, completion: nil)
    }
    
    func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            LoadingLaunchView.shared.hideOverlayView()
            if((ViewController) != nil) {
                // 1 Show login if player is not logged in
                self.present(ViewController!, animated: true, completion: nil)
                self.isAuthenticateLocal = true
                kAppDelegate.bannerAdView.isTabbarShow = false
                kAppDelegate.bannerAdView.updateBannerFrame(pos: .NoTabbar)
            } else if (localPlayer.isAuthenticated) {
                // 2 Player is already euthenticated & logged in, load game center
                self.gcEnabled = true
                
                // Get the default leaderboard ID
                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer, error) in
                    if error != nil {
                        debugPrint(error!)
                    } else {
                        if self.isAuthenticateLocal == false {
                            self.isAuthenticateLocal = true
                            self.gcDefaultLeaderBoard = leaderboardIdentifer!
                            self.checkGCLeaderboard()
                            self.addScoreAndSubmitToGC(score: self.score)
                        }
                    }
                    
                })
            } else {
                // 3 Game center is not enabled on the users device
                self.gcEnabled = false
                kAppDelegate.bannerAdView.isTabbarShow = true
                kAppDelegate.bannerAdView.updateBannerFrame(pos: .HaveTabbar)
            }
        }
    }
    
    func addScoreAndSubmitToGC(score: Int) {
        // Submit score to GC leaderboard
        let bestScoreInt = GKScore(leaderboardIdentifier: Leaderboad_Id)
        bestScoreInt.value = Int64(score)
        GKScore.report([bestScoreInt]) { (error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                print("Best Score submitted to your Leaderboard!")
            }
        }
    }
}
