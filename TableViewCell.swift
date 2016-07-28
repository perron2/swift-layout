import UIKit

class TableViewCell<T:UIView> : UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    let view = T()

    override var contentView: UIView {
        get {
            return view
        }
    }

    override func sizeThatFits(size: CGSize) -> CGSize {
        layoutIfNeeded()
        var contentSize = view.sizeThatFits(CGSizeMake(view.bounds.width, CGFloat.max))
        if let layout = view as? LinearLayout {
            contentSize.height = max(contentSize.height, layout.layoutParams.minHeight)
        }

        return CGSizeMake(size.width, ceil(contentSize.height + 0.5))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    // MARK:- Private

    private var cellSize = CGSizeZero

    private func setup() {
        let view = UIView()
        view.backgroundColor = UIColor(red: 65.5/100, green: 83.1/100, blue: 100/100, alpha: 0.5)
        selectedBackgroundView = view
        layoutMargins = UIEdgeInsetsZero
        preservesSuperviewLayoutMargins = false
        self.addSubview(self.view)
    }
}