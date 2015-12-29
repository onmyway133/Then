//
//  ViewController.swift
//  Then
//
//  Created by Khoa Pham on 12/28/2015.
//  Copyright (c) 2015 Khoa Pham. All rights reserved.
//

import UIKit
import Then

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        action()
    }

    func action() {
        let promise = (Promise<String>(result: .Fulfilled(value: "then"))
            .then { result in
                return result.map { value in
                    return value.characters.count
                }
            } as Promise<Int>)
            .then { result in
                return result.map { value in
                    return value * 2
                }
            } as Promise<Int>

        promise.then { result in
            if case let .Fulfilled(value) = result {
               print(value)
            } else {
                print("something went wrong")
            }

            return nil
            } as Promise<Int>
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

