import Cocoa
@testable import Utils

class ElementModifier {
    typealias RefreshMethod = (ElementKind)->Void
    /**
     * Changes the visibility of PARAM: element by PARAM: isVisible
     */
    static func hide(_ element:ElementKind,_ isVisible:Bool) {
        let display:String = isVisible ? "" : CSS.Align.none//defines the dispaly param to be set
        applyStyleProperty(element, CSS.Align.display, display)
    }
    /**
     * TODO: ⚠️️ What if the state changes? then the StyleManager is queried again and the current display state won't work, a fix would be add the same style to the StyleManger, if you need granularity then add the custom style to a id that only matches the case etc.
     * TODO: ⚠️️ Also make a method that uses the actualy StyleProperty class
     */
    static func applyStyleProperty(_ element:ElementKind,_ key:String,_ value:Any){
        guard let skin = element.skin, var style:Style = skin.style as? Style else{fatalError("skin or style is nil")}
        skin.setStyle(StyleModifier.clone(style))/*This is a temp fix, an unique reference must be applied to every skin*/
        if var styleProperty:StylePropertyKind = style.getStyleProperty(key) {
            styleProperty.value = value/*prop already exists just add value*/
            StyleModifier.overrideStyleProperty(&style, styleProperty)
        }else{
            style.addStyleProperty(StyleProperty(key, value))/*prop doesn't exist add StyleProp to style*/
        }
        skin.setStyle(style)/*Apply the altered style*/
    }
    static func hideAll(_ elements:[ElementKind],_ exception:ElementKind) {
        elements.forEach{ElementModifier.hide($0, ($0 === exception))}
    }
    static func hideChildren(_ view:NSView,_ exception:ElementKind) {
        hideAll(ElementParser.children(view,ElementKind.self), exception)
    }
    /**
     * IMPORTANT: ⚠️️ Refreshing the skin also calls StyleResolver.resolve which is an expensive call. because it have to parse through StyleManger for the correct Style
     * NOTE: Sometimes it's better to use element.setSkin(element.getSkin()) 
     */
    static func refreshSkin(_ element:ElementKind){
        refresh(element, Utils.setSkinState)
    }
    /**
     * IMPORTANT: ⚠️️ Refreshing style is cheaper than calling refresh skin (Because it does not call StyleResolver)
     */
    static func refreshStyle(_ element:ElementKind){
        refresh(element, Utils.setStyle)
    }
    /**
     * New (calls skin.setSize)
     */
    static func refreshSize(_ element:ElementKind){
        //Swift.print("refreshSize")
        refresh(element, Utils.setSize)
    }
    /**
     * Refreshes many elements in PARAM: displayObjectContainer
     * NOTE: keep in mind that this can be Window
     * TODO: ⚠️️ Skin should have a dedicated redraw method or a simple workaround
     */
    private static func refresh(_ element:ElementKind, _ method:RefreshMethod = Utils.setStyle) {//<--setStyle is the default param method
        //Swift.print("refresh")
        if (element.skin?.style?.getStyleProperty(CSS.Align.display) as? String) == CSS.Align.none {
            //Swift.print("display: " + "\(element.skin!.style!.getStyleProperty(CSSConstants.display.rawValue))")
            return
        }/*Skip refreshing*/
        //Swift.print("apply method")
        method(element)/*apply the method*/
        guard let container:NSView = element as? NSView else{fatalError("element is not NSView")}//element is Window ? Window(element).view : element as NSView;
        container.subviews.lazy.flatMap{$0 as? ElementKind}.forEach{refresh($0,method)}/*<--this line makes it recursive*/
    }
    /**
     * Resizes many elements in PARAM: view
     * TODO: ⚠️️ Rename to Resize, its less ambigiouse
     */
    static func size(_ view:NSView,_ size:CGSize) {
        view.subviews.lazy.flatMap{$0 as? ElementKind}.forEach{$0.setSize(size.width, size.height)}
    }

    /**
     * NOTE: refloats PARAM: view children that are of type IElement
     * NOTE: i.e: after hideing of an element, or changing the depth order etc
     */
    static func floatChildren(_ view:NSView) {
        view.subviews.lazy.flatMap{$0 as? ElementKind}.forEach{float($0)}
    }
    /**
     * New
     */
    static func float(_ element:ElementKind){
        if let skin = element.skin { SkinModifier.float(skin) }
    }
}
private class Utils{
    static func setStyle(_ element:ElementKind){
        if let skin = element.skin, let style = skin.style { skin.setStyle(style) }/*Uses the setStyle since its faster than setSkin*/
    }
    /**
     * This operated directly on the skin before as the element.setSkinState may be removed in the future
     */
    static func setSkinState(_ element:ElementKind){
        if let skin = element.skin{skin.setSkinState(skin.state)}/*<-- was SkinStates.none but re-applying the same skinState is a better option*/
    }
    /**
     * New (calls skin.setSize)
     */
    static func setSize(_ element:ElementKind){
        //Swift.print("Utils.setSize " + ElementParser.stackString(element))
        let w:CGFloat = element.getWidth()
        let h:CGFloat = element.getHeight()
        element.setSize(w, h)//targeting element is better because it allows you to override
        /*if let skin = element.skin{
         /*Clip*/
         
         skin.setSize(w,h)/*We use the skin and work directly on that*/
         }*/
    }
}
