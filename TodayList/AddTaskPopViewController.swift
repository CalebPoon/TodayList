//
//  AddTaskPopViewController.swift
//  TodayList
//
//  Created by hula3 on 2018/3/8.
//  Copyright © 2018年 hula3. All rights reserved.
//

import UIKit

class AddTaskPopViewController: UIViewController, UITextViewDelegate {
    // MARK: - Properties
    @IBOutlet weak var PopView: UIView!
    
    @IBOutlet weak var TaskTitleTextView: UITextView!
    var placeholderLabel: UILabel!
    
    @IBOutlet weak var AddConFirm: UIButton!

    @IBOutlet weak var DateButton: UIButton!
    @IBOutlet weak var AlertButton: UIButton!
    @IBOutlet weak var TopicButton: UIButton!
    
    var PopViewHasUpdatedOnce = false
    
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
    
    func textViewDidChange(_  TaskTitleTextView: UITextView) {
        placeholderLabel.isHidden = !TaskTitleTextView.text.isEmpty

        if TaskTitleTextView.contentSize.height > 45 {
            resizeTextView(resizeOrRecover: true)
            print("TextViewFrame: y: \(TaskTitleTextView.frame.origin.y), height: \(TaskTitleTextView.frame.height), ContentHeight: \(TaskTitleTextView.contentSize.height)")
            print("PopViewFrame: y: \(PopView.frame.origin.y), height:\(PopView.frame.height)")
        } else {
            resizeTextView(resizeOrRecover: false)
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func AddConfrim(_ sender: Any) {
        UIView.animate(withDuration: 0.2, animations: {
            self.AddConFirm.alpha = 0
        }) { (finished: Bool) in
            //self.dismiss(animated: true, completion: nil)
        }
    }
    
    // Dismiss
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.TaskTitleTextView.resignFirstResponder()
        self.performSegue(withIdentifier: "unwindToTodayList", sender: self)
    }
    
    
    // MARK: - Setup View

    // Setup PopView
    func setupPopView() {
        // Set Frame
        let width = self.view.frame.width
        let height = self.view.frame.height
        PopView.frame = CGRect(x: 0, y: height - 140, width: width, height: 140)
        UpdatePopViewLayout()
    }
    
    // Setup Buttons
    private func SetupButtons() {
        
        // AddButton
        AddConFirm.setTitle("添加", for: .normal)
        AddConFirm.setTitleColor(UIColor.white, for: .normal)
        AddConFirm.backgroundColor = customColor.Blue_Background
        AddConFirm.layer.cornerRadius = 8
        UIView.animate(withDuration: 0.1, animations: {
            self.AddConFirm.alpha = 1
        })
        
        // Date
        DateButton.setImage(#imageLiteral(resourceName: "Date"), for: .normal)
        DateButton.setTitle(" 今日", for: .normal)
        DateButton.setTitleColor(customColor.Green_date, for: .normal)
        DateButton.sizeToFit()
        
        // Alert
        AlertButton.setImage(#imageLiteral(resourceName: "Alert"), for: .normal)
        
        // Topic
        //TopicButton.buttonType = .custom
        TopicButton.setImage(#imageLiteral(resourceName: "Topic"), for: .normal)

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
    }
    
    // MARK: - Update view
    
    // Update PopView Layout
    func UpdatePopViewLayout() {
        // CornerRadius
        setupCornerRadius()
        
        // Shadow
        self.dropShadow(offSet: CGSize(width: 0, height: -24))
        self.dropShadow(offSet: CGSize(width: 0, height: 0))
        
        // Buttons
        AddConFirm.frame = CGRect(x: PopView.frame.width - 46 - 16, y: PopView.frame.height - 32 - 16, width: 46, height: 32)
        
        let dateWidth = DateButton.frame.width
        let alertWidth = AlertButton.frame.width
        let topicWidth = TopicButton.frame.width
        DateButton.frame = CGRect(x: 16, y: PopView.frame.height - 24 - 20, width: dateWidth, height: 24)
        AlertButton.frame = CGRect(x: 16 + DateButton.frame.width + 20, y: PopView.frame.height - 24 - 20, width: alertWidth, height: 24)
        TopicButton.frame = CGRect(x: 16 + DateButton.frame.width + 20 + AlertButton.frame.width + 20, y: PopView.frame.height - 24 - 20, width: topicWidth, height: 24)
    }
    
   // MARK: Update Methods
    
    func dropShadow(offSet: CGSize, scale: Bool = true) {
        PopView.layer.masksToBounds = false
        PopView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.40).cgColor
        PopView.layer.shadowOpacity = 1
        PopView.layer.shadowOffset = offSet
        PopView.layer.shadowRadius = 24
        
        PopView.layer.shadowPath = UIBezierPath(rect: PopView.bounds).cgPath
        PopView.layer.shouldRasterize = true
        PopView.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }

    func setupCornerRadius() {
        // Set cornerRadius
        let maskPath = UIBezierPath(roundedRect: PopView.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 12, height: 0))
        
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
        
    }
    
    // Resize when editing
    func resizeTextView(resizeOrRecover: Bool) {
        let PopViewFrame = PopView.frame
        
        switch resizeOrRecover {
        case true:
            // Resize TextView
            if !PopViewHasUpdatedOnce {
                PopViewHasUpdatedOnce = true
                
                PopView.frame = CGRect(x: PopViewFrame.origin.x, y: PopViewFrame.origin.y - 24, width: PopViewFrame.width, height: 164)
                UpdatePopViewLayout()
            }
        default:
            if PopViewHasUpdatedOnce {
                PopViewHasUpdatedOnce = false

                PopView.frame = CGRect(x: PopViewFrame.origin.x, y: PopViewFrame.origin.y + 24, width: PopViewFrame.width, height: 140)
                UpdatePopViewLayout()
            }
        }
    }
}


