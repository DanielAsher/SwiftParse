public enum ArrayMatcher<A> {
    case Nil
    case Cons(A, [A])
}
extension Array {
    /// Destructures a list into its constituent parts.
    ///
    /// If the given list is empty, this function returns .Nil.  If the list is non-empty, this
    /// function returns .Cons(head, tail)
    public var match : ArrayMatcher<Element> {
        if self.count == 0 {
            return .Nil
        } else if self.count == 1 {
            return .Cons(self[0], [])
        }
        let hd = self[0]
        let tl = Array(self[1..<self.count])
        return .Cons(hd, tl)
    }
}


