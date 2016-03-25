import Foundation
/**
 * @Note: Keep the TreeListItem name, since you might want to create TreeMenuItem one day
 * // :TODO: why doesnt the treeListItem extend a class that ultimatly extends a TextButton?, has it something to do with the indentation via css?
 */
class TreeListItem:SelectCheckBoxButton{
    //var itemContainer : Container
    init(_ width:CGFloat, _ height:CGFloat, _ text:String = "defaultText", _ isChecked:Bool = false, _ isSelected:Bool = false, parent:IElement? = nil, id:String = "") {
        super.init(width, height, text, isSelected, isChecked, parent, id)
    }
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
}