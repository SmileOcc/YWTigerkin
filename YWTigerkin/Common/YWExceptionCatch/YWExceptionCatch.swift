//
//  YWExceptionCatch.swift
//  YWTigerkin
//
//  Created by odd on 11/2/24.
//

import Foundation
//import YWExceptionOCCatch

public enum YWExceptionCatch {
    /**
    Catch a Objective-C exception.

    - Returns: The value returned from the given callback.

    ```swift
    import Foundation
    import ExceptionCatcher

    final class Foo: NSObject {}

    do {
        let value = try ExceptionCatcher.catch {
            return Foo().value(forKey: "nope")
        }

        print("Value:", value)
    } catch {
        print("Error:", error.localizedDescription)
        //=> Error: The operation couldn’t be completed. [valueForUndefinedKey:]: this class is not key value coding-compliant for the key nope.
    }
    ```
    */
    @discardableResult
    public static func `catch`<T>(callback: () throws -> T) throws -> T {
        var returnValue: T!
        var returnError: Error?

        try YWExceptionOCCatch.catchException {
            do {
                returnValue = try callback()
            } catch {
                returnError = error
            }
        }

        if let error = returnError {
            throw error
        }

        return returnValue
    }
    
    //没有返回值的
    public static func commonCatch(callback: () throws -> Void) throws {
        var returnError: Error?

        try YWExceptionOCCatch.catchException {
            do {
                try callback()
            } catch {
                returnError = error
            }
        }

        if let error = returnError {
            throw error
        }
    }
}
