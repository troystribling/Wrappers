// Playground - noun: a place where people can play

import UIKit
import Wrappers

var x : Int? = 6

let j = flatmap(x) {value -> Double? in
    if value > 3 {
        return nil
    } else {
        return 2 * Double(value)
    }
}

