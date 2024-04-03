//
//  TaskListCell.swift
//  RealmApp
//
//  Created by Tatiana Lazarenko on 4/3/24.
//  Copyright © 2024 Alexey Efimov. All rights reserved.
//

import UIKit
import RealmSwift

class TaskListCell: UITableViewCell {

    @IBOutlet var doneImageView: UIImageView!
    
    @IBOutlet var countLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    
    private let storageManager = StorageManager.shared
    
    override func awakeFromNib() {
        super.awakeFromNib()
        doneImageView.isHidden = true
    }
    
    func configure(with taskList: TaskList) {
        titleLabel.text = taskList.title
        
        let count = getCount(taskList.tasks)
        
        if count == taskList.tasks.count {
            countLabel.isHidden = true
            doneImageView.image = UIImage(named: "checkmark")
            doneImageView.isHidden = false
        } else {
            countLabel.text = count.formatted()
        }
    }
    
    private func getCount(_ tasks: List<Task>) -> Int {
        return tasks.filter { $0.isComplete }.count
    }
}
