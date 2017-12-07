//
//  LessonTypingViewController.swift
//  Vocabulary
//
//  Created by Nguyen Nhat  Loc on 8/5/17.
//  Copyright © 2017 bktech. All rights reserved.
//

import UIKit
import AVFoundation
import SCLAlertView
import AlamofireImage
import FirebaseAnalytics
import Spring
import SAConfettiView
import FaceAware
import FacebookShare

class LessonTypingViewController: UIViewController, LessonViewCellDelegate, AudioPlayerDelegate {
    
    private var maxfailed = 0
    private var viewNumber = 0
    private var durationLesson: Double?
    private var level: Int?
    var result = false
    var name: String?
    var keyName: String?
    var keyID: String!
    private var numsView = 0
    let maxFailed = 5
    
    let AppID = "id1317506711"
    let AppURL = "https://itunes.apple.com/vn/app/voca-quiz/id1317506711?mt=8"
    
    var numsFailed = 0 {
        didSet {
            lessonNavView.ratingControl.rating = maxFailed - numsFailed
            if numsFailed == maxfailed{
                self.backToHome(alertType: .OutOfHearts, showPopup: true)
            }
        }
    }
    
    private var alertView: SCLAlertView?
    
    @IBOutlet weak var lessonNavView: LessonNavView!
    @IBOutlet weak var inputTextView: InputTextView!
    @IBOutlet weak var passImageView: SpringImageView!
    @IBOutlet weak var flashCardView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var fighterImageView: UIImageView!
    
    @IBOutlet weak var fbButton: UIButton!
    @IBOutlet weak var twButton: UIButton!
    @IBOutlet weak var whatAppButton: UIButton!
    
    @IBOutlet weak var nicknameLabel: FadeLabel!
    @IBOutlet weak var birthdayLabel: FadeLabel!
    @IBOutlet weak var bornLabel: FadeLabel!
    
    var coreData = CoreDataOperations()
    
    var imageView: UIImageView!
    var definationView: FlashCardView!
    
//    var showingBack: Bool = false {
//        didSet {
//            imageView.isHidden = showingBack
//            definationView.isHidden = !showingBack
//        }
//    }

    var audioPlayer: AudioPlayer!

    var listVocabulary: [LessonItem] = []
    private var listVocabularyKey: [LessonItem] = []
    private var listVocabularyShow: [LessonItem?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.lessonNavView.setup()
        self.lessonNavView.setTimeToFinished(duration: self.durationLesson!)
        self.lessonNavView.delegate = self
        
        loadListVocabulary()
        
        self.audioPlayer = AudioPlayer()
        self.audioPlayer.delegate = self
        
        //firebase analyst
        Analytics.logEvent("Open Typing quiz", parameters: [
            "name": "Open Typing quiz" as NSObject,
            "text": "Click to Open Typing quiz" as NSObject
            ])
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: Notification.Name.UIApplicationWillResignActive, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appMovedToActive), name: Notification.Name.UIApplicationDidBecomeActive, object: nil)
        
//        //Flashcard
//        self.imageView = UIImageView()
//        self.imageView.contentMode = .scaleAspectFill
////        self.flashCardView.addCustomSubView(subView: self.imageView, topConstant: 25.0, leadingConstant: 25.0, bottomConstant: 25.0, trailingConstant: 25.0)
////        self.flashCardView.addFitSubView(subView: self.imageView)
//        self.flashCardView.addSubview(self.imageView)
        
//        self.definationView = FlashCardView()
//        self.definationView.delegate = self
//        self.definationView.contentMode = .center
//        self.flashCardView.addFitSubView(subView: self.definationView)
        
//        self.showingBack = false
//
//        let singleTap = UITapGestureRecognizer(target: self, action: #selector(flip))
//        singleTap.numberOfTapsRequired = 1
//        self.flashCardView.addGestureRecognizer(singleTap)
        
//        self.fighterImageView.layer.cornerRadius = self.fighterImageView.layer.frame.size.width/5
        self.fighterImageView.clipsToBounds = true
        self.fighterImageView.layer.borderWidth = WidthBorderLessonCell
        self.fighterImageView.layer.borderColor = BackgroundColor.BorderGrayColor.cgColor
        self.fighterImageView.backgroundColor = .clear
        
//        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
//        let blurredImage = #imageLiteral(resourceName: "lesson_bg").applyBlur(
//            withRadius: CGFloat(0.5),
//            tintColor: nil,
//            saturationDeltaFactor: 1.0,
//            maskImage: nil
//        )
//        backgroundImage.image = blurredImage
//
//        backgroundImage.contentMode = UIViewContentMode.scaleAspectFill
//        self.contentView.insertSubview(backgroundImage, at: 0)
        
        nextView()
    }
    
