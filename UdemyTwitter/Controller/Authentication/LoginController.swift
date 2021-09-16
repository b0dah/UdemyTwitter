//
//  LoginController.swift
//  UdemyTwitter
//
//  Created by Иван Романов on 13.09.2021.
//

import UIKit

class LoginController: UIViewController {
    
    // MARK:- Props
    
    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = UIImage(named: "TwitterLogo")
        
        return iv
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
    
    private let emailTextField: UITextField = {
        let tf = Utilities().loginTextField(withPlaceholder: "Email")
        return tf
    } ()
    
    private let passwordTextField: UITextField = {
        let tf = Utilities().loginTextField(withPlaceholder: "Password")
        tf.isSecureTextEntry = true
        return tf
    } ()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 5
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.addTarget(self, action: #selector(handleLoginButtonTap), for: .touchUpInside)
        
        return button
    } ()
    
    private let dontHaveAccountButton: UIButton = {
        let button = Utilities().attributedButton(textPart: "Don't have an account?", activePart: " Sign up")
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
        
        // Configure Appearence
        self.view.backgroundColor = .twitterBlue
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.barStyle = .black
        
        // Setup Subviews
        view.addSubview(self.logoImageView)
        self.logoImageView.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor)
        self.logoImageView.setDimensions(width: 100, height: 100)
        
        let stackView = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView, loginButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.anchor(top: logoImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
                         paddingLeft: 20, paddingRight: 20)
        
        self.view.addSubview(self.dontHaveAccountButton)
        self.dontHaveAccountButton.anchor(left: view.leftAnchor, bottom: self.view.safeAreaLayoutGuide.bottomAnchor, right: self.view.rightAnchor,
            paddingLeft: 20, paddingBottom: 16, paddingRight: 20)
    }
    
    // MARK:- Actions
    
    @objc private func handleLoginButtonTap() {
        
    }
    
    @objc private func handleSignUpButtonTap() {
        let controller = RegistrationController()
        navigationController?.pushViewController(controller, animated: true)
    }
}
