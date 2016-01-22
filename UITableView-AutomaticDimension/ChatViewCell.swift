import PureLayout

class ChatViewCell : UITableViewCell {
  
  var didUpdateConstraints = false
  
  let userName : UILabel = {
    let userName = UILabel.newAutoLayoutView()
    userName.textColor = UIColor.blueColor()
    userName.font = userName.font.fontWithSize(14)
    userName.numberOfLines = 1
    userName.userInteractionEnabled = false
    return userName
  }()
  
  let userComment : UILabel = {
    let userComment = UILabel.newAutoLayoutView()
    userComment.textColor = UIColor.blackColor()
    userComment.font = UIFont(name: "HelveticaNeue-Thin", size: 14)
    userComment.lineBreakMode = .ByWordWrapping
    userComment.numberOfLines = 0
    userComment.userInteractionEnabled = false
    return userComment
  }()
  
  let container : UIView = {
    let container = UIView.newAutoLayoutView()
    container.userInteractionEnabled = false
    container.backgroundColor = UIColor.whiteColor()
    return container
  }()
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    backgroundColor = UIColor.clearColor()
    self.container.addSubview(userName)
    self.container.addSubview(userComment)
    self.contentView.addSubview(container)
    self.updateConstraintsIfNeeded()
  }
  
  override func updateConstraints() {
    if !didUpdateConstraints {
      
      let spacing: CGFloat = 4.0
      
      container.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsMake(2, 4, 2, 4))
      
      userName.autoPinEdge(.Left, toEdge: .Left, ofView: self.container, withOffset: spacing)
      userName.autoPinEdge(.Right, toEdge: .Right, ofView: self.container)
      userName.autoPinEdge(.Top, toEdge: .Top, ofView: self.container, withOffset: spacing)
      
      userComment.autoPinEdge(.Left, toEdge: .Left, ofView: self.container, withOffset: spacing)
      userComment.autoPinEdge(.Right, toEdge: .Right, ofView: self.container, withOffset: -spacing)
      userComment.autoPinEdge(.Top, toEdge: .Bottom, ofView: userName)
      userComment.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self.container, withOffset: -spacing)
      
      didUpdateConstraints = true
    }
    super.updateConstraints()
  }
  
  func load(comment: Comment?) {
    
    if(comment == nil) {
      return
    }
    
    userName.text = comment!.userName
    userComment.text = comment!.comment
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
  }
  
}