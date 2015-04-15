//
//  LoginViewController.swift
//  LiveSwiftChat
//
//  Created by Charles Konkol on 4/14/15.
//  Copyright (c) 2015 Rock Valley College. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var btnSignUp: UIButton!
    
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    @IBAction func btnSignUp(sender: UIButton) {
        let user = PFUser()
        user.username = username.text
        user.password = password.text
        user.email = email.text
        user["friends"] = "yes"
        // other fields can be set if you want to save more information
       // user["phone"] = "650-555-0000"
        
        user.signUpInBackgroundWithBlock { (success: Bool, error: NSError!) -> Void in
            if error == nil {
                // Hooray! Let them use the app now.
            } else {
                // Examine the error object and inform the user.
            }
        }
    }
    
    
    @IBAction func btnSignIn(sender: UIButton) {
        PFUser.logInWithUsernameInBackground(username.text, password:password.text) {
            (user: PFUser!, error: NSError!) -> Void in
            if user != nil {
                currentUser = PFUser.currentUser()
               self.home()
            } else {
                // The login failed. Check error to see why.
            }
        }
    }
    func home(){
        var vc = self.storyboard?.instantiateViewControllerWithIdentifier("chatnav") as NavViewController
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        currentUser = PFUser.currentUser()
        if currentUser != nil
        {
              timer = NSTimer.scheduledTimerWithTimeInterval(0, target:self, selector: Selector("home"), userInfo: nil, repeats: false)
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
