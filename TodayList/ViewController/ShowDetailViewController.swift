//
//  ShowDetailViewController.swift
//  TodayList
//
//  Created by hula3 on 2018/3/20.
//  Copyright © 2018年 hula3. All rights reserved.
//

import UIKit

class ShowDetailViewController: UIViewController, UITextViewDelegate {
    
    // MARK: - Properties
    // MARK: UI
    @IBOutlet weak var returnButton: UIBarButtonItem!
    @IBOutlet weak var hideKeyboardButton: UIBarButtonItem!
    
    @IBOutlet weak var checkbox: UIButton!
    @IBOutlet weak var titleTextView: UITextView!
    var titlePlaceholder = UILabel()
    
    @IBOutlet weak var remarkTextView: UITextView!
    var remarkPlaceholder =  UILabel()
    
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var alertButton: UIButton!
    @IBOutlet weak var topicButton: UIButton!
    
    @IBOutlet weak var moreButton: UIButton!
    
    // MARK: Model
    var task: Task!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        task = Task(title: "try", isChecked: false, date: Date())
        
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - TextView Delegate Methods
    func textViewDidChange(_ textView: UITextView) {
        // Placeholder
        titlePlaceholder.isHidden = !titleTextView.text.isEmpty
        remarkPlaceholder.isHidden = !remarkTextView.text.isEmpty
        
        // Line Space
        let titleStyle = NSMutableParagraphStyle()
        let remarkStyle = NSMutableParagraphStyle()
        
        titleStyle.lineSpacing = 8
        remarkStyle.lineSpacing = 4
        
        let titleAttributes = [NSAttributedStringKey.paragraphStyle: titleStyle, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20, weight: .medium) , NSAttributedStringKey.foregroundColor: customColor.Black1]
        if titleTextView.markedTextRange == nil {
            titleTextView.attributedText = NSAttributedString(string: titleTextView.text, attributes:titleAttributes)
        }
        
        let remarkAttributes = [NSAttributedStringKey.paragraphStyle: remarkStyle, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16), NSAttributedStringKey.foregroundColor: customColor.Black2]
        if remarkTextView.markedTextRange == nil {
            remarkTextView.attributedText = NSAttributedString(string: remarkTextView.text, attributes:remarkAttributes)
        }
    }
    
    // Disable newline in titleTextView
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            titleTextView.resignFirstResponder()
        }
        return true
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - Setup View
    
    func setupView() {
        // View Background
        view.backgroundColor = customColor.globalBackground
        
        // ---------------
        // returnButton
        
        returnButton.image = #imageLiteral(resourceName: "return")
        returnButton.tintColor = customColor.Black3
        returnButton.title = ""
        
        // LargeTitle
        if #available(iOS 11, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        }
        
        // Navigation Bar
        self.navigationController?.navigationBar.barTintColor = customColor.globalBackground
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        // ---------------
        // Content
        
        // checkbox
        checkbox.setImage(#imageLiteral(resourceName: "Checkmark_L"), for: .normal)
        checkbox.tintColor = customColor.Black3
        
        // Title
        titleTextView.delegate = self
        
        // TitlePlaceholder
        titlePlaceholder.text = "得给任务定个标题"
        titlePlaceholder.font = UIFont.systemFont(ofSize: 20)
        titlePlaceholder.textColor = customColor.Black3
        
        titlePlaceholder.sizeToFit()
        titleTextView.addSubview(titlePlaceholder)
        titlePlaceholder.frame.origin = CGPoint(x: 5, y: (titlePlaceholder.font?.pointSize)!/2 - 2)
        
        titlePlaceholder.isHidden = !titleTextView.text.isEmpty
        
        
        // Remark
        remarkTextView.delegate = self
        remarkTextView.text = task.remark
        
        // RemarkPlaceholder
        remarkPlaceholder.text = "添加备注"
        remarkPlaceholder.font = UIFont.systemFont(ofSize: 16)
        remarkPlaceholder.textColor = customColor.Black3
        
        remarkPlaceholder.sizeToFit()
        remarkTextView.addSubview(remarkPlaceholder)
        remarkPlaceholder.frame.origin = CGPoint(x: 5, y: (remarkPlaceholder.font?.pointSize)!/2)
        
        remarkPlaceholder.isHidden = !remarkTextView.text.isEmpty
        
        
        // Cursor Color
        titleTextView.tintColor = customColor.Blue_Background
        remarkTextView.tintColor = customColor.Blue_Background
        
        // Return Key
        titleTextView.returnKeyType = .done
        titleTextView.enablesReturnKeyAutomatically = true
        remarkTextView.enablesReturnKeyAutomatically = true
        
        
        // ---------------
        // Buttons
        
    }
}
