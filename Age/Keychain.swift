import Foundation

@MainActor
class Keychain: ObservableObject {
    static let ageKeychainLabel = "Age"

    @Published var keys: [Key] = []

    func loadKeys() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrLabel as String: Self.ageKeychainLabel,
            kSecReturnAttributes as String: true,
            kSecMatchLimit as String: kSecMatchLimitAll,
        ]

        var result: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status == errSecSuccess else {
            if let err = SecCopyErrorMessageString(status, nil) {
                debugPrint("\(#file)[\(#line)]: failed to query Keychain: \(err)")
            } else {
                debugPrint("\(#file)[\(#line)]: failed to query Keychain: unknown error code \(status)")
            }
            return
        }
        guard let items = result as? [[String: Any]] else {
            debugPrint("\(#file)[\(#line)]: Couldn't convert result")
            return
        }
        var keys: [Key] = []
        for item in items {
            guard let name = item[kSecAttrAccount as String] as? String else {
                debugPrint("\(#file)[\(#line)]: Couldn't fetch kSecAttrAccount as String")
                continue
            }
            guard let pubKey = item[kSecAttrService as String] as? String else {
                debugPrint("\(#file)[\(#line)]: Couldn't fetch kSecAttrService as String")
                continue
            }
            keys.append(Key(name: name, key: pubKey, createdDate: Date.now))
        }
        keys.sort()
        self.keys = keys
    }

    func save(name: String, publicKey: String, privateKey: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrLabel as String: Self.ageKeychainLabel,
            kSecAttrAccount as String: name,
            kSecAttrService as String: publicKey,
            kSecValueData as String: privateKey.data(using: .ascii)!,
        ]

        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            if let err = SecCopyErrorMessageString(status, nil) {
                debugPrint("\(#file)[\(#line)]: failed to save: \(err)")
            } else {
                debugPrint("\(#file)[\(#line)]: failed to save: unknown error code \(status)")
            }
            return
        }
        loadKeys()
    }

    func delete(name: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrLabel as String: Self.ageKeychainLabel,
            kSecAttrAccount as String: name,
        ]

        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess {
            if let err = SecCopyErrorMessageString(status, nil) {
                debugPrint("\(#file)[\(#line)]: failed to delete key \(name): \(err)")
            } else {
                debugPrint("\(#file)[\(#line)]: failed to delete key \(name): unknown error code \(status)")
            }
        }
        loadKeys()
    }
}
