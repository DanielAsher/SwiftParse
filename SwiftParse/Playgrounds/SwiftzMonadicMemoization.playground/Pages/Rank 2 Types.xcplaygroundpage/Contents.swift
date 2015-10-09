//: [Previous](@previous)
// http://research.microsoft.com/en-us/um/people/simonpj/papers/hmap/hmap.ps
// Scrap your boilerplate: a practical approach to generic programming, Ralf Laemmel and Simon Peyton Jones

typealias Name = String
typealias Address = String
struct Salary { let salary: Float }
struct Person { let name: Name; let address: Address }
struct Employee { let person: Person; let salary: Salary }

protocol Term {
    typealias A
    static func gmapT<B: Term>(f: B -> B, e: A) -> A
}

extension Float : Term {
    typealias A = Float
    
    static func gmapT<B: Term>(f: B -> B, e: A) -> A {
        return 0.0
    }
}

extension String : Term {
    typealias A = String
    
    static func gmapT<B: Term>(f: B -> B, e: A) -> A {
        return ""
    }
}


extension Salary : Term {
    typealias A = Salary
    
    static func gmapT<B: Term>(f: B -> B, e: A) -> A {
        return Salary(salary: f( e.salary ))
    }
}
//extension Person : Term {
//    typealias A = Person
//    
//    static func gmapT<B: Term>(f: B -> B, e: A) -> A {
//        return Person(name: f( e.name ), address: f( e.address ) )
//    }
//}
//
//extension Employee : Term {
//    typealias A = Employee
//    
//    static func gmapT<B: Term>(f: B -> B, e: A) -> A {
//        return Employee(person: f( e.person ), salary: f( e.salary ) )
//    }
//}
//





print("Finished")

//: [Next](@next)
