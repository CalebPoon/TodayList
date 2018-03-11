//
//  AddTaskPopViewController.swift
//  TodayList
//
//  Created by hula3 on 2018/3/8.
//  Copyright © 2018年 hula3. All rights reserved.
//

import UIKit

class AddTaskPopViewController: UIViewController, UITextViewDelegate {
    //MARK: Properties
    @IBOutlet weak var PopView: UIView!
    
    @IBOutlet weak var TaskTitleTextView: UITextView!
    var placeholderLabel: UILabel!
    
    @IBOutlet weak var AddConFirm: UIButton!

    @IBOutlet weak var DateButton: UIButton!
    @IBOutlet weak var AlertButton: UIButton!
    @IBOutlet weak var TopicButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup View
        setupPopView()
        self.dropShadow(offSet: CGSize(width: 0, height: -24))
        self.dropShadow(offSet: CGSize(width: 0, height: 0))
        SetupButtons()
        
        // Show Keyborad
        TaskTitleTextView.becomeFirstResponder()
        
        // Setup View
        setupView()
       
        // Update View
        NotificationCenter.default.addObserver(self, selector: #selector(AddTaskPopViewController.updateView(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddTaskPopViewController.updateView(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)

    }
    
    func textViewDidChange(_  Tt: UITextView) {
        placeholderLabel.isHidden = !TaskTitleTextView.text.isEmpty
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
    
    //MARK: Private Methods

    private func setupPopView() {
        // Set cornerRadius
        let maskPath = UIBezierPath(roundedRect: PopView.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 12, height: 0))
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        PopView.layer.mask = maskLayer
    }
    
    
    //MARK: Setup View

    // Setup Shadow
    private func dropShadow(offSet: CGSize, scale: Bool = true) {
        PopView.layer.masksToBounds = false
        PopView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.40).cgColor
        PopView.layer.shadowOpacity = 1
        PopView.layer.shadowOffset = offSet
        PopView.layer.shadowRadius = 24
        
        PopView.layer.shadowPath = UIBezierPath(rect: PopView.bounds).cgPath
        PopView.layer.shouldRasterize = true
        PopView.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
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
    }
    
    // Setup View
    private func setupView() {
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

    
    // Update View
    @objc func updateView (notification: Notification) {
        // get keyboard's frame
        let userInfo = notification.userInfo!
        let keyboardEndFrameScreenCoordinates = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardEndFrame = self.view.convert(keyboardEndFrameScreenCoordinates, to: view.window)
        
        // change y when keyboard shows
        if notification.name == Notification.Name.UIKeyboardWillShow {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut , animations: {
                self.view.frame.origin.y -= keyboardEndFrame.height
            }, completion: nil)
        } else if notification.name == Notification.Name.UIKeyboardWillHide {
            self.view.frame.origin.y = 0
        }
    }
    
}


