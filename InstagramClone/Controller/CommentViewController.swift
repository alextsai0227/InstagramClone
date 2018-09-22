
import UIKit
import FirebaseDatabase
import FirebaseAuth
import Firebase
import SDWebImage

class CommentViewController: UIViewController {

    @IBOutlet weak var textView: UIView!

    @IBOutlet var commentView: UIView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    var commentArr: [[String:String]] = []
    let user = FIRAuth.auth()?.currentUser
    var userProfileImgUrl:String?
    var postID: String?
    var postUID: String?
    let ref = FIRDatabase.database().reference()
    override func viewDidLoad() {
        super.viewDidLoad()
        //   tableView delegate
        self.commentTableView.delegate = self
        self.commentTableView.dataSource = self
        self.commentTableView.register(UINib(nibName: "CommentTableViewCell",bundle: nil), forCellReuseIdentifier: "CommentTableViewCell")
        
        self.commentTableView.estimatedRowHeight = 50
        self.commentTableView.rowHeight = UITableViewAutomaticDimension
        NotificationCenter.default.addObserver(self, selector: #selector(CommentViewController.keyboardWasShown), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CommentViewController.tapView))
        self.commentView.addGestureRecognizer(tapGesture)
        
        
        let userReference = ref.child("users").child((user?.uid)!)
        userReference.observeSingleEvent(of: .value, with: {(userSnapshot) in
            // store values in a dictionary
            let userDictionary = userSnapshot.value as! NSDictionary
            self.userProfileImgUrl = userDictionary["profileImgUrl"] as? String ?? ""
        }, withCancel: { (error) in
            print(error)
        })
    }
    
    @objc func keyboardWasShown(notification: NSNotification) {
        var info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.bottomConstraint.constant = keyboardFrame.size.height
        })
    }

    @IBAction func sendPost(sender: AnyObject) {
        if commentTextField.text != ""{
            if user != nil {
                
                let commentsRef = FIRDatabase.database().reference().child("posts").child(postUID!).child(postID!).child("comments").childByAutoId();
                
                commentsRef.setValue(["content": self.commentTextField.text, "profileImg": userProfileImgUrl])
            }
            commentArr.append(["content": self.commentTextField.text!, "profileImg": userProfileImgUrl!])
            commentTableView.reloadData()
        }
        self.commentTextField.text = nil
        self.view.endEditing(true)
        self.bottomConstraint.constant = 0
        
    }

    @objc func tapView() {
        self.view.endEditing(true)
        self.bottomConstraint.constant = 0
    }
    
    @IBAction func backToHomeViewController(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
extension CommentViewController: UITableViewDelegate,UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return commentArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = commentTableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell") as! CommentTableViewCell
        
        cell.commentLabel.text = commentArr[indexPath.row]["content"]
        cell.profileImg.sd_setImage(with: URL(string: commentArr[indexPath.row]["profileImg"]!), placeholderImage: UIImage(named: "placeholder"))
        return cell
        
    }
}

