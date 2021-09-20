//
//  RegistrationController.swift
//  UdemyTwitter
//
//  Created by Иван Романов on 13.09.2021.
//

import UIKit
import Firebase

class RegistrationController: UIViewController {
    
    // MARK:- Properties
    
    private var profileImage: UIImage?
    
    private lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        return picker
    } ()
    
    // MARK:- Subviews
    
    private let addPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus_photo"), for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 150 / 2
        button.layer.masksToBounds = true
        button.imageView?.contentMode = .scaleAspectFill
        button.imageView?.clipsToBounds = true
        
        button.layer.borderColor = UIColor.white.cgColor
        
        button.addTarget(self, action: #selector(handleAddProfilePhotoTap), for: .touchUpInside)
        
        return button
    } ()
    
    private lazy var emailContainerView: UIView = {
        let image = UIImage(named: "ic_mail_outline_white_2x-1")!
        let view = Utilities().inputContainerView(with: image, textField: self.emailTextField)
        return view
    } ()
    
    private lazy var passwordContainerView: UIView = {
        let image = UIImage(named: "ic_lock_outline_white_2x")!
        let view = Utilities().inputContainerView(with: image, textField: self.passwordTextField)
        return view
    } ()
    
    private lazy var fullnameContainerView: UIView = {
        let image = UIImage(named: "ic_person_outline_white_2x")!
        let view = Utilities().inputContainerView(with: image, textField: self.fullnameTextField)
        return view
    } ()
    
    private lazy var usernameContainerView: UIView = {
        let image = UIImage(named: "ic_person_outline_white_2x")!
        let view = Utilities().inputContainerView(with: image, textField: self.usernameTextField)
        return view
    } ()
    
    private let emailTextField: UITextField = {
        let tf = Utilities().loginTextField(withPlaceholder: "Email")
        return tf
    } ()
    
    private let passwordTextField: UITextField = {
        let tf = Utilities().loginTextField(withPlaceholder: "Password")
        tf.isSecureTextEntry = true
        return tf
    } ()
    
    private let fullnameTextField: UITextField = {
        let tf = Utilities().loginTextField(withPlaceholder: "Full Name")
        return tf
    } ()
    
    private let usernameTextField: UITextField = {
        let tf = Utilities().loginTextField(withPlaceholder: "Username")
        return tf
    } ()
    
    private let alreadyHaveAnAccountButton: UIButton = {
        let button = Utilities().attributedButton(textPart: "Already have an account?", activePart: " Log in")
        button.addTarget(self, action: #selector(handleShowLoginButtonTap), for: .touchUpInside)
        return button
    } ()
    
    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 5
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.addTarget(self, action: #selector(handleSignUpButtonTap), for: .touchUpInside)
        
        return button
    } ()
    
    // MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
    }
    
    // MARK:- Helpers
    private func configureUI() {
        self.view.backgroundColor = .twitterBlue
        
        // Setup Subviews
        self.view.addSubview(self.addPhotoButton)
        addPhotoButton.centerX(inView: self.view, topAnchor: self.view.safeAreaLayoutGuide.topAnchor, paddingTop: 16)
        addPhotoButton.setDimensions(width: 150, height: 150)
        
        let stackView = UIStackView(arrangedSubviews: [self.emailContainerView, passwordContainerView, fullnameContainerView, usernameContainerView, signUpButton])
        stackView.axis = .vertical
        // stackView.distribution = .fillEqually
        stackView.spacing = 10
        self.view.addSubview(stackView)
        stackView.anchor(top: self.addPhotoButton.bottomAnchor, left: self.view.leftAnchor, right: self.view.rightAnchor,
                         paddingTop: 5, paddingLeft: 20, paddingRight: 20)
        
        
        self.view.addSubview(self.alreadyHaveAnAccountButton)
        self.alreadyHaveAnAccountButton.anchor(left: view.leftAnchor, bottom: self.view.safeAreaLayoutGuide.bottomAnchor, right: self.view.rightAnchor,
            paddingLeft: 20, paddingBottom: 16, paddingRight: 20)
    }
    
    // MARK:- Actions
    
    @objc private func handleAddProfilePhotoTap() {
        present(self.imagePicker, animated: true, completion: nil)
    }
    
    @objc private func handleSignUpButtonTap() {
        
        guard
            let profileImage = self.profileImage,
            let email = self.emailTextField.text,
            let password = self.passwordTextField.text,
            let fullname = self.fullnameTextField.text,
            let username = self.usernameTextField.text
        else { return }
        
        let credentials = AuthCredentials(email: email, password: password, fullname: fullname, username: username, profileImage: profileImage)
        
        print("DB: about to request")
        AuthService.shared.registerUser(credentials: credentials) { (error, reference) in
            
            guard error == nil else {
                print("DB: Sign Up failed with error: \(error!.localizedDescription)")
                return
            }
            
            print("DB: Sign Up Successfull")
            
            guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow } ),
                  let mainTabVC = window.rootViewController as? MainTabController
            else { return }
            
            mainTabVC.checkAuthenticationAndConfigureUI()

            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc private func handleShowLoginButtonTap() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK:- UIImagePickerControllerDelegate

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let profileImage = (info[.editedImage] as? UIImage)?
                .withRenderingMode(.alwaysOriginal) else { return }
        
        self.profileImage = profileImage
        
        self.addPhotoButton.setImage(profileImage, for: .normal)
        
        addPhotoButton.layer.borderWidth = 3
        
        dismiss(animated: true, completion: nil)
    }
}
