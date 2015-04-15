//
//  ChatViewController.swift
//  ParseStarterProject
//
//  Created by Charles Konkol on 4/14/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
 var newImageData:NSData?
    var selPic:UIImage!
    var ID:String!
     var UID:String!
    
    @IBOutlet weak var msg: UITextField!
    
    @IBOutlet weak var messagestream: UITextView!
    @IBOutlet weak var msgs: UITextField!
    @IBAction func btnSubmit(sender: UIButton) {
        if msgs.text != nil
        {
            println("what:  " + msgs.text)
            let date = NSDate()
            let formatter = NSDateFormatter()
            formatter.timeStyle = .ShortStyle
            formatter.stringFromDate(date)
            //self.UID
            var userMsg = PFObject(className:"msg")
            userMsg["user"] = PFUser.currentUser()
            userMsg["id"] = ID
             userMsg["username"] = self.UID
            userMsg["message"] = msgs.text
            userMsg["date"] = date
            userMsg.saveInBackground()
            msgs.text = ""
        }
        else
        {
            let alertController = UIAlertController(title: "Fields Required", message:
                "Message Required", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
       
    }
    
    @IBOutlet weak var comments: UITextView!
    
    
    var photos: Array<AnyObject>?
    
    
    @IBOutlet weak var btnGetImages: UIButton!
    
    @IBOutlet weak var addGroup: UITextField!
    
    @IBOutlet weak var tableView: UITableView!  //<<-- TableView Outlet
    
    @IBOutlet weak var txtitle: UITextField!
    
    @IBOutlet weak var txtdesc: UITextField!
    
    @IBOutlet weak var images: UIImageView!
    
    @IBAction func btnGetImage(sender: UIButton) {
        var t:String = txtitle.text
        var d:String = txtdesc.text
        if t != "" && d != ""
        {
           if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
            println("Get Photo")
            var imag = UIImagePickerController()
            imag.delegate = self
            imag.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            //imag.mediaTypes = [kUTTypeImage];
            imag.allowsEditing = false
            self.presentViewController(imag, animated: true, completion: nil)
        }
        }
         else
           {
            let alertController = UIAlertController(title: "Fields Required", message:
                "Title and Description Required", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            }
   
        

    }
    func loaddata()
    {
        //get ID
       
        var query = PFQuery(className:"msg")
       query.whereKey("id", equalTo:ID)
        query.findObjectsInBackgroundWithBlock{
            (objects: [AnyObject]!, error: NSError!) -> Void in
            self.messagestream.text = ""
            for msgss in objects {
                // This does not require a network access.
              //  var date:String = String(msgss.objectForKey("date") as NSDate)
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "MM/dd/yyyy hh:mm:ss"
                dateFormatter.timeZone = NSTimeZone()
                var date = dateFormatter.stringFromDate(msgss.objectForKey("date") as NSDate)
                var fname:String = msgss.objectForKey("username") as String
                var msgsss:String = msgss.objectForKey("message") as String
              //  println("retrieved related post: \(post)")
                self.messagestream.text = self.messagestream.text + "\(fname) said at \(date) \n " + "  \(msgsss)\n -------------------------- \n"
            }
            let selectedRange = self.messagestream.selectedRange
            self.messagestream.scrollRangeToVisible(selectedRange)
        }
      
    }
//    func textViewDidEndEditing(textView: UITextView) {
//        if textView.text.isEmpty {
//            textView.text = "Placeholder"
//            textView.textColor = UIColor.lightGrayColor()
//        }
//        StopTimer()
//    }
//    func textViewDidChangeSelection(textView: UITextView) {
//        if self.view.window != nil {
//            if textView.textColor == UIColor.lightGrayColor() {
//                textView.selectedTextRange = textView.textRangeFromPosition(textView.beginningOfDocument, toPosition: textView.beginningOfDocument)
//            }
//        }
//    }
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!) {
        //get ID
        
        let selectedImage : UIImage = image
        //var tempImage:UIImage = editingInfo[UIImagePickerControllerOriginalImage] as UIImage
        images.image=selectedImage
        self.dismissViewControllerAnimated(true, completion: nil)
        newImageData = UIImageJPEGRepresentation(image, 1)
        
        let imageData = UIImagePNGRepresentation(image)
        let imageFile = PFFile(name:txtitle.text + ".png", data:imageData)
        
        var userPhoto = PFObject(className:"UserPhoto")
        userPhoto["user"] = PFUser.currentUser()
         userPhoto["username"] = guser
        userPhoto["title"] = txtitle.text
        userPhoto["desc"] = txtdesc.text
        userPhoto["imageFile"] = imageFile
        userPhoto.saveInBackground()
        txtitle.text = ""
        txtdesc.text = ""
    }
    
    @IBAction func btnBack(sender: UIBarButtonItem) {
        StopTimer()
         self.dismissViewControllerAnimated(false, completion: nil)
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photos = []
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
      self.messagestream.text=""
        tableView.delegate = self
        self.messagestream.delegate = self
        self.messagestream.text = "Placeholder"
         self.messagestream.textColor = UIColor.lightGrayColor()
        
         self.messagestream.becomeFirstResponder()
        
         self.messagestream.selectedTextRange = self.messagestream.textRangeFromPosition(self.messagestream.beginningOfDocument, toPosition: self.messagestream.beginningOfDocument)
       
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        var query = PFQuery(className:"UserPhoto")  
        query.whereKey("user", equalTo:PFUser.currentUser())
        query.orderByAscending("createdAt")
        query.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                self.photos = objects
                 self.tableView?.reloadData()
            } else {
                println(error.localizedDescription)
            }
        })
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func home(){
        var vc = self.storyboard?.instantiateViewControllerWithIdentifier("chatnav") as NavViewController
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return photos!.count
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        println("You selected cell #\(indexPath.row)")
        var pics: AnyObject? = self.photos![indexPath.row]
        
        if let unwrappics: AnyObject = pics{
            let Title = unwrappics["title"] as? String
            let Desc = unwrappics["desc"] as? String
             UID = unwrappics["username"] as? String
            ID = unwrappics.objectId
            let MyPics = unwrappics["imageFile"] as? PFFile
        
                 println(ID)
            MyPics?.getDataInBackgroundWithBlock{(imageData:NSData!,error:
                NSError!) -> Void in
                if error == nil{
                    let pic = UIImage(data: imageData)
                    self.selPic = pic
                    self.txtitle.text = Title
                     self.txtdesc.text = Desc
                    self.images.image = self.selPic
                    timer = NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector: Selector("loaddata"), userInfo: nil, repeats: true)
                    //btnGetImages.enabled = false
                    //cell.imageView?.frame = CGRectMake(5,5,35,35)
                }
                else
                {
                    self.StopTimer()
                }
                
            }
          
        }

    }
    
   func StopTimer()
   {
    timer.invalidate()
   
    }
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        var pics: AnyObject? = self.photos![indexPath.row]
        
        if let unwrappics: AnyObject = pics{
            let Title = unwrappics["title"] as? String
            let Desc = unwrappics["desc"] as? String

            let MyPics = unwrappics["imageFile"] as? PFFile
            MyPics?.getDataInBackgroundWithBlock{(imageData:NSData!,error:
                NSError!) -> Void in
                if error == nil{
                    let pic = UIImage(data: imageData)
                    cell.imageView?.image = pic
                    cell.imageView?.frame = CGRectMake(5,5,35,35)
                    }
            
            }
              cell.textLabel?.text = "          " + Title!
        }
        
        return cell
    }
    

}
