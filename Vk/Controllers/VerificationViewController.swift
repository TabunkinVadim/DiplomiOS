//
//  VerificationViewController.swift
//  Vk
//
//  Created by Табункин Вадим on 12.11.2022.
// "verificationLable".localized

import UIKit
import FirebaseAuth
import Firebase


class VerificationViewController: UIViewController, UIGestureRecognizerDelegate  {

    weak var coordinator: MainCoordinator?
    private var isRegistration: Bool
    private let userNumber: String
    private let verificationID: String?

    private let scrollView: UIScrollView = {
        $0.toAutoLayout()
        return $0
    }(UIScrollView())

    private lazy var verificationLable = UIElementFactory().addBoldTextLable(lable: "verificationLable".localized,
                                                                             textColor: UIColor(red: 0.965, green: 0.592, blue: 0.027, alpha: 1),
                                                                             textSize: 18,
                                                                             textAlignment: .center)

    private lazy var explainLable = UIElementFactory().addRegularTextLable(lable: "explainLable".localized + "\n\(userNumber)",
                                                                           textColor: UIColor(red: 0.149, green: 0.196, blue: 0.22, alpha: 1),
                                                                           textSize: 14,
                                                                           lineHeightMultiple: 1.18,
                                                                           textAlignment: .center)

    private let enterCodeLable = UIElementFactory().addRegularTextLable(lable: "enterCodeLable".localized,
                                                                        textColor: UIColor(red: 0.495, green: 0.507, blue: 0.512, alpha: 1),
                                                                        textSize: 12,
                                                                        lineHeightMultiple: 1.03,
                                                                        textAlignment: .center)

    private lazy var codeTextField = UIElementFactory().addTextField(placeholdertext: "______", textAlignment: .center, delegate: self)

    private lazy var verificationButtom = UIElementFactory().addBigButtom(lable: "verification".localized, backgroundColor: .buttomColor) {

        guard let code = self.codeTextField.text else {return}
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: self.verificationID!, verificationCode: code)

