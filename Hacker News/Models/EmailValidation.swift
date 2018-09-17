//
//  EmailValidation.swift
//  Hacker News
//
//  Created by Admin on 15/09/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
extension String{
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
}
