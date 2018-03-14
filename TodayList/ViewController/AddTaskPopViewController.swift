//
//  AddTaskPopViewController.swift
//  TodayList
//
//  Created by hula3 on 2018/3/8.
//  Copyright © 2018年 hula3. All rights reserved.
//

import UIKit
import os.log

class AddTaskPopViewController: UIViewController, UITextViewDelegate {
    // MARK: - Properties
    @IBOutlet weak var PopView: UIView!
    @IBOutlet weak var dismissArea: UIButton!
    
    @IBOutlet weak var TaskTitleTextView: UITextView!
    var placeholderLabel: UILabel!
    
    @IBOutlet weak var AddConFirm: AddedTouchAreaButton!

    @IBOutlet weak var DateButton: AddedTouchAreaButton!
    @IBOutlet weak var AlertButton: AddedTouchAreaButton!
    @IBOutlet weak var TopicButton: AddedTouchAreaButton!
    
    var PopViewHasUpdatedOnce = false
    
    var task: Task?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup View
        SetupButtons()
        setupPopView()
        
        
        // Show Keyborad
        TaskTitleTextView.becomeFirstResponder()
        
        // Setup View
        setupTextView()
       
        // Update View
        NotificationCenter.default.addObserver(self, selector: #selector(AddTaskPopViewController.updateView(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddTaskPopViewController.updateView(notification:)), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddTaskPopViewController.updateView(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - TextView Delegate Methods
    
    func textViewDidChange(_  TaskTitleTextView: UITextView) {
        placeholderLabel.isHidden = !TaskTitleTextView.text.isEmpty

        if TaskTitleTextView.contentSize.height > 45 {
            resizeTextView(resizeOrRecover: true)
            // print("TextViewFrame: y: \(TaskTitleTextView.frame.origin.y), height: \(TaskTitleTextView.frame.height), ContentHeight: \(TaskTitleTextView.contentSize.height)")
            // print("PopViewFrame: y: \(PopView.frame.origin.y), height:\(PopView.frame.height)")
        } else {
            resizeTextView(resizeOrRecover: false)
        }
        
        // Line Space
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 8
        let attributes = [NSAttributedStringKey.paragraphStyle: style, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20), NSAttributedStringKey.foregroundColor: customColor.Black1]
        if TaskTitleTextView.markedTextRange == nil {
            TaskTitleTextView.attributedText = NSAttributedString(string: TaskTitleTextView.text, attributes:attributes)
        }
        updateAddButtonState()
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            //textView.resignFirstResponder()
            AddConfrim(AddConFirm)
        }
        return true
    }


    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        
        let title = TaskTitleTextView.text ?? ""
        
        // Set the task to be passed to TodayListViewController after the unwind segue.
        task = Task(title: title, isChecked: false)
    }
    
    
    @IBAction func AddConfrim(_ sender: Any) {
        let TextViewFrame = self.TaskTitleTextView.frame
        self.TaskTitleTextView.frame = CGRect(x: TextViewFrame.origin.x, y: 8, width: TextViewFrame.width, height: 38)
        
        self.AddConFirm.alpha = 0
        self.DateButton.alpha = 0
        self.DateButton.alpha = 0

        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            
            let Popframe = self.PopView.frame
            self.PopView.frame = CGRect(x: 0, y: self.view.frame.height/2 - Popframe.height/2, width: Popframe.width, height: 56)
            
            self.PopView.alpha = 0.8
            
            // CornerRadius
            self.setupCornerRadius(corner: 4)
            
            // Shadow
            //self.PopView.dropShadow(offSet: CGSize(width: 0, height: 0))
            
            self.TaskTitleTextView.resignFirstResponder()
            self.PopView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            
        }, completion: {(_ :Bool) in
            
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut, animations: {
                self.PopView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                self.PopView.alpha = 0
            }, completion: {(_: Bool) in
                
                self.performSegue(withIdentifier: "unwindToTodayList", sender: self)
            })
        })
    }
    
    // Dismiss
    /*
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.TaskTitleTextView.resignFirstResponder()
        self.performSegue(withIdentifier: "dismissToTodayList", sender: self)
    }*/
    
    @IBAction func dismissArea(_ sender: Any) {
        self.TaskTitleTextView.resignFirstResponder()
        self.performSegue(withIdentifier: "dismissToTodayList", sender: self)
    }
    
    
    // MARK: - Private Methods
    private func updateAddButtonState() {
        //Disable the Add button if the textView is empty
        let text = TaskTitleTextView.text ?? ""
        AddConFirm.isEnabled = !text.isEmpty
        
        if AddConFirm.isEnabled {
            AddConFirm.alpha = 1
        } else {
            AddConFirm.alpha = 0.5
        }
    }
    
    // MARK: - Setup View

    // Setup PopView
    func setupPopView() {
        // Set Frame
        let width = self.view.frame.width
        let height = self.view.frame.height
        PopView.frame = CGRect(x: 0, y: height - 140, width: width, height: 140)
        UpdatePopViewLayout()
        
        dismissArea.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: PopView.frame.origin.y - 4)
    }
    
    // Setup Buttons
    private func SetupButtons() {
        
        // AddButton
        AddConFirm.setTitle("添加", for: .normal)
        AddConFirm.setTitleColor(UIColor.white, for: .normal)
        AddConFirm.backgroundColor = customColor.Blue_Background
        AddConFirm.layer.cornerRadius = 8
        AddConFirm.alpha = 0.5
        AddConFirm.addedTouchArea = 6
        AddConFirm.isEnabled = false
        
        
        // Date
        DateButton.setImage(#imageLiteral(resourceName: "Date"), for: .normal)
        DateButton.setTitle(" 今日", for: .normal)
        DateButton.setTitleColor(customColor.Green_date, for: .normal)
        DateButton.sizeToFit()
        DateButton.addedTouchArea = 2
        
        // Alert
        AlertButton.setImage(#imageLiteral(resourceName: "Alert"), for: .normal)
        AlertButton.addedTouchArea = 2
        
        // Topic
        //TopicButton.buttonType = .custom
        TopicButton.setImage(#imageLiteral(resourceName: "Topic"), for: .normal)
        TopicButton.addedTouchArea = 2

    }
    
    // Setup Textiew
    private func setupTextView() {
        TaskTitleTextView.frame = CGRect(x: 16, y: self.PopView.frame.height - 64 - 52, width: self.PopView.frame.width - 32, height: 64)
        
        // Set placeholder
        TaskTitleTextView.delegate = self
        
        placeholderLabel = UILabel()
        placeholderLabel.text = "准备做什么？"
        placeholderLabel.font = UIFont.systemFont(ofSize: 20)
        placeholderLabel.textColor = customColor.Black3
        placeholderLabel.sizeToFit()
        TaskTitleTextView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (placeholderLabel.font?.pointSize)!/2 - 2)
        placeholderLabel.isHidden = !TaskTitleTextView.text.isEmpty
        
        // Cursor Color
        TaskTitleTextView.tintColor = customColor.Blue_Background
        
        // Return Key
        TaskTitleTextView.returnKeyType = .done
        TaskTitleTextView.enablesReturnKeyAutomatically = true
    }
    
    // MARK: - Update view
    
    // Update PopView Layout
    func UpdatePopViewLayout() {
        // CornerRadius
        setupCornerRadius(corner: 2)
        
        // Shadow
        //PopView.dropShadow(offSet: CGSize(width: 0, height: -24))
        
        // Buttons
        AddConFirm.frame = CGRect(x: PopView.frame.width - 54 - 16, y: PopView.frame.height - 32 - 16, width: 54, height: 32)
        
        let dateWidth = DateButton.frame.width
        let alertWidth = AlertButton.frame.width
        let topicWidth = TopicButton.frame.width
        DateButton.frame = CGRect(x: 16, y: PopView.frame.height - 24 - 20, width: dateWidth, height: 24)
        AlertButton.frame = CGRect(x: 16 + DateButton.frame.width + 16, y: PopView.frame.height - 24 - 20, width: alertWidth, height: 24)
        TopicButton.frame = CGRect(x: 16 + DateButton.frame.width + 16 + AlertButton.frame.width + 16, y: PopView.frame.height - 24 - 20, width: topicWidth, height: 24)

    }
    
   // MARK: Update Methods
    
    func setupCornerRadius(corner: Int) {
        // Set cornerRadius
        let maskPath: UIBezierPath
        if corner == 2 {
            maskPath = UIBezierPath(roundedRect: PopView.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 12, height: 0))
        } else  {
            maskPath = UIBezierPath(roundedRect: PopView.bounds, byRoundingCorners: [.bottomLeft, .bottomRight, .topLeft, .topRight], cornerRadii: CGSize(width: 12, height: 0))
        }
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        PopView.layer.mask = maskLayer
    }
    

    // Update View
    @objc func updateView (notification: Notification) {
        // get keyboard's frame
        let userInfo = notification.userInfo!
        let keyboardEndFrameScreenCoordinates = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardEndFrame = self.view.convert(keyboardEndFrameScreenCoordinates, to: view.window)
        
        // Change y when keyboard shows
        if notification.name == Notification.Name.UIKeyboardWillHide {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut , animations: {
                self.view.frame.origin.y = 0
            }, completion: nil)
            //self.performSegue(withIdentifier: "unwindToTodayList", sender: self)
        } else {
            self.view.frame.origin.y = 0
            self.view.frame.origin.y -= keyboardEndFrame.height
            //print("show: \(self.view.frame.origin.y)")
        }
        
        dismissArea.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: PopView.frame.origin.y - 4)
        
    }
    
    // Resize when editing
    func resizeTextView(resizeOrRecover: Bool) {
        let PopViewFrame = PopView.frame
        
        switch resizeOrRecover {
        case true:
            // Resize TextView
            if !PopViewHasUpdatedOnce {
                PopViewHasUpdatedOnce = true
                
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                    self.PopView.frame = CGRect(x: PopViewFrame.origin.x, y: PopViewFrame.origin.y - 24, width: PopViewFrame.width, height: 164)
                    self.UpdatePopViewLayout()
                }, completion: nil)
            }
        default:
            if PopViewHasUpdatedOnce {
                PopViewHasUpdatedOnce = false

                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                    self.PopView.frame = CGRect(x: PopViewFrame.origin.x, y: PopViewFrame.origin.y + 24, width: PopViewFrame.width, height: 164)
                    self.UpdatePopViewLayout()

                    // Buttons
                    self.AddConFirm.frame = CGRect(x: self.PopView.frame.width - 46 - 16, y: self.PopView.frame.height - 32 - 16 - 24, width: 46, height: 32)
                    
                    let dateWidth = self.DateButton.frame.width
                    let alertWidth = self.AlertButton.frame.width
                    let topicWidth = self.TopicButton.frame.width
                    
                    self.DateButton.frame = CGRect(x: 16, y: self.PopView.frame.height - 24 - 20 - 24, width: dateWidth, height: 24)
                    self.AlertButton.frame = CGRect(x: 16 + self.DateButton.frame.width + 16, y: self.PopView.frame.height - 24 - 20 - 24, width: alertWidth, height: 24)
                    self.TopicButton.frame = CGRect(x: 16 + self.DateButton.frame.width + 16 + self.AlertButton.frame.width + 16, y: self.PopView.frame.height - 24 - 20 - 24, width: topicWidth, height: 24)
                    
                }, completion: {(finished: Bool) in
                    self.PopView.frame = CGRect(x: PopViewFrame.origin.x, y: self.PopView.frame.origin.y, width: PopViewFrame.width, height: 140)
                })
            }
        }
    }
}

extension UIView {
    func dropShadow(offSet: CGSize, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.red.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = offSet
        layer.shadowRadius = 24
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

