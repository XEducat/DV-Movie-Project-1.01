import UIKit

extension UILabel {
    
    /// Выставляет текст для label учитывая заданый лимит символов
    public func SetWithLimit(text:String, characterLimit:Int){
        if text.count > characterLimit {
            let index = text.index(text.startIndex, offsetBy: characterLimit)
            let truncatedText = text[..<index] + "..."
            self.text = String(truncatedText)
        }
        else{
            self.text = text
        }
    }
}
