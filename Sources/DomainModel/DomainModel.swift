struct DomainModel {
    var text = "Hello, World!"
        // Leave this here; this value is also tested in the tests,
        // and serves to make sure that everything is working correctly
        // in the testing harness and framework.
}

////////////////////////////////////
// Money
//

let currencies = ["USD", "GBP", "EUR", "CAN"]

public struct Money {
    let amount: Int;
    let currency: String;
    
    init(amount: Int, currency: String) {
        if (!currencies.contains(currency)) {
            self.currency = "";
            self.amount = 0;
        } else {
            self.currency = currency;
            self.amount = amount;
        }
    }
    
    
    func convert(_ newCurr: String) -> Money {
        
        // convert current amount into USD
        var currAmount = Double(amount);
        switch currency {
        case "GBP":
            currAmount = currAmount * 2.0;
        case "EUR":
            currAmount = currAmount * 2.0/3.0 // to USD first
        case "CAN":
            currAmount = currAmount * 4.0/5.0
        default:
            break
        }
        
        // convert USD value into whatever other value
        var newAmount = currAmount;
        switch newCurr {
        case "GBP":
            newAmount = newAmount * 0.5
        case "EUR":
            newAmount = newAmount * 1.5
        case "CAN":
            newAmount = newAmount * 1.25
        default:
            break
        }
        
        newAmount.round()
        return Money(amount: Int(newAmount), currency: newCurr)
    }
    
    func add (_ addTo: Money) -> Money {
        let convertedOwn = self.convert(addTo.currency)
        return Money(amount: convertedOwn.amount + addTo.amount, currency: addTo.currency);
    }
    
    func subtract (_ addTo: Money) -> Money {
        let convertedOwn = self.convert(addTo.currency)
        return Money(amount: convertedOwn.amount - addTo.amount, currency: addTo.currency);
    }
    
}

////////////////////////////////////
// Job
//
public class Job {
    let title: String
    var type: JobType
    
    
    public enum JobType {
        case Hourly(Double)
        case Salary(UInt)
    }
    
    init (title: String, type: JobType) {
        self.title = title;
        self.type = type;
    }
    
    func calculateIncome(_ hours: Int) -> Int {
        var totalSalary: Int;
        switch self.type {
        case .Hourly (let hourly):
            totalSalary = Int(hourly * Double(hours))
        case .Salary (let salary):
            totalSalary = Int(salary)
        }
        return totalSalary;
    }
    
    func raise(byAmount: Double) {
        switch self.type {
        case .Hourly (let hourly):
            self.type = JobType.Hourly(hourly + Double(byAmount))
            
        case .Salary (let salary):
            self.type = JobType.Salary(salary + UInt(byAmount))
        }
    }
    
    func raise(byPercent: Double) {
        switch self.type {
        case .Hourly (let hourly):
            self.type = JobType.Hourly(hourly + (hourly * byPercent))
            
        case .Salary (let salary):
            self.type = JobType.Salary(salary + UInt((Double(salary) * byPercent)))
        }
    }
}

////////////////////////////////////
// Person
//
public class Person {
    var firstName: String
    var lastName: String
    var age: Int
    var job: Job? {
        didSet {
            if (age < 16) {
                job = nil;
            }
        }
    }
    var spouse: Person? {
        didSet {
            if (age < 18) {
                spouse = nil;
            }
        }
    }
    
    init(firstName:String, lastName:String, age:Int) {
        self.firstName = firstName;
        self.lastName = lastName;
        self.age = age;
        self.job = nil;
        self.spouse = nil;
    }
    
    func toString() -> String {
        return ("[Person: firstName:\(self.firstName) lastName:\(self.lastName) age:\(self.age) job:\(self.job?.title ?? "nil") spouse:\(self.spouse?.toString() ?? "nil")]")
    }
}

////////////////////////////////////
// Family
//
public class Family {
    var members: Array<Person>
    
    init(spouse1: Person, spouse2: Person) {
        members = [];
        if (spouse1.spouse == nil && spouse2.spouse == nil) {
            members = [spouse1, spouse2]
            spouse1.spouse = spouse2;
            spouse2.spouse = spouse1;
        }
    }
    
    func haveChild(_ child: Person) -> Bool {
        if (members[0].age > 21 || members[1].age > 21) {
            members.append(child);
            return true;
        } else {
            return false;
        }
    }
    
    func householdIncome() -> Int {
        var totalIncome = 0;
        for person in members {
            totalIncome += person.job?.calculateIncome(2000) ?? 0
        }
        return totalIncome;
    }
}
