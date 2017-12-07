//
//  InputTextView.swift
//  MMA-Quiz
//
//  Created by Nguyen Nhat  Loc on 11/27/17.
//  Copyright © 2017 locnnteam. All rights reserved.
//

import UIKit

protocol InputTextDelegate {
    func inputTextCorrect(isCorrect: Bool)
    func helpButtonTapped()
    func showIconPass(isShow: Bool)
}

class InputTextView: UIView, KeyPressDelegate {
    
    func playAudioPressed() {
        
    }
    
    //MARK: Properties
    var wordKey: String?
    var countButtons = 1
    private var textButtons = [UITextField]()
    private var currentIndex =  0

    //init string of keyboard
    var strKeyboard: String {
        var str = ""
        for text in textButtons {
            str += text.text!
        }
        return str
    }
    
    var delegate: InputTextDelegate?
    
    
    @IBInspectable var starSize: CGSize = CGSize(width: FontSizeCustom.getStarSize(), height: FontSizeCustom.getStarSize()) {
        didSet {
            setupButtons()
        }
    }
    
    @IBOutlet weak var row1: UIStackView!
    @IBOutlet weak var row2: UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
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
        let nib = UINib(nibName: "InputTextView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.addSubview(view)
    }
    
    //MARK: Private Methods
    func setupButtons() {
        // Clear any existing buttons
        for button in textButtons {
            //removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        textButtons.removeAll()
        
        // initialize custom keyboard
        var keyboardView = KeyboardView()
        keyboardView = Bundle.main.loadNibNamed("KeyboardView", owner: self, options: nil)?[0] as! KeyboardView
        keyboardView.delegate = self
        
        guard let key = wordKey else {
            fatalError("InputTextView: Key check is nil")
        }
        
        keyboardView.setup(word: key, random: 3)
        let strings: [Character] = Array(key.characters)
        countButtons = strings.count
        
        //resize if need
        let size = starSize.width
        let minWidth = CGFloat(countButtons) * (size + 10.0) + 8
        let viewWidth = self.frame.size.width
        
        let row1_Count: Int = Int((viewWidth - 8) / (CGFloat(size + 10.0)))
        var row2_Count: Int = self.countButtons - row1_Count
        
        if row2_Count > 0 {
           row2.isHidden = false
        }
        
        for i in 0..<countButtons {
            // Create the button
            let button = UITextField()
            button.autocorrectionType = .yes
            button.autocorrectionType = .no
            button.inputView = keyboardView
            // Set the button images
            button.font = UIFont(name: "OpenSans-Bold", size: FontSizeCustom.getLabelFontSize())
            button.textColor = BackgroundColor.LessonLabelBackground
            button.tintColor = BackgroundColor.LessonLabelBackground
            
            // Add constraints
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: size).isActive = true
            button.widthAnchor.constraint(equalToConstant: size).isActive = true
            button.textAlignment = .center
            
            if (String(strings[i]) == " ") {
               button.insertText(" ")
            } else {
              button.setBottomBorder()
            }
            
            //Add to row
            if i > row1_Count {
               row2.addArrangedSubview(button)
            } else {
                row1.addArrangedSubview(button)
            }
            textButtons.append(button)
        }
        
        becomeEdditing(index: 0)
        
        //Suggestion character
        if (countButtons - 5) > 0 {
            suggestCharacters(words: key, num: countButtons - 5)
        }
    }
    
    private func updateKeybox(index: Int?, ch: String?) {
        currentIndex = index!
        if ch == "" {
            if (textButtons[index!].text == "") || (textButtons[index!].text == " ") {
                if index! > 0 {
                    becomeEdditing(index: index! - 1)
                } else {
                    becomeEdditing(index: index!)
                }
            } else {
                textButtons[index!].text = ""
                becomeEdditing(index: index!)
            }
            
        } else {
            if textButtons[index!].text == ""{
                textButtons[index!].insertText(ch!)
                if (index! < countButtons - 1){
                    for index in index!..<self.countButtons {
                        if textButtons[index].text == "" {
                            becomeEdditing(index: index)
                            break
                        }
                    }
                }
                
                let result = strKeyboard
                if result.lowercased() == wordKey?.lowercased() {
                    debugPrint("Test case is pass")
                    self.delegate?.inputTextCorrect(isCorrect: true)
                }else if result.characters.count == wordKey?.characters.count{
                    debugPrint("Test case is fail")
                    self.delegate?.inputTextCorrect(isCorrect: false)
                }
            }
        }
    }
    
    private func becomeEdditing(index: Int){
        if textButtons[index].text == " " {
            if index > 0 {
             textButtons[index - 1].becomeFirstResponder()
            } else {
              textButtons[index].becomeFirstResponder()
            }
        } else {
            textButtons[index].becomeFirstResponder()
        }
    }
    
    private func suggestCharacters(words: String, num: Int){
        let strings: [Character] = Array(words.characters)
        
        var nums = [Int]()
        
        for index in 0..<(strings.count){
            nums.append(index)
        }
        
        for _ in 0..<num{
            // random key from array
            let arrayKey = Int(arc4random_uniform(UInt32(nums.count)))
            
            // your random number
            let randNum = nums[arrayKey]
            
            let index = words.index (words.startIndex, offsetBy: randNum)
            textButtons[randNum].placeholder = String(words[index])
            
            // make sure the number isnt repeated
            nums.remove(at: arrayKey)
        }
    }
    
    //MARK: KeyboardViewDelegate
    
    func backSpacePressed() {
        self.delegate?.showIconPass(isShow: false)
        for index in 0..<self.textButtons.count {
            if textButtons[index].isFirstResponder {
                updateKeybox(index: index, ch: "")
            }
        }
    }
    
    func returnPressed() {
        //Todo return after finished keyboard
        for button in textButtons {
            if button.isFirstResponder {
                button.resignFirstResponder()
                button.endEditing(true)
                break
            }
        }
    }
    
    func helpPressed() {
        var cursor: Int!
        for index in 0..<self.textButtons.count {
            if textButtons[index].isFirstResponder {
                cursor = index
                break
            }
        }
        
        let index = wordKey!.index(wordKey!.startIndex, offsetBy: cursor)
        buttonTapped(str: String(wordKey![index]))
        self.delegate?.helpButtonTapped()
    }
    
    func buttonTapped(str: String) {
        for index in 0..<self.textButtons.count {
            if textButtons[index].isFirstResponder {
                updateKeybox(index: index, ch: str)
                break
            }
        }
    }
    
    func getCurrentTextField() -> UITextField {
        return self.textButtons[currentIndex]
    }
}
