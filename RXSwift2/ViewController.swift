//
//  ViewController.swift
//  RXSwift2
//
//  Created by Eman Khaled on 27/09/2023.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
var disbosableBag = DisposeBag()
    @IBOutlet weak var myLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       // useSubscribeOn()

        //mapObservable()
        //filterObservable()
        //scanObservable()
        //skibObservable()
        skibWhileObservable()
        
    }
    func mapObservable(){
        let observable = Observable.of(1,2,3)
        observable.map({$0 * 2})
            .subscribe{ value in
                print(value)
            } onCompleted: {
                print("onCompleted")
            }.disposed(by: disbosableBag)
    }
    func filterObservable(){
        let observable = Observable.of(1,2,3,4,5,6)
        observable.filter({$0 < 4})
            .subscribe{ value in
                print(value)
            } onCompleted: {
                print("onCompleted")
            }.disposed(by: disbosableBag)
    }
    func scanObservable(){
        let observable = Observable.of(1,2,3)
        observable.scan(0) {(result , item) in
            return result + item
        }
            .subscribe{ value in
                print(value)
            } onCompleted: {
                print("onCompleted")
            }.disposed(by: disbosableBag)
    }
    func skibObservable(){
        let observable = Observable.of(1,2,3,4,5,6)
        observable.skip(2)
            .subscribe{ value in
                print(value)
            } onCompleted: {
                print("onCompleted")
            }.disposed(by: disbosableBag)
    }
    func skibWhileObservable(){
        let observable = Observable.of(1,2,3,4,5,6)
        observable.skip(while: { value in
            value > 2
        })
            .subscribe{ value in
                print(value)
            } onCompleted: {
                print("onCompleted")
            }.disposed(by: disbosableBag)
    }
    

    func useSubscribeOn(){
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else {return}
            let observable = Observable<Int>.create{ observer in
                print("subscribe thread::\(Thread.isMainThread)")
                observer.onNext(1)
                observer.onNext(2)
                observer.onNext(3)
                observer.onCompleted()
                return Disposables.create()
            }
            let mainScheduler = MainScheduler.instance
            let scheduler = ConcurrentDispatchQueueScheduler(qos: .background)
            DispatchQueue.main.async {
                observable.subscribe(on: scheduler)
                    .subscribe{ [weak self] value in
                        guard let self = self else {return }
                        print("observing thread::\(Thread.isMainThread)")
                        self.myLabel.text = "\(value)"
                    }onCompleted: {
                        
                        print("onCompleted")
                    }.disposed(by: self.disbosableBag)
            }
            
            
        }
    }
}

