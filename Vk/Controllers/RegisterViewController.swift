//
//  RegisterViewController.swift
//  Vk
//
//  Created by Табункин Вадим on 12.11.2022.
//

import UIKit
import Firebase
import FlagPhoneNumber


class RegisterViewController: UIViewController {

    weak var coordinator: MainCoordinator?
    private var phoneNumber: String?
    private let scrollView: UIScrollView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIScrollView())

    private let registerLable = UIElementFactory().addBoldTextLable(lable: "startRegistration".localized,
                                                                    textColor: .textColor,
                                                                    textSize: 18,
                                                                    textAlignment: .center)

    private let headerLable = UIElementFactory().addMediumTextLable(lable: "enterTheNumber".localized,
                                                                    textColor: UIColor(red: 0.851, green: 0.851, blue: 0.851, alpha: 1),
                                                                    textSize: 16,
                                                                    lineHeightMultiple: 1.24,
                                                                    textAlignment: .center)

    private let explainLable = UIElementFactory().addMediumTextLable(lable: "explain".localized,
                                                                     textColor: UIColor(red: 0.495, green: 0.507, blue: 0.512, alpha: 1),
                                                                     textSize: 12,
                                                                     lineHeightMultiple: 1.03,
                                                                     textAlignment: .center)

    private lazy var numberTextField = UIElementFactory().addNumberTextField(delegate: self)

    private lazy var numberListController = UIElementFactory().addListController(countryRepository: self.numberTextField.countryRepository, title: "countries".localized)

    private lazy var nextButtom = UIElementFactory().addBigButtom(lable: "next".localized,
                                                                  backgroundColor: .buttomColor) {

        guard let phoneNumber = self.phoneNumber else {return}
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
            if error != nil {
                print(error?.localizedDescription ?? "Error")
            } else {
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                self.coordinator?.verificationVC(userNumber: self.numberTextField.text!, verificationID: verificationID, isRegistration: true)
            }
        }
    }

    private let aboutNextButtom = UIElementFactory().addMediumTextLable(lable: "aboutNextButtom".localized,
                                                                        textColor: UIColor(red: 0.495, green: 0.507, blue: 0.512, alpha: 1),
                                                                        textSize: 12,
                                                                        lineHeightMultiple: 1.03,
                                                                        textAlignment: .center)

    override func viewDidLoad() {
        super.viewDidLoad()
        numberTextField.delegate = self
        setController()
        layout()
    }

    private func setController() {
        self.numberListController.didSelect = { country in
            self.numberTextField.setFlag(countryCode: country.code)
        }
        nextButtom.alpha = 0.5
        nextButtom.isEnabled = false
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

        scrollView.addSubviews(registerLable, headerLable, explainLable, numberTextField, nextButtom, aboutNextButtom)

        NSLayoutConstraint.activate([
            registerLable.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -247),
            registerLable.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerLable.widthAnchor.constraint(equalToConstant: 223),
            registerLable.heightAnchor.constraint(equalToConstant: 22)
        ])

        NSLayoutConstraint.activate([
            headerLable.topAnchor.constraint(equalTo: registerLable.bottomAnchor, constant: 70),
            headerLable.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            headerLable.widthAnchor.constraint(equalToConstant: 123),
            headerLable.heightAnchor.constraint(equalToConstant: 24)
        ])

        NSLayoutConstraint.activate([
            explainLable.topAnchor.constraint(equalTo: headerLable.bottomAnchor, constant: 5),
            explainLable.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            explainLable.widthAnchor.constraint(equalToConstant: 215),
            explainLable.heightAnchor.constraint(equalToConstant: 30)
        ])

        NSLayoutConstraint.activate([
            numberTextField.topAnchor.constraint(equalTo: explainLable.bottomAnchor, constant: 30),
            numberTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            numberTextField.widthAnchor.constraint(equalToConstant: 260),
            numberTextField.heightAnchor.constraint(equalToConstant: 48)
        ])

        NSLayoutConstraint.activate([
            nextButtom.topAnchor.constraint(equalTo: numberTextField.bottomAnchor, constant: 70),
            nextButtom.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButtom.widthAnchor.constraint(equalToConstant: 120),
            nextButtom.heightAnchor.constraint(equalToConstant: 47)
        ])

        NSLayoutConstraint.activate([
            aboutNextButtom.topAnchor.constraint(equalTo: nextButtom.bottomAnchor, constant: 20),
            aboutNextButtom.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            aboutNextButtom.widthAnchor.constraint(equalToConstant: 258),
            aboutNextButtom.heightAnchor.constraint(equalToConstant: 45)
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

extension RegisterViewController: FPNTextFieldDelegate {
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
    }

    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        if isValid {
            nextButtom.alpha = 1
            nextButtom.isEnabled = true
            phoneNumber = numberTextField.getFormattedPhoneNumber(format: .International)
        } else {
            nextButtom.alpha = 0.5
            nextButtom.isEnabled = false
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
