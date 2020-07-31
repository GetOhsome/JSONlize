import Foundation

open class JSONlize{
    public static let shared = JSONlize()
    
    enum item {
        case string(_ value: String)
        case plural(_ value: [String : String])
        case dict(_ value: [String: String])
    }
    
    public enum LocalizedType {
        case string
        case plural(_ input: Int)
        case dict(_ key: String)
    }
    
    enum LocalizeError: Error{
        case desiredLanguageNotFound(_ msg: String)
        case fallbackLanguageNotFound(_ msg: String)
        case jsonParse(_ msg: String)
    }
    
    var items = [String: item]()

    
    var fallbackLanguage: String!
    public typealias Filehandler = ((_ language: String) -> URL?)
    
    public func load(fileHandler: Filehandler, defaultLanguage: String){
        do{
            let data = try loadDataFromFile(fileHandler: fileHandler, defaultLanguage: defaultLanguage)
            let serialization = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
            let serialized = serialization as! [String : Any]
            
            for (key, value) in serialized{
                if let dict = value as? [String : [String: String]]{
                    if let pluralDict = dict["plurals"]{
                        items[key] = .plural(pluralDict)
                    }
                    else if let pluralDict = dict["keys"]{
                        items[key] = .dict(pluralDict)
                    }
                    continue
                }
                items[key] = .string(value as! String)
            }

        }
        catch(let error){
            let error = error as? LocalizeError
            switch error {
                case .desiredLanguageNotFound(let msg):
                    print(msg)
                case .fallbackLanguageNotFound(let msg):
                    print(msg)
                case .jsonParse(let msg):
                    print(msg)
                default:
                    fatalError("Failed to load Localize")
            }
        }
    }
    
    private func loadDataFromFile(fileHandler: Filehandler, defaultLanguage: String) throws -> Data{
        let localeString = String(Locale.preferredLanguages.first ?? defaultLanguage)
        do{
            guard let url = fileHandler(localeString) else {
                throw LocalizeError.desiredLanguageNotFound("could not find desiredLanguage \(localeString)")
            }
            return try Data(contentsOf: url, options: .alwaysMapped)
        }
        catch{
            guard let url = fileHandler(defaultLanguage) else {
                throw LocalizeError.fallbackLanguageNotFound("could not find fallbackLanguage \(defaultLanguage)")
            }
            guard let data = try? Data(contentsOf: url, options: .alwaysMapped) else {
                throw LocalizeError.jsonParse("failed to parse json")
            }
            return data
        }
    }
}

public extension String{
    
    var JSONlized: String{
        return JSONlized(.string)
    }
    
    func format(_ args: CVarArg...) -> String{
        return String(format: self, arguments: args)
    }
    
    func JSONlized(_ localizedType: JSONlize.LocalizedType) -> String{
        switch localizedType {
            case .plural(let input):
                return pluralized(input: input)
            case .dict(let key):
                return localized(key)
            default:
                return localizedString()
        }
    }
    
    //string
    private func localizedString() -> String{
        let item = JSONlize.shared.items[self]
        switch item {
            case .string(let value):
                return value
            default:
                return self
        }
    }
    
    //dictionary
    private func localized(_ key: String) -> String{
        let item = JSONlize.shared.items[self]
        switch item {
            case .dict(let value):
                if let out = value[key]{
                    return out
                }
                else{
                    return self
                }
            default:
                return self
        }
    }
    
    //plurals
    private func pluralized(input: Int) -> String{
        let item = JSONlize.shared.items[self]
        switch item {
            case .plural(let value):
                if let out = value["\(input)"]{
                    return out.replacingOccurrences(of: "${i}", with: String(input))
                }
                else if let out = value["*"]{
                    return out.replacingOccurrences(of: "${i}", with: String(input))
                }
                else{
                    return self
                }
            default:
                return self
        }
    }
}
