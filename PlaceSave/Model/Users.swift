

import Foundation

class Users {
    
    
    private var _email: String
    private var _provider: String
    
    var email: String {
        return _email
    }
    
    var provider: String {
        return _provider
    }
    
    init(email: String, provider: String) {
        self._email = email
        self._provider = provider
    }
    
}
