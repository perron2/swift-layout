import UIKit

class TableView<T:UIView>: UITableView {
    convenience init() {
        self.init(frame: CGRectZero, style: .Plain)
    }

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    var autoBounce: Bool = true

    func cell(indexPath: NSIndexPath) -> TableViewCell<T> {
        let cell = dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TableViewCell<T>
        cell.view.setNeedsLayout()
        return cell
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if autoBounce {
            bounces = contentSize.height > frame.size.height
        }
    }

    // MARK:- Private

    private func setup() {
        separatorInset = UIEdgeInsetsZero
        registerClass(TableViewCell<T>.self, forCellReuseIdentifier: "cell")
        rowHeight = UITableViewAutomaticDimension
        estimatedRowHeight = Styles.minTouchSize
        if #available(iOS 9, *) {
            cellLayoutMarginsFollowReadableWidth = false
        }
    }
}
