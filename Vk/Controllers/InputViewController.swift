//
//  InputViewController.swift
//  Vk
//
//  Created by Табункин Вадим on 13.11.2022.
//

import UIKit
import Firebase
import FlagPhoneNumber

class InputViewController: UIViewController {

    weak var coordinator: MainCoordinator?
    
    private let scrollView: UIScrollView = {
        $0.toAutoLayout()
        return $0
    }(UIScrollView())

    private let inputLable = UIElementFactory().addBoldTextLable(lable: "inputLable".localized,
                                                                 textColor: UIColor(red: 0.965, green: 0.592, blue: 0.027, alpha: 1),
                                                                 textSize: 18,
                                                                 textAlignment: .center)

    private let explainLable = UIElementFactory().addRegularTextLable(lable: "explainInput".localized,
                                                                     textColor: UIColor(red: 0.149, green: 0.196, blue: 0.22, alpha: 1),
                                                                     textSize: 14,
                                                                     lineHeightMultiple: 1.18,
                                                                      textAlignment: .center)

    private let numberTextField = UIElementFactory().addTextField(placeholdertext: "+79__-___-__-__")

    private lazy var confirmButtom = UIElementFactory().addBigButtom(lable: "confirm".localized, backgroundColor: UISets().ButtomColor) {
        guard let phoneNumber = self.numberTextField.text else {return}
        if phoneNumber.count == 16 {
            FirebaseAuth.Auth.auth().signIn(withCustomToken: phoneNumber, completion: { result, error in
                if error != nil {
                    print(error?.localizedDescription ?? "Error")
                } else {
                    self.coordinator?.tapBarVC()
                }
            })
        } else {
            self.coordinator?.errorAlert(title: "Error".localized, error: NSError(domain: "Не верный номер телефона", code: 999999), cancelAction: { _ in
                self.numberTextField.text = ""
            })

            //            PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
            //                if error != nil {
            //                    print(error?.localizedDescription ?? "Error")
            //                } else {
            //                    self.coordinator?.verificationVC(userNumber: self.numberTextField.text!, verificationID: verificationID)
            //                }
            //            }
            //        } else {
            //            self.coordinator?.errorAlert(title: "Error".localized, error: NSError(domain: "Не верный номер телефона", code: 999999), cancelAction: { _ in
            //                self.numberTextField.text = ""
            //            })
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        numberTextField.delegate = self
        layout()
    }

    private func layout() {
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])

        scrollView.addSubviews(inputLable, explainLable, numberTextField, confirmButtom)

        NSLayoutConstraint.activate([
            inputLable.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -171),
            inputLable.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            inputLable.widthAnchor.constraint(equalToConstant: 156),
            inputLable.heightAnchor.constraint(equalToConstant: 22)
        ])

        NSLayoutConstraint.activate([
            explainLable.topAnchor.constraint(equalTo: inputLable.bottomAnchor, constant: 26),
            explainLable.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            explainLable.widthAnchor.constraint(equalToConstant: 179),
            explainLable.heightAnchor.constraint(equalToConstant: 40)
        ])

        NSLayoutConstraint.activate([
            numberTextField.topAnchor.constraint(equalTo: explainLable.bottomAnchor, constant: 12),
            numberTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            numberTextField.widthAnchor.constraint(equalToConstant: 260),
            numberTextField.heightAnchor.constraint(equalToConstant: 48)
        ])

        NSLayoutConstraint.activate([
            confirmButtom.topAnchor.constraint(equalTo: numberTextField.bottomAnchor, constant: 148),
            confirmButtom.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmButtom.widthAnchor.constraint(equalToConstant: 188),
            confirmButtom.heightAnchor.constraint(equalToConstant: 47)
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // подписаться на уведомления
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(kbdShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        nc.addObserver(self, selector: #selector(kbdHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // отписаться от уведомлений
        let nc = NotificationCenter.default
        nc.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        nc.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // Изменение отступов при появлении клавиатуры
    @objc private func kbdShow(notification: NSNotification) {
        if let kbdSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.contentInset.bottom = kbdSize.height
            scrollView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbdSize.height, right: 0) }
    }

    @objc private func kbdHide(notification: NSNotification) {
        scrollView.contentInset.bottom = .zero
        scrollView.verticalScrollIndicatorInsets = .zero
    }
}

extension InputViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//         textField.text
        view.endEditing(true)
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField == numberTextField) {            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let components = newString.components(separatedBy: NSCharacterSet.decimalDigits.inverted)

            let decimalString = components.joined(separator: "") as NSString
            let length = decimalString.length
            let hasLeadingOne = length > 0 && decimalString.hasPrefix("7") || length > 0 && decimalString.hasPrefix("8")

            if length == 0 || (length > 10 && !hasLeadingOne) || length > 11 {
                let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int

                return (newLength > 10) ? false : true
            }
            var index = 0 as Int
            let formattedString = NSMutableString()

            if hasLeadingOne {
                formattedString.append("+7 ")
                index += 1
            }

            if (length - index) > 3 {
                let areaCode = decimalString.substring(with: NSMakeRange(index, 3))
                formattedString.appendFormat("(%@)", areaCode)
                index += 3
            }

            if length - index > 3 {
                let prefix = decimalString.substring(with: NSMakeRange(index, 3))
                formattedString.appendFormat("%@-", prefix)
                index += 3
            }

            let remainder = decimalString.substring(from: index)
            formattedString.append(remainder)
            textField.text = formattedString as String
            return false
        }
        else {
            return true
        }
    }
}

