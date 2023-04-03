//
//  EditProfileViewController.swift
//  Vk
//
//  Created by Табункин Вадим on 17.01.2023.
//

import UIKit
import FirebaseAuth
import Firebase


class EditProfileViewController: UIViewController, UIGestureRecognizerDelegate {

    weak var coordinator: ProfileCoordinator?
    private var user: User

    private let scrollView: UIScrollView = {
        $0.toAutoLayout()
        return $0
    }(UIScrollView())

    private lazy var avatarButtom = UIElementFactory().addImageButton(image: user.avatar,
                                                                      cornerRadius: 50,
                                                                      borderWidth: 1,
                                                                      borderColor: UIColor.appOrange.cgColor) {
        let photoPicer: UIImagePickerController = {
            $0.delegate = self
            return $0
        }(UIImagePickerController())
        self.present(photoPicer, animated: true, completion: nil)
    }

    private lazy var nikNameTextField = UIElementFactory().addTextField(placeholdertext: "Nikname",
                                                                        textAlignment: .left,
                                                                        delegate: self)

    private let editFullName = UIElementFactory().addMediumTextLable(lable: "editName".localized,
                                                                     textColor: .textColor,
                                                                     textSize: 12,
                                                                     lineHeightMultiple: 1.03,
                                                                     textAlignment: .left)

    private lazy var editFullNameTextField = UIElementFactory().addTextField(placeholdertext: "editName".localized,
                                                                             textAlignment: .left,
                                                                             delegate: self)

    private let editProfession = UIElementFactory().addMediumTextLable(lable: "profession".localized,
                                                                       textColor: .textColor,
                                                                       textSize: 12,
                                                                       lineHeightMultiple: 1.03,
                                                                       textAlignment: .left)

    private lazy var editProfessionTextField = UIElementFactory().addTextField(placeholdertext: "profession".localized,
                                                                               textAlignment: .left,
                                                                               delegate: self)

    private let genderLable = UIElementFactory().addMediumTextLable(lable: "gender".localized,
                                                                    textColor: .textColor,
                                                                    textSize: 12,
                                                                    lineHeightMultiple: 1.03,
                                                                    textAlignment: .left)

    private lazy var maleCheck = UIElementFactory().addChecker(isCheck: false,
                                                               onColor: UIColor.appOrange.cgColor,
                                                               offColor: UIColor.appGrey.cgColor,
                                                               scaleImage: 0.5,
                                                               cornerRadius: 8) {
        print("Check male")
        self.user.gender = "Male".localized
    } offAction: {
        print("UN Check male")
    }

    private let maleLable = UIElementFactory().addMediumTextLable(lable: "Male".localized,
                                                                  textColor: .textColor,
                                                                  textSize: 14,
                                                                  lineHeightMultiple: 1.18,
                                                                  textAlignment: .left)

    private lazy var femaleCheck = UIElementFactory().addChecker(isCheck: false,
                                                                 onColor: UIColor.appOrange.cgColor,
                                                                 offColor: UIColor.appGrey.cgColor,
                                                                 scaleImage: 0.5,
                                                                 cornerRadius: 8) {
        print("Check female")
        self.user.gender = "Female".localized
    } offAction: {
        print("UN Check female")
    }

    private let femaleLable = UIElementFactory().addMediumTextLable(lable: "Female".localized,
                                                                    textColor: .textColor,
                                                                    textSize: 14,
                                                                    lineHeightMultiple: 1.18,
                                                                    textAlignment: .left)

    private let dateOfBirth = UIElementFactory().addMediumTextLable(lable: "dataOfBrith".localized,
                                                                    textColor: .textColor,
                                                                    textSize: 12,
                                                                    lineHeightMultiple: 1.03,
                                                                    textAlignment: .left)

    private lazy var dateOfBirthTextField = UIElementFactory().addTextField(placeholdertext: "01.01.2000",
                                                                            textAlignment: .left,
                                                                            delegate: self)

    private let cityLable = UIElementFactory().addMediumTextLable(lable: "city".localized,
                                                                  textColor: .textColor,
                                                                  textSize: 12,
                                                                  lineHeightMultiple: 1.03,
                                                                  textAlignment: .left)

