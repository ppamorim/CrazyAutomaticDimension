import UIKit
import PureLayout

class ViewController: UIViewController {
  
  var didUpdateViews = false
  var secondState = false
  var alternativeType = false
  
  var comments : NSMutableArray? = NSMutableArray()
  
  var videoPinEdgeLeftConstraint : NSLayoutConstraint?
  var videoPinEdgeRightConstraint : NSLayoutConstraint?
  var videoPinEdgeTopConstraint : NSLayoutConstraint?
  var videoPinEdgeBottomConstraint : NSLayoutConstraint?
  var videoPaddingConstraint : NSLayoutConstraint?
  
  let container : UIView = {
    let container = UIView.newAutoLayoutView()
    return container
  }()
  
  let commentsTableView : UITableView = {
    let commentsTableView = UITableView.newAutoLayoutView()
    commentsTableView.registerClass(ChatViewCell.self, forCellReuseIdentifier: "ChatViewCell")
    commentsTableView.separatorStyle = .None
    commentsTableView.backgroundColor = UIColor.grayColor()
    return commentsTableView
  }()
  
  deinit {
    self.commentsTableView.dataSource = nil
    self.commentsTableView.delegate = nil
  }

  override func loadView() {
    super.loadView()
    configTableview()
    container.addSubview(commentsTableView)
    self.view.addSubview(container)
    view.setNeedsUpdateConstraints()
  }
  
  override func updateViewConstraints() {
    if !didUpdateViews {
      commentsTableView.autoPinEdgesToSuperviewEdges()
      didUpdateViews = true
    }
    
    videoPinEdgeLeftConstraint?.autoRemove()
    videoPinEdgeRightConstraint?.autoRemove()
    videoPinEdgeTopConstraint?.autoRemove()
    videoPinEdgeBottomConstraint?.autoRemove()
    
    if(!secondState) {
      videoPinEdgeLeftConstraint = container.autoPinEdgeToSuperviewEdge(.Left)
      videoPinEdgeRightConstraint = container.autoPinEdgeToSuperviewEdge(.Right)
      videoPinEdgeTopConstraint = container.autoMatchDimension(
        .Height,
        toDimension: .Width,
        ofView: self.view,
        withMultiplier: 0.57)
      videoPinEdgeBottomConstraint = container.autoPinEdgeToSuperviewEdge(.Top, withInset: 0.0)
    } else {
      videoPinEdgeLeftConstraint = container.autoMatchDimension(
        .Width,
        toDimension: .Width,
        ofView: self.view,
        withMultiplier: 0.45)
      videoPinEdgeRightConstraint = container.autoPinEdgeToSuperviewEdge(.Right, withInset: 4.0)
      videoPinEdgeTopConstraint = container.autoMatchDimension(
        .Height,
        toDimension: .Width,
        ofView: container,
        withMultiplier: 0.57)
      videoPinEdgeBottomConstraint = container.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self.view, withOffset: -4.0)
    }
    
    super.updateViewConstraints()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    infiniteChat()
    toggleContainer()
  }
  
  func configTableview() {
    commentsTableView.dataSource = self
    commentsTableView.delegate = self
  }
  
  func infiniteChat() {
    let seconds = 4.0
    let delay = seconds * Double(NSEC_PER_SEC)
    let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
    
    dispatch_after(dispatchTime, dispatch_get_main_queue(), {
      self.addItem(self.alternativeType ? Comment(userName: "Paulo", comment: "Teste legal") : Comment(userName: "Paulo nervoso", comment: "Texto longo pq eu quero testar essa bagaça que não funciona com AutomaticDimension direito"))
      self.alternativeType = !self.alternativeType
      self.infiniteChat()
    })
  }
  
  func addItem(comment: Comment) {
    self.commentsTableView.beginUpdates()
    if self.comments!.count == 5 {
      self.commentsTableView.deleteRowsAtIndexPaths([NSIndexPath(forRow : 4, inSection: 0)], withRowAnimation: .Right)
      comments?.removeObjectAtIndex(4)
    }
    self.comments?.insertObject(comment, atIndex: 0)
    self.commentsTableView.insertRowsAtIndexPaths([NSIndexPath(forRow : 0, inSection: 0)], withRowAnimation: .Right)
    
    self.commentsTableView.endUpdates()
  }
  
  func toggleContainer() {
    if secondState {
      collapse()
    } else {
      expand()
    }
  }
  
  func expand() {
    self.secondState = true
    view.setNeedsUpdateConstraints()
    view.updateConstraintsIfNeeded()
    UIView.animateWithDuration(2, delay: 5.0, usingSpringWithDamping: 1.0,
      initialSpringVelocity: 2, options: UIViewAnimationOptions(), animations: {
        self.view.layoutIfNeeded()
      }, completion: { (completion) in
        self.toggleContainer()
    })
  }
  
  func collapse() {
    self.secondState = false
    view.setNeedsUpdateConstraints()
    view.updateConstraintsIfNeeded()
    UIView.animateWithDuration(2, delay: 5.0, usingSpringWithDamping: 1.0,
      initialSpringVelocity: 2, options: UIViewAnimationOptions(), animations: {
        self.view.layoutIfNeeded()
      }, completion: { (completion) in
        self.toggleContainer()
    })
  }

}

extension ViewController : UITableViewDelegate {
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
  }
  
  func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    if self.comments != nil {
      (cell as! ChatViewCell).load((self.comments?.objectAtIndex(indexPath.row))! as? Comment)
    }
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
  }
  
  func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 44
  }
  
}

extension ViewController : UITableViewDataSource {
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.comments?.count ?? 0
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    return tableView.dequeueReusableCellWithIdentifier("ChatViewCell", forIndexPath: indexPath) as! ChatViewCell
  }
  
}
  