//    func flip() {
//        let toView = self.showingBack ? self.imageView : self.definationView
//        let fromView = self.showingBack ? self.definationView : self.imageView
//        UIView.transition(from: fromView, to: toView, duration: 0.5, options: .transitionFlipFromRight, completion: nil)
//        toView.translatesAutoresizingMaskIntoConstraints = true
//        showingBack = !showingBack
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        kAppDelegate.bannerAdView.isTabbarShow = false
        kAppDelegate.bannerAdView.updateBannerFrame(pos: .NoTabbar)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    @IBAction func fbButtonTapped(_ sender: Any) {
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
    
    @IBAction func twButtonTapped(_ sender: Any) {
        let vc = UIActivityViewController(activityItems: [AppURL], applicationActivities: [])
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func whatsAppButtonTapped(_ sender: Any) {
        let vc = UIActivityViewController(activityItems: [AppURL], applicationActivities: [])
        present(vc, animated: true, completion: nil)
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(Notification.Name.UIApplicationWillResignActive)
        notificationCenter.removeObserver(Notification.Name.UIApplicationDidBecomeActive)
        
    }
    
    
    func appMovedToBackground() {
        if self.lessonNavView.countDownLabel.isCounting {
            self.lessonNavView.countDownLabel.pause()
        }
    }
    
    func appMovedToActive() {
        if self.lessonNavView.countDownLabel.isPaused{
            self.lessonNavView.countDownLabel.start()
        }
    }
    
    func setup(maxfailed : Int, duration: Double, name: String?, listVocabulary: Array<LessonItem>) {
        self.maxfailed = maxfailed
        self.durationLesson = duration * 1.7
        self.name = name
        self.listVocabulary = listVocabulary
    }
    
    func getImage(nameImage: String) -> UIImage {
        let filePath = DocumentsURL.appendingPathComponent("\(self.name!)/\(nameImage).png").path
        if FileManager.default.fileExists(atPath: filePath) {
            return UIImage(contentsOfFile: filePath)!
        }else{
            return #imageLiteral(resourceName: "default")
        }
    }
 
    override var prefersStatusBarHidden: Bool {
        if #available(iOS 11.0, *) { // check for iOS 11.0 and later
            return false
        } else {
            return true
        }
    }
    
    func loadListVocabulary(){
        self.listVocabularyKey = listVocabulary
    }
    
    // MARK: Create image to show and key
    func nextView(){
        self.passImageView.isHidden = true
        if self.listVocabularyKey.isEmpty {
            //Next lesson
            self.backToHome(alertType: .PassLesson, showPopup: true)
            let defaults = UserDefaults.standard
            let userValue = "typing_\(self.name!)"
            let starCount = self.maxfailed - self.numsFailed + 1
            
            // Update score for user
            score = defaults.integer(forKey: ScoreData)
            let starCountSave = defaults.integer(forKey: userValue)
            if (starCountSave != 0) && (score > starCountSave) {
                score -= starCountSave
                score += starCount
            } else if (starCountSave == 0) {
                score += starCount
            }
            
            defaults.set(starCount, forKey: userValue)
            defaults.set(score, forKey: ScoreData)
            GCManager().addScoreAndSubmitToGC(score: score)
            return
        }
        
        let randomKey = Int(arc4random_uniform(UInt32(listVocabularyKey.count)))
        self.keyID = self.listVocabulary[randomKey].id!
        //setup view
        self.fighterImageView.image = getImage(nameImage: listVocabularyKey[randomKey].name)
        
        self.keyName =  listVocabularyKey[randomKey].name
        self.inputTextView.wordKey = keyName!
        
        let audioFileName = self.keyName!
        let filePath = DocumentsURL.appendingPathComponent("\(self.name!)/\(audioFileName).mp3").path
        if FileManager.default.fileExists(atPath: filePath) {
            Helper.perfomDelay(time: 0.2){
                self.audioPlayer.playAudioLocal(audio: filePath)
            }
        }
        
        listVocabularyKey.remove(at: randomKey)
        inputTextView.setupButtons()
        inputTextView.delegate = self
        
        viewNumber += 1
        var average: Float = 0
        average = (Float (viewNumber) / Float(listVocabulary.count))
        lessonNavView.progressBar.setProgress(CGFloat(average), animated: true)
        
        let nickname = (self.listVocabulary[Int(self.keyID)!].nickname)
        let birthday = "Date of Birth: \(self.listVocabulary[Int(self.keyID)!].birthday!)"
        let born = "Born: \(self.listVocabulary[Int(self.keyID)!].born!)"
        
        self.nicknameLabel.text = nickname
        self.birthdayLabel.text = birthday
        self.bornLabel.text = born
    }
    
    // MARK: Controller view cycle
    func backToHome(alertType: AlertPopupType, showPopup: Bool) {
        //clean up and show alert
        self.view.endEditing(true)
        cleanUp()
        
        if showPopup{
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false
            )
            if alertView != nil {
                alertView?.hideView()
            }
            alertView = SCLAlertView(appearance: appearance)
            
            switch alertType {
            case .TimeLimit:
                alertView?.addButton("Try Again", action: {self.buttonTryAgainTapped()})
                alertView?.addButton("Home", action: {self.buttonDoneTapped()})
                alertView?.showError("Try Again", subTitle: "Time is limited !")
            case .OutOfHearts:
                alertView?.addButton("Try Again", action: {self.buttonTryAgainTapped()})
                alertView?.addButton("Home", action: {self.buttonDoneTapped()})
                alertView?.showError("Try Again", subTitle: "You are out of STARS !")
            case .PassLesson:
                alertView?.addButton("Done", action: {self.buttonDoneTapped()})
                alertView?.showSuccess("Congratulation!", subTitle: "You are passed lesson \(self.name!)")
                showCongratulationsAnim(superView: (self.alertView?.view)!)
            default:
                print("No define alert type")
            }
            kAppDelegate.showInterstialAd(adRootVC: self)
        }else{
            guard (navigationController?.popViewController(animated:true)) != nil
                else {
                    dismiss(animated: true, completion: nil)
                    return
            }
        }
    }
    
    func showCongratulationsAnim(superView: UIView) {
        let confettiView = SAConfettiView(frame: self.view.bounds)
        superView.addSubview(confettiView)
        confettiView.bindFrameToSuperviewBounds()
        confettiView.intensity = 0.75
        confettiView.type = .Diamond
        confettiView.startConfetti()
        Helper.perfomDelay(time: 1.2) {
            confettiView.stopConfetti()
            confettiView.removeFromSuperview()
        }
    }
    
    func buttonDoneTapped() {
        guard (navigationController?.popViewController(animated:true)) != nil
            else {
                dismiss(animated: true, completion: nil)
                return
        }
    }
    
    func buttonTryAgainTapped() {
        loadListVocabulary()
        lessonNavView.setTimeToFinished(duration: self.durationLesson!)
        lessonNavView.progressBar.setProgress(0, animated: true)
        lessonNavView.ratingControl.rating = 5
        nextView()
    }
    
    func cleanUp(){
        numsFailed = 0
        numsView = 0
        viewNumber = 0
        lessonNavView.countDownLabel.cancel()
        audioPlayer.stopAudioLocal()
        
    }
    
    func pauseLessonTest() {
        
    }
    
    
    // MARK: Gameaudio delegate
    func finishedGameSouds(successfully flag: Bool){
        if result {
            nextView()
        }
    }
}

