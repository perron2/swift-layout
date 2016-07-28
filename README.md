Layout
======
Layout is a Swift layout library for iOS. Currently it provides an Android-style LinearLayout that greatly simplifies view layout code. LinearLayout is **not** based on AutoLayout. This is on purpose because AutoLayout is often very slow.

Usage
-----
LinearLayout supports two orientations: `Orientation.Horizontal` and `Orientation.Vertical`. Optionally the content can be padded. The views themselves can have a margin.

Views are added using `addView()`. The width and height are either a precise value or one of the two special values `LayoutParams.MatchParent` and `LayoutParams.WrapContent` (this is the default value).

Views can be aligned along the cross axis. Horizonal layouts allow top, center and bottom alignment. Vertical layouts allow left, center and right alignment.

One or more views can be specified to take up the remaining space along the main axis. Using the `fill` parameter you can specify a weight for the view. If you have a view with a fill weight of 1 and another one with a weight of 2, the first one will receive one third of the remaining space, the second one two thirds.

Hidden views are ignored.

UITableView
-----------
There's a special generic UITableViewCell that simplifies using LinearLayout in UITableViews. The helper class is called `TableViewCell`. Register it like this:

```swift
tableView.registerClass(TableViewCell<YourClass>.self, forCellReuseIdentifier: "cell")
tableView.rowHeight = UITableViewAutomaticDimension
```

Inside tableView:cellForRowAtIndex you can work with your custom view like this:

```swift
func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TableViewCell<YourView>
    cell.view.name = "…"
    cell.view.altName = "…"
    return cell
}
```

Example
-------
You can use LinearLayout as the main view in a view controller or directly as the base class for your custom views. The following is a simple custom view that displays two labels vertically and an optional status image to the right of the two (centered vertically):

```swift
class ObservationView : LinearLayout {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    var name: String {
        didSet {
            nameView.text = name
        }
    }

    var altName: String {
        didSet {
            altNameView.text = altName
        }
    }

    var statusImage: UIImage? {
        didSet {
            statusView.image = statusImage
            statusView.hidden = statusImage == nil
        }
    }

    private let verticalGap: CGFloat = 2
    private let viewPadding: CGFloat = 8

    private let nameView = UILabel()
    private let altNameView = UILabel()
    private let statusView = UIImageView()

    private func setup() {
        let group = LinearLayout(orientation: .Vertical)

        nameView.font = UIFont.systemFontOfSize(16)
        nameView.textColor = UIColor.blackColor()
        nameView.numberOfLines = 0
        group.addView(nameView)

        altNameView.font = UIFont.systemFontOfSize(13)
        altNameView.textColor = UIColor.grayColor()
        altNameView.numberOfLines = 0
        group.addView(altNameView, margin: Edge(top: verticalGap))

        orientation = .Horizontal
        padding = Edge(viewPadding)
        addView(group, width: 0, fill: 1, margin: Edge(right: Styles.viewPadding))
        addView(statusView, align: .Center)
    }
}
```