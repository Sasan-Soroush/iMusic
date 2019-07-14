//
//  TextFieldEffects.swift
//  Tipsy
//
//  Created by Sasan Soroush on 9/24/18.
//  Copyright © 2018 Sasan Soroush. All rights reserved.
//

import UIKit

extension String {
    /**
     true iff self contains characters.
     */
    public var isNotEmpty: Bool {
        return !isEmpty
    }
}

/**
 A TextFieldEffects object is a control that displays editable text and contains the boilerplates to setup unique animations for text entrey and display. You typically use this class the same way you use UITextField.
 */
open class TextFieldEffects : UITextField {
    
    /**
     The type of animatino a TextFieldEffect can perform.
     
     - TextEntry: animation that takes effect when the textfield has focus.
     - TextDisplay: animation that takes effect when the textfield loses focus.
     */
    public enum AnimationType: Int {
        case textEntry
        case textDisplay
    }
    
    /**
     Closure executed when an animation has been completed.
     */
    public typealias AnimationCompletionHandler = (_ type: AnimationType)->()
    
    /**
     UILabel that holds all the placeholder information
     */
    open let placeholderLabel = UILabel()
    
    /**
     Creates all the animations that are used to leave the textfield in the "entering text" state.
     */
    open func animateViewsForTextEntry() {
        fatalError("\(#function) must be overridden")
    }
    
    /**
     Creates all the animations that are used to leave the textfield in the "display input text" state.
     */
    open func animateViewsForTextDisplay() {
        fatalError("\(#function) must be overridden")
    }
    
    /**
     The animation completion handler is the best place to be notified when the text field animation has ended.
     */
    open var animationCompletionHandler: AnimationCompletionHandler?
    
    /**
     Draws the receiver’s image within the passed-in rectangle.
     
     - parameter rect:    The portion of the view’s bounds that needs to be updated.
     */
    open func drawViewsForRect(_ rect: CGRect) {
        fatalError("\(#function) must be overridden")
    }
    
    open func updateViewsForBoundsChange(_ bounds: CGRect) {
        fatalError("\(#function) must be overridden")
    }
    
    // MARK: - Overrides
    
    override open func draw(_ rect: CGRect) {
        drawViewsForRect(rect)
    }
    
    override open func drawPlaceholder(in rect: CGRect) {
        // Don't draw any placeholders
    }
    
    override open var text: String? {
        didSet {
            if let text = text , text.isNotEmpty {
                animateViewsForTextEntry()
            } else {
                animateViewsForTextDisplay()
            }
        }
    }
    
    // MARK: - UITextField Observing
    
    override open func willMove(toSuperview newSuperview: UIView!) {
        if newSuperview != nil {
            NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidEndEditing), name: NSNotification.Name.UITextFieldTextDidEndEditing, object: self)
            
            NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidBeginEditing), name: NSNotification.Name.UITextFieldTextDidBeginEditing, object: self)
        } else {
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    /**
     The textfield has started an editing session.
     */
    @objc open func textFieldDidBeginEditing() {
        animateViewsForTextEntry()
    }
    
    /**
     The textfield has ended an editing session.
     */
    @objc open func textFieldDidEndEditing() {
        animateViewsForTextDisplay()
    }
    
    // MARK: - Interface Builder
    
    override open func prepareForInterfaceBuilder() {
        drawViewsForRect(frame)
    }
}
