//
//  User.swift
//  retoCP
//
//  Created by Renzo Paul Chamorro on 18/07/21.
//

import Foundation
class User {
    static let sharedInstance = User()
    
    private static var userData: UserModel = UserModel(email: "", name: "", fullName: "", avatarUrl: "")
    let defaults = UserDefaults.standard
    
    public func saveUserData(model: UserModel) {
        defaults.setValue(model.email, forKey: "user_email")
        defaults.setValue(model.name, forKey: "user_name")
        defaults.setValue(model.fullName, forKey: "user_fullName")
        defaults.setValue(model.avatarUrl, forKey: "user_avatarUrl")
        saveUser(model: model)
    }
    
    public func recoverUserData() -> UserModel {
        let email = defaults.string(forKey: "user_email") ?? ""
        let name = defaults.string(forKey: "user_name") ?? ""
        let fullName = defaults.string(forKey: "user_fullName") ?? ""
        let avatarUrl = defaults.string(forKey: "user_avatarUrl") ?? ""

        return UserModel(email: email, name: name, fullName: fullName, avatarUrl: avatarUrl)
    }
    
    private func saveUser(model: UserModel) {
        User.userData = model
    }
    
    public func deleteUserData() {
        deleteUser()
        defaults.setValue("", forKey: "user_email")
        defaults.setValue("", forKey: "user_name")
        defaults.setValue("", forKey: "user_fullName")
        defaults.setValue("", forKey: "user_avatarUrl")
    }
    
    private func deleteUser() {
        User.userData = UserModel(email: "", name: "", fullName: "", avatarUrl: "")
    }
}

public struct UserModel {
    let email: String
    let name: String
    let fullName: String
    let avatarUrl: String
}
