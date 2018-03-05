//
//  ViewController.swift
//  TodayList
//
//  Created by hula3 on 2018/3/2.
//  Copyright © 2018年 hula3. All rights reserved.
//

import UIKit

class TodayListViewController: UITableViewController {

    //MARK: Properties
    
    var tasks = [Task]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Custom Navigation Bar: LageTitle
        self.title = "今日"
        if #available(iOS 11, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        }
        
        // Custom Navigation Bar: appearance
        self.navigationController?.navigationBar.barTintColor = customColor.globalBackground
        self.navigationController?.navigationBar.shadowImage = UIImage()
        //self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        
        // Whole Background appearabce
        view.backgroundColor = customColor.globalBackground
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        // Load the sample data.
        loadSampleTask()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tasks.count
    }
    
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // able view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "TodayTaskCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TodayListTaskTableViewCell else {
            fatalError("The dequeued cell is not an instance of TodayListTaskTableViewCell.")
        }
     
        // Fetches the appropriate task for the data source layout.
        let task = tasks[indexPath.row]
        
        cell.TaskTitle.text = task.title
        cell.Checkbox.isChecked = task.isChecked

        return cell
     }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

    //MARK: Private Methods
    private func loadSampleTask() {
        guard let task1 = Task(title: "点击左侧方框完成任务", isChecked: false) else {
            fatalError("Unable to instantiate task1")
        }
        
        guard let task2 = Task(title: "点击右下角加号按钮添加任务", isChecked: false) else {
            fatalError("Unable to instantiate task2")
        }
        
        guard let task3 = Task(title: "点击任务标题编辑详情", isChecked: false) else {
            fatalError("Unable to instantiate task3")
        }
        
        tasks += [task1, task2, task3]
    }
}

