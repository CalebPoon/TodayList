//
//  AddTaskPopViewController.swift
//  TodayList
//
//  Created by hula3 on 2018/3/8.
//  Copyright © 2018年 hula3. All rights reserved.
//

import UIKit

class AddTaskPopViewController: UIViewController {
    //MARK: Properties
    @IBOutlet weak var AddConFirm: UIButton!
    @IBOutlet weak var PopView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupPopView()
        self.dropShadow(offSet: CGSize(width: 0, height: -24))
        self.dropShadow(offSet: CGSize(width: 0, height: 0))
        
        SetupButtons()
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
            self.dismiss(animated: true, completion: nil)
        }
    }

    
    //MARK: Private Methods

    private func setupPopView() {
        // Set cornerRadius
        let maskPath = UIBezierPath(roundedRect: PopView.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 12, height: 0))
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        PopView.layer.mask = maskLayer
    }
    
    // Setup Shadow
    
    private func dropShadow(offSet: CGSize, scale: Bool = true) {
        PopView.layer.masksToBounds = false
        PopView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.20).cgColor
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
}

