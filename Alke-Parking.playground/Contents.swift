import UIKit

protocol Parkable {
    var plate: String { get }
    var type: VehicleType { get }
    var checkInTime: Date { get }
    var discountCard: String? { get }
}

// Estructura del vehiculo y sus propiedades
struct Parking {
    private (set) var vehicles: Set<Vehicle> = []
    let maxVehicle = 20
    var acumVehicles = 0
    var earnings = 0
    
    // Funcion para hacer el checkIn de los vehiculos
    mutating func checkInVehicle(_ vehicle: Vehicle, onFinish: (Bool) -> Void) {
        
        guard vehicles.count < maxVehicle, vehicles.insert(vehicle).inserted  else {
            return onFinish(false)
        }
        onFinish(true)
    }
    
    // Funcion para hacer el checkOut del vehiculo
    mutating func checkOutVehicle(_ plate: String, onSuccess: (Int) -> Void, onError: () -> Void ) {
        
//        let vehicle = (vehicles.first{ $0.plate.contains(plate) })
        guard let vehicle = (vehicles.first{ $0.plate.contains(plate) }) else {
            return onError()
        }
        
        vehicles.remove(vehicle)
        
        let parkedTimeInMinutes = parkedTimeToMinutes(vehicle.checkInTime)
        let hasDiscount = vehicle.discountCard != nil
        let priceToPay = calculatePriceToPay(parkedTimeInMinutes, vehicleType: vehicle.type, hasDiscount: hasDiscount)
                
        acumVehicles += 1
        earnings += priceToPay
        
        onSuccess(priceToPay)
    }
    
    // Calcular el tiempo de parqueo del vehiculo
    func parkedTimeToMinutes(_ date: Date) -> Int {
        
        // Crear una fecha personalizada para la prueba
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let someDateTime = formatter.date(from: "2022/09/05 13:31")
        
        // Calculo en minutos del intervalo de tiempo
        let minutesParkedTime = Int((someDateTime!.distance(to: date))/60)
        return minutesParkedTime
        
    }
    
    // Calcular el precio a pagar por el tiempo en el parqueadero
    func calculatePriceToPay(_ parkedTime: Int, vehicleType: VehicleType, hasDiscount: Bool) -> Int {
        var price = 0
        var parkedTimeDivide: Double = 0.0
        
        if parkedTime < 120 {
            price = vehicleType.fee
//            parkedTimeDivide = (Double(parkedTime) / 15.0)
//            price = 5 * Int(parkedTimeDivide)
        }else {
            parkedTimeDivide = (Double(parkedTime - 120) / 15.0)
            price = (5 * Int(parkedTimeDivide)) + vehicleType.fee
        }
        
        if hasDiscount {
            price = Int(Double(price)*0.85)
        }
        
        return price
    }
    
    // Retorna la cantidad de vehiculos que han salido y las ganancias obtenidas en el dia
    func countOfTheDay () {
        print("▫️ \(acumVehicles) vehicles have checked out and have earnings of $\(earnings)\n")
    }
    
    // Enlista los vehiculos que hay actualmente en el parqueadero
    func listOfVehicles() {
        print("▫️ The list of plate of vehicles are\n")
        vehicles.map{print("\($0.plate)")}
    }
    
}

// Estructura del vehiculo y sus propiedades
struct Vehicle: Parkable, Hashable {
    
    let plate: String
    let type: VehicleType
    var checkInTime: Date
    var discountCard: String?
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(plate)
    }
    
    static func ==(lhs: Vehicle, rhs: Vehicle) -> Bool {
        return lhs.plate == rhs.plate
    }
    
    var parkedTime: Int {
        Calendar.current.dateComponents([.minute], from: checkInTime, to: Date()).minute ?? 0
    }
    
}

// Tipos de Vehiculos
enum VehicleType {
    case car
    case motorcycle
    case miniBus
    case bus
    
    var fee: Int {
        switch self  {
        case .car: return 20
        case .motorcycle: return 15
        case .miniBus: return 25
        case .bus: return 30
        }
    }
}

var alkeParking = Parking()