        Auth.auth().signIn(with: credential) { _, error in
            if error != nil {
                self.coordinator?.errorAlert(title: "Error".localized, buttomTitle: "Ok", error: error, cancelAction: { _ in
                    self.codeTextField.text = ""
                })
            } else {
                guard let userAuth = Auth.auth().currentUser else  { return }
                let firestoreCoordinator = FirestoreCoordinator()
                firestoreCoordinator.getUser(userID: userAuth.uid) { user, error in
                    if error != nil {
                        if self.isRegistration {
                            firestoreCoordinator.writeUsersArray(userID: userAuth.uid)
                            firestoreCoordinator.writeUser(userID: userAuth.uid, user: User(userID: "0", nickname: "NickName",
                                                                                            fullName: "ФИО",
                                                                                            gender: "",
                                                                                            dateOfBirth: "",
                                                                                            city: "",
                                                                                            profession: "Профессия",
                                                                                            avatar: UIImage(named: "Avatar") ?? UIImage(),
                                                                                            status: "_____",
                                                                                            numberOfPhoto: 0,
                                                                                            numberOfPublications: 0,
                                                                                            numberOfScribes: 0,
                                                                                            numberOfSubscriptions: 0))
                            firestoreCoordinator.getUser(userID: userAuth.uid) { user, error in
                                self.coordinator?.tapBarVC(user: user!)
                            }
                        } else {
                            self.coordinator?.errorAlert(title: "Error".localized, buttomTitle: "Ok", error: error, cancelAction: { _ in
                                firestoreCoordinator.writeUsersArray(userID: userAuth.uid)
                                firestoreCoordinator.writeUser(userID: userAuth.uid, user: User(userID: "0", nickname: "NickName",
                                                                                                fullName: "ФИО",
                                                                                                gender: "",
                                                                                                dateOfBirth: "",
                                                                                                city: "",
                                                                                                profession: "Профессия",
                                                                                                avatar: UIImage(named: "Avatar") ?? UIImage(),
                                                                                                status: "_____",
                                                                                                numberOfPhoto: 0,
                                                                                                numberOfPublications: 0,
                                                                                                numberOfScribes: 0,
                                                                                                numberOfSubscriptions: 0))
                                firestoreCoordinator.getUser(userID: userAuth.uid) { user, error in
                                    self.coordinator?.tapBarVC(user: user!)
                                }
                            })
                        }
                    } else {
                        self.coordinator?.tapBarVC(user: user!)
                    }
                }
            }
        }
    }

    private let okImage = UIElementFactory().addImage(imageNamed: "okImage",
                                                      cornerRadius: 0,
                                                      borderWidth: 0,
                                                      borderColor: nil,
                                                      clipsToBounds: false,
                                                      contentMode: .scaleToFill,
                                                      tintColor: .none,
                                                      backgroundColor: .none)

    override func viewDidLoad() {
        super.viewDidLoad()
        codeTextField.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboardOnSwipeDown))
        tap.delegate = self
        tap.numberOfTapsRequired = 1
        self.scrollView.addGestureRecognizer(tap)
        layout()
    }

    init (userNumber: String, verificationID: String?, isRegistration: Bool) {
        self.isRegistration = isRegistration
        self.userNumber = userNumber
        if let verificationID = verificationID {
            self.verificationID = verificationID
        } else {
            self.verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
        }
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func hideKeyboardOnSwipeDown() {
        view.endEditing(true)
    }

    private func formatCode(code: String) -> String {
        let cleanCode = code.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let mask = "XXXXXX"

        var result = ""
        var index = cleanCode.startIndex
        for ch in mask where index < cleanCode.endIndex {
            if ch == "X" {
                result.append(cleanCode[index])
                index = cleanCode.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
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

        scrollView.addSubviews(verificationLable, explainLable, enterCodeLable, codeTextField, verificationButtom, okImage)

        NSLayoutConstraint.activate([
            verificationLable.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -247),
            verificationLable.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            verificationLable.widthAnchor.constraint(equalToConstant: 274),
            verificationLable.heightAnchor.constraint(equalToConstant: 22)
        ])

        NSLayoutConstraint.activate([
            explainLable.topAnchor.constraint(equalTo: verificationLable.bottomAnchor, constant: 12),
            explainLable.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            explainLable.widthAnchor.constraint(equalToConstant: 265),
            explainLable.heightAnchor.constraint(equalToConstant: 40)
        ])

        NSLayoutConstraint.activate([
            enterCodeLable.topAnchor.constraint(equalTo: explainLable.bottomAnchor, constant: 118),
            enterCodeLable.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -69),
            enterCodeLable.widthAnchor.constraint(equalToConstant: 121),
            enterCodeLable.heightAnchor.constraint(equalToConstant: 15)
        ])

        NSLayoutConstraint.activate([
            codeTextField.topAnchor.constraint(equalTo: enterCodeLable.bottomAnchor, constant: 5),
            codeTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            codeTextField.widthAnchor.constraint(equalToConstant: 260),
            codeTextField.heightAnchor.constraint(equalToConstant: 48)
        ])

        NSLayoutConstraint.activate([
            verificationButtom.topAnchor.constraint(equalTo: codeTextField.bottomAnchor, constant: 86),
            verificationButtom.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            verificationButtom.widthAnchor.constraint(equalToConstant: 261),
            verificationButtom.heightAnchor.constraint(equalToConstant: 47)
        ])

        NSLayoutConstraint.activate([
            okImage.topAnchor.constraint(equalTo: verificationButtom.bottomAnchor, constant: 43),
            okImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            okImage.widthAnchor.constraint(equalToConstant: 86),
            okImage.heightAnchor.constraint(equalToConstant: 100)
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

extension VerificationViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        textField.text = formatCode(code: newString)
        return false
    }
}
