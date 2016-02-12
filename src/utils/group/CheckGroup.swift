import Foundation
/*
 * @Note: remeber to add the group to the stage or else the eventBubbling may make errors in other components
 * @Note: this class would be more logical if it extended EventDispatcher but it extends Sprite so that the event bubbling on the ICheckable objects works
 * @Note: the constructor checked parameter is just a reference no action is applied to that checked item.
 * // :TODO: In the future make a MultipleSelectionCheckGroup that can select many icheckable items with the use of shift key for instance (do not add this functionality in this class its not the correct abstraction level)
 * // :TODO: fix the bubbling stuff this should need to be added to the stage or be a sprite.
 */
class CheckGroup {
    var checkables:Array<ICheckable> = []
    var checked:ICheckable
    init(checkables:Array<ICheckable>, checked:ICheckable? = nil){
        addCheckables(checkables)
        self.checked = checked!
    }
    func onCheck(event:CheckEvent) {// :TODO: make protected see SelectGroup
        //print("CheckGroup.onCheck: " + event);
        checked = event.currentTarget as! ICheckable
        CheckUtil.unCheckAll(checked, checkables)
        dispatchEvent(CheckGroupEvent(CheckGroupEvent.CHECK_GROUP_CHANGE))
    }
    func addCheckables(checkables:Array<ICheckable>) {
        for checkable : ICheckable in checkables{ addCheckable(checkable)}
    }
    func addCheckable(checkable:ICheckable) {
        //IEventDispatcher(checkable).addEventListener(CheckEvent.CHECK, onCheck,false,0,true);//@Note: useWeakReference is set to true so that we dont have to remove the event if the selectable is removed from the SelectGroup or from stage
        //checkables.push(checkable);
    }
    /**
     * Removes the RadioButton passed through the @param radioButton
     */
    func removeCheckable(item:ICheckable)->ICheckable {
        for (var i:int=0; i < _checkables.length; i++) {
            if (_checkables[i] === item) {
                return _checkables.splice (i,1);	// :TODO: disoatch something?
            }
        }
        return nil;
    }
}