    private lazy var cityTextField = UIElementFactory().addTextField(placeholdertext: "cityName".localized,
                                                                     textAlignment: .left,
                                                                     delegate: self)

    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
        self.nikNameTextField.text = user.nickName
        self.editFullNameTextField.text = user.fullName
        self.editProfessionTextField.text = user.profession
        if self.user.gender == "Male".localized {
            self.maleCheck.isSelected = true
        } else {
            self.femaleCheck.isSelected = true

        }
        self.dateOfBirthTextField.text = user.dateOfBirth
        self.cityTextField.text = user.city
        maleCheck.alternateButton = [femaleCheck]
        femaleCheck.alternateButton = [maleCheck]
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "basicInformation".localized
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: UIElementFactory().addIconButtom(icon: UIImage(systemName: "checkmark") ?? UIImage(),
                                                                                                         color: .appOrange,
                                                                                                         cornerRadius: 0) {
            self.user.nickName = self.nikNameTextField.text!
            self.user.fullName = self.editFullNameTextField.text!
            self.user.profession = self.editProfessionTextField.text!
            self.user.dateOfBirth = self.dateOfBirthTextField.text!
            self.user.city = self.cityTextField.text!
            self.user.avatar = self.avatarButtom.image(for: .normal) ?? UIImage(named: "Avatar")!
            guard let userAuth = Auth.auth().currentUser else  { return }
            let firestoreCoordinator = FirestoreCoordinator()
            firestoreCoordinator.writeUser(userID: userAuth.uid, user: self.user)
            self.coordinator?.pop()
        })
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: UIElementFactory().addIconButtom(icon: UIImage(systemName: "xmark") ?? UIImage(),
                                                                                                             color: .appOrange,
                                                                                                             cornerRadius: 0) {
            self.coordinator?.pop()
        })
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboardOnSwipeDown))
        tap.delegate = self
        tap.numberOfTapsRequired = 1
        self.scrollView.addGestureRecognizer(tap)
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

        scrollView.addSubviews(avatarButtom, nikNameTextField, editFullName, editFullNameTextField, editProfession, editProfessionTextField, genderLable, maleCheck, maleLable, femaleCheck, femaleLable, dateOfBirth, dateOfBirthTextField, cityLable, cityTextField)

        NSLayoutConstraint.activate([
            avatarButtom.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            avatarButtom.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarButtom.widthAnchor.constraint(equalToConstant: 100),
            avatarButtom.heightAnchor.constraint(equalToConstant: 100)
        ])

        NSLayoutConstraint.activate([
            nikNameTextField.topAnchor.constraint(equalTo: avatarButtom.bottomAnchor, constant: 29),
            nikNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            nikNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nikNameTextField.heightAnchor.constraint(equalToConstant: 40)
        ])

        NSLayoutConstraint.activate([
            editFullName.topAnchor.constraint(equalTo: nikNameTextField.bottomAnchor, constant: 14),
            editFullName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            editFullName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            editFullName.heightAnchor.constraint(equalToConstant: 15)
        ])

        NSLayoutConstraint.activate([
            editFullNameTextField.topAnchor.constraint(equalTo: editFullName.bottomAnchor, constant: 6),
            editFullNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            editFullNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            editFullNameTextField.heightAnchor.constraint(equalToConstant: 40)
        ])

        NSLayoutConstraint.activate([
            editProfession.topAnchor.constraint(equalTo: editFullNameTextField.bottomAnchor, constant: 14),
            editProfession.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            editProfession.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            editProfession.heightAnchor.constraint(equalToConstant: 15)
        ])

        NSLayoutConstraint.activate([
            editProfessionTextField.topAnchor.constraint(equalTo: editProfession.bottomAnchor, constant: 6),
            editProfessionTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            editProfessionTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            editProfessionTextField.heightAnchor.constraint(equalToConstant: 40)
        ])

        NSLayoutConstraint.activate([
            genderLable.topAnchor.constraint(equalTo: editProfessionTextField.bottomAnchor, constant: 14),
            genderLable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            genderLable.widthAnchor.constraint(equalToConstant: 50 ),
            genderLable.heightAnchor.constraint(equalToConstant: 15 )
        ])

        NSLayoutConstraint.activate([
            maleCheck.topAnchor.constraint(equalTo: genderLable.bottomAnchor, constant: 11),
            maleCheck.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            maleCheck.widthAnchor.constraint(equalToConstant: 16 ),
            maleCheck.heightAnchor.constraint(equalToConstant: 16 )
        ])

        NSLayoutConstraint.activate([
            maleLable.topAnchor.constraint(equalTo: genderLable.bottomAnchor, constant: 9),
            maleLable.leadingAnchor.constraint(equalTo: maleCheck.trailingAnchor, constant: 14),
            maleLable.widthAnchor.constraint(equalToConstant: 70 ),
            maleLable.heightAnchor.constraint(equalToConstant: 20 )
        ])

        NSLayoutConstraint.activate([
            femaleCheck.topAnchor.constraint(equalTo: maleCheck.bottomAnchor, constant: 16),
            femaleCheck.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            femaleCheck.widthAnchor.constraint(equalToConstant: 16 ),
            femaleCheck.heightAnchor.constraint(equalToConstant: 16 )
        ])

        NSLayoutConstraint.activate([
            femaleLable.topAnchor.constraint(equalTo: maleCheck.bottomAnchor, constant: 12),
            femaleLable.leadingAnchor.constraint(equalTo: femaleCheck.trailingAnchor, constant: 14),
            femaleLable.widthAnchor.constraint(equalToConstant: 70 ),
            femaleLable.heightAnchor.constraint(equalToConstant: 20 )
        ])

        NSLayoutConstraint.activate([
            dateOfBirth.topAnchor.constraint(equalTo: femaleCheck.bottomAnchor, constant: 34),
            dateOfBirth.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            dateOfBirth.widthAnchor.constraint(equalToConstant: 200 ),
            dateOfBirth.heightAnchor.constraint(equalToConstant: 15 )
        ])

        NSLayoutConstraint.activate([
            dateOfBirthTextField.topAnchor.constraint(equalTo: dateOfBirth.bottomAnchor, constant: 6),
            dateOfBirthTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            dateOfBirthTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            dateOfBirthTextField.heightAnchor.constraint(equalToConstant: 40)
        ])

        NSLayoutConstraint.activate([
            cityLable.topAnchor.constraint(equalTo: dateOfBirthTextField.bottomAnchor, constant: 15),
            cityLable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            cityLable.widthAnchor.constraint(equalToConstant: 90 ),
            cityLable.heightAnchor.constraint(equalToConstant: 15 )
        ])

        NSLayoutConstraint.activate([
            cityTextField.topAnchor.constraint(equalTo: cityLable.bottomAnchor, constant: 6),
            cityTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            cityTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            cityTextField.heightAnchor.constraint(equalToConstant: 40),
            cityTextField.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor )
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

    @objc func hideKeyboardOnSwipeDown() {
        view.endEditing(true)
    }

    // Изменение отступов при появлении клавиатуры
    @objc private func kbdShow(notification: NSNotification) {
        let screenHeit = UIScreen.main.bounds.height
        let cityHeit = self.cityTextField.frame.maxY
        if let kbdSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let offset = (screenHeit - kbdSize.height) - cityHeit
            if editProfessionTextField.isFirstResponder || cityTextField.isFirstResponder || dateOfBirthTextField.isFirstResponder, offset < 0 {
                self.scrollView.setContentOffset(CGPoint(x: 0, y: -offset + 100), animated: true)
            }
            scrollView.contentInset.bottom = kbdSize.height
            scrollView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbdSize.height, right: 0)
        }
    }

    @objc private func kbdHide(notification: NSNotification) {
        scrollView.contentInset.bottom = .zero
        scrollView.verticalScrollIndicatorInsets = .zero
    }
}

extension EditProfileViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}

extension EditProfileViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            avatarButtom.setImage(image, for: .normal)
        }
        dismiss(animated: true, completion: nil)
    }
}
