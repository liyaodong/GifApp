//
//  MenuViewController.swift
//  GifApp
//
//  Created by 朱坤 on 11/24/15.
//  Copyright © 2015 Zkuns. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
  
  @IBOutlet weak var loginArea: UIView!
  @IBOutlet weak var avator: UIImageView!
  @IBOutlet weak var username: UILabel!
  @IBOutlet weak var collection: UILabel!
  @IBOutlet weak var post: UILabel!
  @IBOutlet weak var collectionArea: UIView!
  @IBOutlet weak var postArea: UIView!
  
  var user: User?{
    didSet{
      updateUserArea()
    }
  }
  
  var delegate: ChangeControllerDelegate?
  @IBOutlet weak var menuTable: UITableView!
  let menuItems = MenuItem.menuItems
  var moveToUserCenterCol: UITapGestureRecognizer?
  var moveToUserCenterPost: UITapGestureRecognizer?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    menuTable.delegate = self
    menuTable.dataSource = self
    updateUI()
    NSNotificationCenter.defaultCenter().addObserverForName(NotificationName.userChanged, object: nil ,queue: NSOperationQueue.mainQueue()){
      notification in
      self.updateCurrentUser()
    }
  }
  
  func updateCurrentUser(){
    User.getCurrentUser(){
      user in
      self.user = user
    }
  }
  
  func updateUI(){
    ImageUtil.convertImageToCircle(avator)
    menuTable.separatorStyle = UITableViewCellSeparatorStyle.None
    updateCurrentUser()
  }
  
  private func updateUserArea(){
    username.text = user?.username ?? "登录"
    avator.kf_setImageWithURL( NSURL(string: user?.avator ?? "")!, placeholderImage: UIImage(named:Default.avatar))
    collection.text = "\(user?.collections?.count ?? 0)"
    post.text = "\(user?.posts?.count ?? 0)"
    
    let moveToUserCenterQR = UITapGestureRecognizer(target: self, action: "moveToUserCenter:")
    loginArea.addGestureRecognizer(moveToUserCenterQR)
    self.view.setNeedsDisplay()
    moveToUserCenterCol = UITapGestureRecognizer(target: self, action: "moveToUserCenter:")
    moveToUserCenterPost = UITapGestureRecognizer(target: self, action: "moveToUserCenter:")
    postArea.addGestureRecognizer(moveToUserCenterPost!)
    collectionArea.addGestureRecognizer(moveToUserCenterCol!)
  }
  
}

extension MenuViewController: UIGestureRecognizerDelegate{
  func moveToUserCenter(recogizer: UIPanGestureRecognizer){
    if User.user != nil{
      let view = recogizer.view
      delegate?.changeToUserCenterController(view!.tag)
    }else{
      if let loginController = storyboard?.instantiateViewControllerWithIdentifier("login") as? LoginViewController{
        presentViewController(loginController, animated: true, completion: nil)
      }
    }
  }
}

extension MenuViewController: UITableViewDelegate{
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    delegate?.changeController(menuItems[indexPath.row])
  }
}

extension MenuViewController: UITableViewDataSource{
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return menuItems.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
    let cell = tableView.dequeueReusableCellWithIdentifier("menuCell", forIndexPath: indexPath) as! MenuCell
    let menuModel = menuItems[indexPath.row]
    cell.setData(menuModel.menuName, imageName: menuModel.imageName)
    let bgColorView = UIView()
    bgColorView.backgroundColor = ColorConfig.yellowColor.colorWithAlphaComponent(0.8)
    cell.selectedBackgroundView = bgColorView
    return cell
  }
}