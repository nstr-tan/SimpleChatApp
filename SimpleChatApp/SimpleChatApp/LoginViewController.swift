//
//  ViewController.swift
//  SimpleChatApp
//
//  Created by Nestor Angelo Tan on 13/04/2017.
//  Copyright © 2017 NTan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var user = User()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Change the textfield styles
        self.userNameTextField.styleTextField()
        self.passwordTextField.styleTextField()
        
        self.loginButton.layer.cornerRadius = 5
       
        
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard))
        
        self.view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.activityIndicator.stopAnimating()
        self.loginButton.isEnabled = true
        
        self.userNameTextField.text = ""
        self.passwordTextField.text = ""
        
    }
    @IBAction func loginButtonPressed() {
        
        let username = self.userNameTextField.text
        let password = self.passwordTextField.text
        
        self.activityIndicator.startAnimating()
        
        self.view.endEditing(true)
        self.loginButton.isEnabled = false
        self.loginUser(user: user, username: username!, password: password!)
        
        
    }
    // MARK: - Custom Methods
    func registerUser(user: User, username: String, password: String) {
        
        // register user then login to get token
        user.register(username: username, password: password) { (success, message) in
            
            if success {
                self.loginUser(user: user, username: username, password: password)
                self.loginButton.isEnabled = true
            } else {
                
                // show error
                self.showAlertDialog(title: "Login Error", message: message)
                
            }
        }
        
    }
    
    func loginUser(user: User, username: String, password: String) {
        
        user.login(username: username, password: password) { (success, message) in
            
            if success {
                
                // proceed to next view
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "ShowChatVC", sender: self)
                }
            } else {
                
                // determine error message
                if message == "Invalid username." {
                    
                    // register user
                    self.registerUser(user: user, username: username, password: password)
                    
                } else {
                    
                    // show error
                    self.showAlertDialog(title: "Login Error", message: message)
                    
                }
            }
        }
    }
    
    // MARK: - Utility
    
    func showAlertDialog(title: String, message: String) {
        
        // UI Changes must be in main thread
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true) {
                
                self.activityIndicator.stopAnimating()
                self.loginButton.isEnabled = true
                
            }
        }
    
    }
    
    func dismissKeyboard()
    {
        self.view.endEditing(true)
    }

    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "ShowChatVC" {
            let viewcontroller = segue.destination as! ChatViewController
            
            viewcontroller.currentUser = self.user
            
        }
        
    }

}



// For custom textfield styling
// UITextFieldBorderStyleNone
extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    func styleTextField() {
        
        
        self.setLeftPaddingPoints(10)
        self.setRightPaddingPoints(10)
        self.layer.cornerRadius = 6
        self.backgroundColor = UIColor.init(colorLiteralRed: 244.0/255.0, green: 247.0/255.0, blue: 249.0/255.0, alpha: 1.0)
    }
}
