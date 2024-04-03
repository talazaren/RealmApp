//
//  StorageManager.swift
//  RealmApp
//
//  Created by Alexey Efimov on 08.10.2021.
//  Copyright © 2021 Alexey Efimov. All rights reserved.
//

import Foundation
import RealmSwift

final class StorageManager {
    static let shared = StorageManager()
    
    private let realm: Realm
    
    private init() {
        do {
            realm = try Realm()
        } catch {
            fatalError("Failed to initialize Realm: \(error)")
        }
    }
    
    // MARK: - Task List
    func fetchData<T>(_ type: T.Type) -> Results<T> where T: RealmFetchable {
        realm.objects(T.self)
    }
    
    func save(_ taskLists: [TaskList]) {
        write {
            realm.add(taskLists)
        }
    }
    
    func save(_ taskList: String, completion: (TaskList) -> Void) {
        write {
            let taskList = TaskList(value: [taskList])
            realm.add(taskList)
            completion(taskList)
        }
    }
    
    func delete(_ taskList: TaskList) {
        write {
            realm.delete(taskList.tasks)
            realm.delete(taskList)
        }
    }
    
    
    func edit(_ taskList: TaskList, newValue: String) {
        write {
            taskList.title = newValue
        }
    }
    

    func done(_ taskList: TaskList) {
        write {
            for task in taskList.tasks{
                task.setValue(true, forKey: "isComplete")
            }
        }
    }
    
    func unDone(_ taskList: TaskList) {
        write {
            for task in taskList.tasks{
                task.setValue(false, forKey: "isComplete")
            }
        }
    }
    
    func sortByDate(_ taskLists: Results<TaskList>) -> [TaskList] {
        let sortedTaskLists = taskLists.sorted { $0.date > $1.date }
        return sortedTaskLists
    }
    
    func sortByAlphabet(_ taskLists: Results<TaskList>) -> [TaskList] {
        let sortedTaskLists = taskLists.sorted { $0.title.lowercased() < $1.title.lowercased() }
        return sortedTaskLists
    }

    // MARK: - Tasks
    func save(_ task: String, withNote note: String, to taskList: TaskList, completion: (Task) -> Void) {
        write {
            let task = Task(value: [task, note])
            taskList.tasks.append(task)
            completion(task)
        }
    }
    
    func deleteTask(_ task: Task) {
        write {
            realm.delete(task)
        }
    }
    
    func editTask(_ task: Task, taskTitle: String, taskNote: String) {
        write {
            task.title = taskTitle
            task.note = taskNote
        }
    }
    
    func doneTask(_ task: Task) {
        write {
            task.setValue(true, forKey: "isComplete")
        }
    }
    
    func undoneTask(_ task: Task) {
        write {
            task.setValue(false, forKey: "isComplete")
        }
    }
    
    private func write(completion: () -> Void) {
        do {
            try realm.write {
                completion()
            }
        } catch {
            print(error)
        }
    }
}
