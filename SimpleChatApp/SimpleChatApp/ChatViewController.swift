//
//  ChatViewController.swift
//  SimpleChatApp
//
//  Created by Nestor Angelo Tan on 16/04/2017.
//  Copyright © 2017 NTan. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITableViewDataSource, UITextFieldDelegate {

    var chatSocket: ChatSocket?
    var currentUser: User?
    var messageArray: Array<Message> = []
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet weak var messageTextField: UITextField!
   
     @IBOutlet weak var logoutButton: UIButton!
     @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard))
        
        self.view.addGestureRecognizer(tap)

        // get stored token
        var token = KeychainService.loadToken()
        
        if token == nil {
            token = ""
        }
        
        // connect socket
        self.chatSocket = ChatSocket(token: token! as String)
        
        self.activityIndicator.startAnimating()
        self.sendButton.isEnabled = false
        self.messageTextField.isEnabled = false
        self.chatSocket?.connect {
            
            // listen
            self.chatSocket?.listenMessages(completion: { (messageArray) in
                
                self.addMessages(messageArray: messageArray)
            })
        }
        
        // register tableview cells
        self.tableView.register(UINib(nibName:"YouMessageTableViewCell", bundle: nil), forCellReuseIdentifier: "YouMessageTableViewCell")
        self.tableView.register(UINib(nibName:"MeMessageTableViewCell", bundle: nil), forCellReuseIdentifier: "MeMessageTableViewCell")
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 45 // or something
        self.tableView.dataSource = self
        
        // register keyboard listener
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.messageTextField.delegate = self
        self.messageTextField.styleTextField()
        
        self.logoutButton.layer.cornerRadius = 5
        self.sendButton.layer.cornerRadius = 5
        
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func logoutButtonPressed() {
        
        if self.chatSocket != nil {
            
            // disconnect socket
            self.chatSocket?.disconnect()
            
            // remove token
            KeychainService.removeToken()
            
            // close view
            if(self.navigationController != nil) {
                self.navigationController!.popViewController(animated: true)
            }
        }
    }

    
    // MARK: - Chat
    func addMessages(messageArray: Array<Message>) {
        // add arrays
        self.messageArray.append(contentsOf: messageArray)
        
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.tableView.reloadData()
            
            self.sendButton.isEnabled = true
            self.messageTextField.isEnabled = true
            
            if(self.messageArray.count > 0) {
                let indexPath = IndexPath(row: self.messageArray.count - 1, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }
        }
    }
    
    
    @IBAction func sendMessage() {
        
        if self.chatSocket != nil {
            
            self.chatSocket?.sendMessage(messageString: self.messageTextField.text!)
            self.messageTextField.text = ""
            
        }
    }
    
    
    // MARK: - Keyboard
    func dismissKeyboard()
    {
        self.view.endEditing(true)
    }
    func keyboardWillShow(notification:NSNotification){
        
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 10
        self.scrollView.contentInset = contentInset
    }

    func keyboardWillHide(notification:NSNotification){
        
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInset
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        
        self.sendMessage()
        
        return true
    }
}

// MARK: - UICollectionViewDataSource
extension ChatViewController {
    // MARK: UITableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messageArray.count
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = self.messageArray[indexPath.row]
        
        if(message.userId == self.currentUser?.id) {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "MeMessageTableViewCell", for: indexPath ) as! MeMessageTableViewCell
            
            cell.messageTextView.text = message.content
            
            return cell
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "YouMessageTableViewCell", for: indexPath ) as! YouMessageTableViewCell
            
            cell.messageTextView.text = message.content
            cell.usernameLabel.text = message.username
            
            return cell
        }
    }
}
