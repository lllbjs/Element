import Foundation

class SelectModifier {
    /**
    * Unselects all in @param items except @param target
    */
    class func unSelectAllExcept(exceptionItem:ISelectable, _ selectables:Array<ISelectable>) {// :TODO: refactor this function// :TODO: rename to unSelectAllExcept
        for selectable in selectables {if(selectable != exceptionItem && selectable.selected) {selectable.setSelected(false)}}
    }
}
