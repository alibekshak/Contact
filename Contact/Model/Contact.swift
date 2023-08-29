import Foundation

protocol ContactProtocol{
    var title: String {get set}
    var phone: String {get set}
    
}


struct Contact: ContactProtocol{
    var title: String
    var phone: String
    
}


protocol ContactStorageProtocol{
    // загрузка списка контактов
    func load() -> [ContactProtocol]
    // обнавление контактов
    func save(contacts: [ContactProtocol])
}


class ContactStorage: ContactStorageProtocol{
    private var storage = UserDefaults.standard
    // ключ для сохранения данных в хранилище
    private var storageKey = "contacts"
    
    private enum ContactKey: String{
        case title
        case phone
    }
    
    func load() -> [ContactProtocol] {
        var resultContacts: [ContactProtocol] = []
        let contactFromStorage = storage.array(forKey: storageKey) as? [[String: String]] ?? []
        for contact in contactFromStorage {
            guard let title = contact[ContactKey.title.rawValue],
                  let phone = contact[ContactKey.phone.rawValue] else{
                continue
            }
            resultContacts.append(Contact(title: title, phone: phone))
        }
        return resultContacts
    }
    
    func save(contacts: [ContactProtocol]) {
        var arrayForStorage: [[String: String]] = []
        contacts.forEach{ contact in
            var newElementForStorage: Dictionary<String, String> = [:]
            newElementForStorage[ContactKey.title.rawValue] = contact.title
            newElementForStorage[ContactKey.phone.rawValue] = contact.phone
            arrayForStorage.append(newElementForStorage)
        }
        storage.set(arrayForStorage, forKey: storageKey)
    }
    
}