extension LessonTypingViewController: InputTextDelegate, MoveAnimationViewDelegate{
    // MARK: Delegate from Keyboard
    func inputTextCorrect(isCorrect: Bool) {
        passImageView.isHidden = false
        if isCorrect{
            result = true
            audioPlayer.playGameSounds(audio: Sound.passSounds!)
            passImageView.image = #imageLiteral(resourceName: "typingPass")
            passImageView.animation = "zoomIn"
            passImageView.animate()
            //Reset data
            
        }else{
            result = false
            audioPlayer.playGameSounds(audio: Sound.failSounds!)
            passImageView.image = #imageLiteral(resourceName: "typingFail")
            passImageView.animation = "shake"
            passImageView.animate()
        }
    }
    
    func showIconPass(isShow: Bool) {
        passImageView.isHidden = !isShow
    }
    
    func helpButtonTapped(){
        let to = self.lessonNavView.ratingControl.getPositionStar(index: maxFailed - numsFailed - 1)
        let toPoint = self.lessonNavView.ratingControl.convert(to, to: self.view)
        
        let fromItem = self.inputTextView.getCurrentTextField()
        let from = CGPoint(x: fromItem.bounds.midX, y: fromItem.bounds.midY)
        let fromPoint = fromItem.convert(from, to: self.view)
        
        // custom configuration
        let animationView = MoveAnimationView {
            $0.color = UIColor.red
            $0.startPoint = fromPoint
            $0.stopPoint = toPoint
            $0.startAnimation()
        }
        
        self.view.addSubview(animationView)
        animationView.bindFrameToSuperviewBounds()
        animationView.delegate = self
    }
    // MARK: MoveAnimationViewDelegate
    func stopMoveAnimation() {
        numsFailed += 1
        lessonNavView.ratingControl.rating = 5 - numsFailed
        if numsFailed == maxFailed {
            self.backToHome(alertType: .OutOfHearts, showPopup: true)
        }
    }
}

extension LessonTypingViewController: FlashCardViewDelegate {
    func favoriteDictAdd() {
        let lessonItem = listVocabulary[Int(self.keyID)!]
        if self.definationView.favoriteButton.isSelected {
            coreData.saveData(lessonItem: lessonItem)
        } else {
            coreData.deleteRecords(lessonItem: lessonItem)
        }
    }
}


