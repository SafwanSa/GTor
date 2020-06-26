//
//  CalcService.swift
//  GTor
//
//  Created by Safwan Saigh on 21/06/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import Foundation
import SwiftUI

class CalcService {
    
    static let shared = CalcService()
    
    
    func calcProgress(for goal: Goal) {
        var sum = 0.0
        var goalCopy = goal
        let subGoals = GoalService.shared.getSubGoals(mainGoal: goal)
        for subGoal in subGoals {
            sum+=subGoal.satisfaction
        }
        goalCopy.satisfaction = (sum / ( sum == 0 ? 1 : Double(subGoals.count)))
        GoalService.shared.saveGoal(goal: goalCopy) { result in
            switch result {
            case .failure(let error):
                fatalError(error.localizedDescription)
            case .success(()):
                print("Success")
            }
        }
    }
    
    func calcProgress(from task: Task){
        var linkedTasks: [Task] = []
        var sum = 0.0
        var subGoals = GoalService.shared.goals.filter {$0.isSubGoal}.filter {task.linkedGoalsIds.contains($0.id)}
        for i in 0..<subGoals.count {
            sum = 0.0
            linkedTasks = TaskService.shared.tasks.filter {$0.linkedGoalsIds.contains( subGoals[i].id)}
            for task in linkedTasks {
                sum+=task.satisfaction
            }
            subGoals[i].satisfaction = (sum / ( sum == 0 ? 1 : Double(linkedTasks.count)))
            GoalService.shared.saveGoal(goal: subGoals[i]) { result in
                switch result {
                case .failure(let error):
                    fatalError(error.localizedDescription)
                case .success(()):
                    for goal in GoalService.shared.goals.filter({!$0.isSubGoal}) {
                        CalcService.shared.calcProgress(for: goal)
                    }
                }
            }
        }
    }
    
    func calcImportance(from linkedGoalsIds: [UUID]) -> Importance{
        var sum = 0.0
        for subGoal in GoalService.shared.goals.filter({ linkedGoalsIds.contains($0.id) }){
            sum+=subGoal.importance.value
        }
        let importance = (sum / ( sum == 0 ? 1 : Double(linkedGoalsIds.count)))
        return getImportance(value: importance)
    }
    
    func calcImportance(for goal: Goal, completion: @escaping (Result<Goal, Error>)->()){
        var sum = 0.0
        var goalCopy = goal
        let subGoals = GoalService.shared.getSubGoals(mainGoal: goal)
        for subGoal in subGoals {
            sum+=subGoal.importance.value
        }
        print(sum, "sum")
        let importance = (sum / ( sum == 0 ? 1 : Double(subGoals.count)))
        goalCopy.importance = getImportance(value: importance)
        GoalService.shared.saveGoal(goal: goalCopy) { result in
            switch result {
            case .failure(let error):
                fatalError(error.localizedDescription)
            case .success(()):
                print("Success")
                completion(.success(goalCopy))
            }
        }
    }
    
    func getImportance(value: Double ) -> Importance {
        print(value, "Vlaue")
        if value <= 1.0 {
            return .notImportant
        }else if value > 1.0 && value <= 2.0 {
            return .important
        }else if value > 2.0 && value <= 3 {
            return .veryImportant
        }else {
            return .none
        }
    }
    
}
