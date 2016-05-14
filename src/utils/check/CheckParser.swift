import Foundation

class CheckParser {
    /**
     * Returns an ICheckable at a spessific index
     */
    func getCheckableAt(checkables:Array<ICheckable>,_ index:Int)->ICheckable? {// :TODO: consider moving in to util class or just write it up as a note
        if(index <= checkables.count) {return checkables[index]}
        else {fatalError("\(self)" + " no ICheckable at the index of: " + "\(index)")}
        return nil
    }
}