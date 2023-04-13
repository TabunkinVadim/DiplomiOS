//
//  Protocols.swift
//  Vk
//
//  Created by Табункин Вадим on 31.05.2022.
//

import Foundation
import UIKit

protocol ProfileViewControllerProtocol: AnyObject {
    func editProfile ()
    func infoProfile ()
    func moreProfile ()
}

protocol ProfileHeaderActivityProtocol: AnyObject {
    func newEntry ()
    func newHistory()
    func newPhoto ()
}

protocol PostProtocol: AnyObject {
    func openProfile (userID: String)
    func liked (userID: String, postIndex: Int)
}

protocol LogInViewControllerProtocol: AnyObject {
    func showAlert (title: String, massege: String, action:@escaping (UIAlertAction)-> Void)
}