// Array de vehiculos para ingresar al parqueadero
let vehicles = [
    Vehicle(plate: "AA111AA", type: VehicleType.car, checkInTime: Date(), discountCard: "DISCOUNT_CARD_001"),
    Vehicle(plate: "B222BBB", type: VehicleType.motorcycle, checkInTime: Date(), discountCard: nil),
    Vehicle(plate: "CC333CC", type: VehicleType.miniBus, checkInTime: Date(), discountCard: nil),
    Vehicle(plate: "DD444DD", type: VehicleType.bus, checkInTime: Date(), discountCard: "DISCOUNT_CARD_002"),
    Vehicle(plate: "AA111BB", type: VehicleType.car, checkInTime: Date(), discountCard: "DISCOUNT_CARD_003"),
    Vehicle(plate: "B222CCC", type: VehicleType.motorcycle, checkInTime: Date(), discountCard: "DISCOUNT_CARD_004"),
    Vehicle(plate: "CC333DD", type: VehicleType.miniBus, checkInTime: Date(), discountCard: nil),
    Vehicle(plate: "DD444EE", type: VehicleType.bus, checkInTime: Date(), discountCard: "DISCOUNT_CARD_005"),
    Vehicle(plate: "AA111CC", type: VehicleType.car, checkInTime: Date(), discountCard: nil),
    Vehicle(plate: "B222DDD", type: VehicleType.motorcycle, checkInTime: Date(), discountCard: nil),
    Vehicle(plate: "CC333EE", type: VehicleType.miniBus, checkInTime: Date(), discountCard: nil),
    Vehicle(plate: "DD444GG", type: VehicleType.bus, checkInTime: Date(), discountCard: "DISCOUNT_CARD_006"),
    Vehicle(plate: "AA111DD", type: VehicleType.car, checkInTime: Date(), discountCard: "DISCOUNT_CARD_007"),
    Vehicle(plate: "B222EEE", type: VehicleType.motorcycle , checkInTime: Date(), discountCard: nil),
    Vehicle(plate: "CC333FF", type: VehicleType.miniBus, checkInTime: Date(), discountCard: nil),
    Vehicle(plate: "CC3334E", type: VehicleType.miniBus, checkInTime: Date(), discountCard: nil),
    Vehicle(plate: "DD4447G", type: VehicleType.bus, checkInTime: Date(), discountCard: "DISCOUNT_CARD_006"),
    Vehicle(plate: "AA111HD", type: VehicleType.car, checkInTime: Date(), discountCard: "DISCOUNT_CARD_007"),
    Vehicle(plate: "B222E3E", type: VehicleType.motorcycle , checkInTime: Date(), discountCard: nil),
    Vehicle(plate: "B222E34", type: VehicleType.motorcycle , checkInTime: Date(), discountCard: nil),
    Vehicle(plate: "B245E34", type: VehicleType.motorcycle , checkInTime: Date(), discountCard: nil), // Excede la cantidad de autos permitidos
    Vehicle(plate: "B222E3E", type: VehicleType.motorcycle , checkInTime: Date(), discountCard: nil) // Valor plate repetido
]

// Ingresar los vehiculos uno a uno
vehicles.forEach {
    alkeParking.checkInVehicle($0) { response in
        response ? print("Welcome to AlkeParking") : print("Sorry, the check-in failed")
    }
}


// Hacer el checkOut de los vehiculos
alkeParking.checkOutVehicle("AA111HD") { priceToPay in
    print("\n▫️ Your fee is $\(priceToPay)\n")
} onError: {
    print("▫️ Sorry, the check-out failed\n")
}

// Hacer el checkOut de los vehiculos
alkeParking.checkOutVehicle("AA156HD") { priceToPay in
    print("\n▫️ Your fee is $\(priceToPay)\n")
} onError: {
    print("▫️ Sorry, the check-out failed\n")
}


// LLamado a la funcion que retorna la cantidad de vehiculos que han salido y las ganancias obtenidas en el dia
alkeParking.countOfTheDay()


// Llamada a la funcion que enlista los vehiculos que hay actualmente en el parqueadero
alkeParking.listOfVehicles()
