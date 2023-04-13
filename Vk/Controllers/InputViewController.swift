//
//  InputViewController.swift
//  Vk
//
//  Created by Табункин Вадим on 13.11.2022.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseFirestore
import FlagPhoneNumber


class InputViewController: UIViewController, UIGestureRecognizerDelegate {

    weak var coordinator: MainCoordinator?
    private var phoneNumber: String?
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

    private lazy var numberTextField = UIElementFactory().addNumberTextField(delegate: self)

    private lazy var numberListController = UIElementFactory().addListController(countryRepository: self.numberTextField.countryRepository,
                                                                                 title: "countries".localized)

    private lazy var confirmButtom = UIElementFactory().addBigButtom(lable: "confirm".localized,
                                                                     backgroundColor: .buttomColor) {
        guard let phoneNumber = self.phoneNumber else {return}
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
            if error != nil {
                print(error?.localizedDescription ?? "Error")
            } else {
                self.coordinator?.verificationVC(userNumber: self.numberTextField.text!, verificationID: verificationID, isRegistration: false)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        numberTextField.delegate = self
        setController()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboardOnSwipeDown))
        tap.delegate = self
        tap.numberOfTapsRequired = 1
        self.scrollView.addGestureRecognizer(tap)
        layout()
    }

    private func setController() {
        self.numberListController.didSelect = { country in
            self.numberTextField.setFlag(countryCode: country.code)
        }
        confirmButtom.alpha = 0.5
        confirmButtom.isEnabled = false
    }

    @objc func hideKeyboardOnSwipeDown() {
        view.endEditing(true)
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

extension InputViewController: FPNTextFieldDelegate{
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {

    }
    
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        if isValid {
            confirmButtom.alpha = 1
            confirmButtom.isEnabled = true
            phoneNumber = numberTextField.getFormattedPhoneNumber(format: .International)
        } else {
            confirmButtom.alpha = 0.5
            confirmButtom.isEnabled = false
        }
    }
    
    func fpnDisplayCountryList() {
        let nc = UINavigationController(rootViewController: numberListController)
        numberTextField.text = ""
        self.present(nc, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
