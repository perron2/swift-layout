import UIKit

class TableView<T:UIView> : UITableView {
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

    func cell(indexPath: NSIndexPath) -> TableViewCell<T> {
        let cell = dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TableViewCell<T>
        cell.view.setNeedsLayout()
        return cell
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