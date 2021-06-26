//
//  SignInPageViewController.swift
//  eCommunicationBook
//
//  Created by Ben Tee on 2021/6/1.
//  Copyright © 2021 TKY co. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import AuthenticationServices
import CryptoKit
import CollectionViewPagingLayout

class SignInPageViewController: UIViewController {
    
    var viewModel = SignInPageViewModel()

    let buttonAppleSignIn = ASAuthorizationAppleIDButton(type: .continue, style: .black)

    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var viewAppleSignIn: UIView!
    
    @IBOutlet weak var viewChoseRole: UIView!
        
    @IBOutlet weak var viewPolicyBlackView: UIView!

    @IBOutlet weak var middleConViewAppleSign: NSLayoutConstraint!
    
    @IBOutlet weak var middleConViewChooseRole: NSLayoutConstraint!
    
    @IBOutlet weak var centerYTextView: NSLayoutConstraint!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        configureViews()
        
        setupAppleButton()
        
        viewModel.onGotUserData = {
            
            self.toHomePage()
        }
        
        viewModel.onUserCreated = {
            
            self.shiftToViewChoseRole()
        }
        
        viewModel.onFailure = {
            
            BTProgressHUD.showFailure(text: "An error occurred")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if UserManager.shared.user.id != String.empty && UserManager.shared.user.userType == nil {
        
            viewModel.signInUser()
        }
    }
    
    @IBAction private func showPolicy(_ sender: Any) {
        
        self.viewPolicyBlackView.isHidden = false
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0, animations: {
        
            self.viewPolicyBlackView.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
            
            self.centerYTextView.constant = 0
            
        }, completion: nil)
    }
    
    @IBAction func closePolicy(_ sender: Any) {
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0, animations: {
        
            self.viewPolicyBlackView.backgroundColor = UIColor.gray.withAlphaComponent(0.0)
            
            self.centerYTextView.constant = 950
        
        }, completion: { (_) -> Void in
        
            self.viewPolicyBlackView.isHidden = true
        })
    }
    
    @IBAction func tempSkip(_ sender: Any) {
        
        shiftToViewChoseRole()
    }
    
    private func toHomePage() {
        
        if let nextVC = UIStoryboard.main.instantiateInitialViewController() {
            
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            
            appDelegate?.window?.rootViewController = nextVC
            
            BTProgressHUD.showSuccess(text: "Sign In Success")
            
        } else { return }
    }
    
    private func configureViews() {
        
        view.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1)
        
        view.clipsToBounds = true
        
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        
        collectionView.registerCellWithNib(identifier: UserTypeCollectionViewCell.identifier, bundle: nil)
        
        collectionView.isPagingEnabled = true
        
        collectionView.dataSource = self
        
        let layout = CollectionViewPagingLayout()
        
        layout.numberOfVisibleItems = 2
        
        collectionView.collectionViewLayout = layout
        
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.clipsToBounds = false
        
        collectionView.backgroundColor = .clear
    }
    
    func shiftToViewChoseRole() {
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, animations: {
        
            self.middleConViewAppleSign.constant = -450
            
            self.middleConViewChooseRole.constant = 0
        },
        
        completion: nil)
    }
    
    func setupAppleButton() {
        
        viewAppleSignIn.addSubview(buttonAppleSignIn)
        
        buttonAppleSignIn.cornerRadius = 12
        
        buttonAppleSignIn.addTarget(self, action: #selector(startSignInWithAppleFlow), for: .touchUpInside)
        
        buttonAppleSignIn.translatesAutoresizingMaskIntoConstraints = false
        
        buttonAppleSignIn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        buttonAppleSignIn.widthAnchor.constraint(equalToConstant: 235).isActive = true
        
        buttonAppleSignIn.centerXAnchor.constraint(equalTo: viewAppleSignIn.centerXAnchor).isActive = true
        
        buttonAppleSignIn.bottomAnchor.constraint(equalTo: viewAppleSignIn.bottomAnchor, constant: -120).isActive = true
        
        buttonAppleSignIn.layoutIfNeeded()
    }
    
    // Unhashed nonce.
    fileprivate var currentNonce: String?
    
    @available(iOS 13, *)
    @objc func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    
    private func randomNonceString(length: Int = 32) -> String {
        
        precondition(length > 0)
        
        let charset: [Character] =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        var result = String.empty
        
        var remainingLength = length
        
        while remainingLength > 0 {
        
            let randoms: [UInt8] = (0 ..< 16).map { _ in
            
                var random: UInt8 = 0
                
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                
                if errorCode != errSecSuccess {
                
                    assertionFailure("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                
                return random
            }
            
            randoms.forEach { random in
                
                if remainingLength == 0 {
                
                    return
                }
                
                if random < charset.count {
                    
                    result.append(charset[Int(random)])
                    
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
}

@available(iOS 13.0, *)

extension SignInPageViewController: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
    
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
        
            guard let nonce = currentNonce else {
            
                assertionFailure("Invalid state: A login callback was received, but no login request was sent.")
                
                return
            }
            
            guard let appleIDToken = appleIDCredential.identityToken else {
            
                print("Unable to fetch identity token")
                
                return
            }
            
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                
                return
            }
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            
            Auth.auth().signIn(with: credential) { (authResult, error) in
            
                if let error = error {
                    // Error. If error.code == .MissingOrInvalidNonce, make sure
                    // you're sending the SHA256-hashed nonce as a hex string with
                    // your request to Apple.
                    print(error.localizedDescription)
                    
                    return
                }
                
                guard let user = authResult?.user else { return }
                
                guard let uid = Auth.auth().currentUser?.uid else { return }
                
                UserManager.shared.user.id = uid
                
                UserManager.shared.user.email = user.email ?? String.empty
                
                UserManager.shared.user.userID = user.displayName ?? String.empty
                
                self.viewModel.signInUser()
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {

        print("Sign in with Apple errored: \(error)")
    }
}

extension SignInPageViewController: ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    
        return self.view.window!
    }
}

extension SignInPageViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewModel.userType.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: UserTypeCollectionViewCell.identifier,
                                     for: indexPath) as? UserTypeCollectionViewCell
        
        else {
            
            assertionFailure("UserTypeCollectionViewCell not found")
            
            return UICollectionGridViewCell()
            
        }
        
        cell.continueButton.addTarget(self, action: #selector(connected(sender:)), for: .touchUpInside)
        
        cell.continueButton.tag = indexPath.item
        
        cell.setUpCell(index: indexPath.item)
        //        cell.viewModel = itemViewModel
        return cell
    }
    
    @objc func connected(sender: UIButton) {
        
        if sender.tag == 1 {
            
            let controller = UIAlertController(title: "Redeem Code",
                                               message: "Enter your invitation code to continue.",
                                               preferredStyle: .alert)
            
            controller.addTextField { (textField) in
            
                textField.placeholder = "code"
                
                textField.keyboardType = .numberPad
            }
            
            let okAction = UIAlertAction(title: "ok", style: .default) { (_) in
            
                guard let code = controller.textFields?[0].text else {return}
                
                if code == "12369" {
                    
                    self.viewModel.onUserTypeChange(type: sender.tag)
                
                    self.viewModel.updateUserType()
                    
                } else {
                    
                    BTProgressHUD.showFailure(text: "Invalid invitation code")
                }
            }
            
            controller.addAction(okAction)
            
            let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
            
            controller.addAction(cancelAction)
            
            present(controller, animated: true, completion: nil)
            
        } else {
            
            self.viewModel.onUserTypeChange(type: sender.tag)
            
            self.viewModel.updateUserType()
        }
    }
}
