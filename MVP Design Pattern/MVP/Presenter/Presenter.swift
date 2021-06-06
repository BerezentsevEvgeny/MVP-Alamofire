//
//  Presenter.swift
//  MVP Design Pattern
//
//  Created by Евгений Березенцев on 02.06.2021.
//

import Foundation
import UIKit
import Alamofire


protocol UserPresenterDelegate: AnyObject {
    func presentUsers(users: [User])
    func presentAlert(title: String, message: String)
}

typealias PresenterDelegate = UserPresenterDelegate & UIViewController

class UserPresenter {
    
    weak var  delegate: UserPresenterDelegate?
    
    public func setViewDelegate(delegate: PresenterDelegate ) {
        self.delegate = delegate
    }
    
    public func getUsers() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else { return }
        
        AF.request(url).responseData { response in
            guard let data = response.data, response.error == nil else { return }
            do {
                let users = try JSONDecoder().decode([User].self, from: data)
                self.delegate?.presentUsers(users: users)
            }
            catch {
                print(String(describing: response.error))
            }
        }
        
    }
    
    public func didTap(user: User) {
         delegate?.presentAlert(
            title: user.name,
            message: "\(user.name) has an email of \(user.email) & username of \(user.username)")
    }
    
}
