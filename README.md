# YNCheatTableView

A Subclass of UITableView that suport pan to move the columns just like your TableView has many sub-tableview inside.

一个用障眼法实现单个TableView，多列滑动；让你的TableView看上去好像是有很多个TableView在Cell中；

## Usage （用法）

1. Just drag the files "YNCheatTableView.h" and ""YNCheatTableView.m" to your project;
2. Let your custom UITableView extend YNCheatTableView.
3. Implement the YNCheatTableViewDelegate
4. Then call 'tableView.setupCheatView()'

```
// MARK: - YNCheatTableViewDelegate

extension XXXController : YNCheatTableViewDelegate {
    
    // total columns
    func columnCountForCheat() -> Int {
        return self.categories.count
    }
    
    // the view area should be captured begin at point of superview
    func YNCheatTableViewShouldCaptureViewAtPositonY() -> CGFloat {
        return 42
    }
    
    func YNCheatTableViewShouldScrollAtPoint(panTouchPoint: CGPoint) -> Bool {
        return panTouchPoint.y > 42 && panTouchPoint.x > 40
    }
    
    // when tableview did scroll callback
    func YNCheatTableViewDidScrollTo(index: Int) {
        // to do 
    }
    
}
```

You can call this methods to scroll the column
```
func scrollToColumnAtIndex(index: NSInteger)
```

## 

![demo1.gif](http://upload-images.jianshu.io/upload_images/1338379-3f4ee80b7ee3390c.gif?imageMogr2/auto-orient/strip)
