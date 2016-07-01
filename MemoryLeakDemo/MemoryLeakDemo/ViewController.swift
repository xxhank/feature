//
//  ViewController.swift
//  MemoryLeakDemo
//
//  Created by wangchao on 16/6/26.
//  Copyright © 2016年 wangchao. All rights reserved.
//

import UIKit

func traceDie(identifier: AnyObject) {
    print("\(identifier) died at \(NSDate())")
}

class Worker {
    var percent = 0.0
    var label: UILabel?
    var name = ""
    init(name: String) {
        self.name = name
        print("\(name) init at \(NSDate())")
    }
    deinit {
        print("\(name) died at \(NSDate())")
    }

    func run () {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0)) { [weak self] in
            self?.percent += 1.0
            NSThread.sleepForTimeInterval(10)
            print("\(self?.name) work finished at \(NSDate())")
            NSThread.sleepForTimeInterval(5)
            self?.report()
        }
    }

    func report() {
        print("\(name) report at \(NSDate())")
        dispatch_async(dispatch_get_main_queue(), {
            self.label?.text = "\(self.percent)"
        })
    }
}

class WorkerWithDispatch: Worker {
    override func run () {
        Dispatch.async_in_global(.DEFAULT) { [weak self] in
            self?.percent += 1.0
            NSThread.sleepForTimeInterval(10)
            print("\(self?.name) work finished at \(NSDate())")
            NSThread.sleepForTimeInterval(5)
            self?.report()
        }
    }
    override func report() {
        print("\(name) report at \(NSDate())")
        Dispatch.async_on_ui {
            self.label?.text = "\(self.percent)"
        }
    }
}

class TimerWorker: SSCancelable {
    typealias Completion = (finished: Bool) -> Void
    var timer: NSTimer?
    var completion: Completion?

    deinit {
        traceDie("\(self)");
    }

    func run(interval: NSTimeInterval, completion: Completion) {
        self.completion = completion
        timer = NSTimer.scheduledTimerWithTimeInterval(interval, target: self, selector: #selector(TimerWorker.doWork), userInfo: nil, repeats: false)
    }

    func cancel() {
        guard let timer = timer else { return }
        if timer.valid {
            timer.invalidate()
            self.timer = nil
        }

        if let completion = completion {
            completion(finished: false)
        }
    }

    @objc func doWork() {
        if let completion = completion {
            completion(finished: true)
        }
        self.timer = nil
    }
}

class WorkerBusiness: Business {

    var percent = 0.0
    var label: UILabel?
    var name = ""
    init(name: String) {
        self.name = name
        print("\(name) init at \(NSDate())")
    }

    required internal init() {
        fatalError("init() has not been implemented")
    }

    deinit {
        print("\(name) died at \(NSDate())")
    }

    var task: BusinessTypes<Float>.Task?
    func runWithKeepTask() -> BusinessTypes<Float>.Task {
        let task: BusinessTypes<Float>.Task? = runTask { [weak self](fulfill, reject) -> SSCancelable? in
            let worker = TimerWorker()
            worker.run(5, completion: { [weak self](finished) in
                guard let wself = self else { return }
                print("\(wself.name) work finished at \(NSDate())")
                if finished {
                    NSThread.sleepForTimeInterval(2)
                    wself.report()
                    print("\(wself.name) report finished at \(NSDate())")

                    fulfill(1.0)
                } else {
                    reject(NSError(domain: "xxx", code: -1, userInfo: nil))
                }
            })

            return worker
        }
        self.task = task
        return task!
    }
    func run() -> BusinessTypes<Float>.Task {
        let task: BusinessTypes<Float>.Task? = runTask { [weak self](fulfill, reject) -> SSCancelable? in
            guard let wself = self else { return nil }
            let worker = TimerWorker()
            worker.run(5, completion: { [weak wself](finished) in
                guard let wself = wself else { return }
                print("\(wself.name) work finished at \(NSDate())")

                if finished {
                    NSThread.sleepForTimeInterval(2)
                    wself.report()
                    print("\(wself.name) report finished at \(NSDate())")

                    fulfill(1.0)
                } else {
                    reject(NSError(domain: "xxx", code: -1, userInfo: nil))
                }
            })

            return worker
        }
        return task!
    }

    func runWithNestTask() -> BusinessTypes<Float>.Task {
        return runTask({ [weak self](fulfill, reject) -> SSCancelable? in
            guard let wself = self else { return nil }
            wself.run().success({ [weak self] /*不加weak wself会导致self被强引用,只有在任务结束后self才会被释放*/
                (value) -> Void in
                guard let wself = self else { return }
                self?.name = "啦啦";// self不会等待任务结束
                wself.name = "wself";//
                fulfill(value)
            }).failure({ (error, isCancelled) in
                guard !isCancelled else { return }
                if let error = error {
                    reject(error)
                }
            })

            return nil
        })
    }

    func runWithNestTask2() -> BusinessTypes<Float>.Task {
        return runTask({ [weak self](fulfill, reject) -> SSCancelable? in
            guard let wself = self else { return nil }
            wself.name = "ww";
            wself.run().success({ [weak self] /*不加weak wself会导致self被强引用,只有在任务结束后self才会被释放*/
                (value) -> Void in
                guard let wself = self else { return }
                self?.name = "啦啦";// self不会等待任务结束
                wself.name = "wself";//
                fulfill(value)
            }).failure({ (error, isCancelled) in
                guard !isCancelled else { return }
                if let error = error {
                    reject(error)
                }
            })

            return nil
        })
    }

    func report() {
        print("\(name) report at \(NSDate()) :\(self.percent)")
        Dispatch.async_on_ui {
            self.label?.text = "\(self.percent)"
        }
    }
}

class TestTask {
    typealias TaskBlock = () -> Void
    var name: String
    var block: TaskBlock
    init(name: String, block: TaskBlock) {
        self.name = name
        self.block = block
    }
}
class ViewController: UIViewController {
    var tasks: [TestTask]? = []

    func createTasks() {
        tasks?.append(TestTask(name: "work1", block: {
            let worker = Worker(name: "work1")
            worker.run()
            worker.report()
            }))

        tasks?.append(TestTask(name: "work2", block: {
            let worker = WorkerWithDispatch(name: "work2")
            worker.run()
            worker.report()
            }))

        tasks?.append(TestTask(name: "work3", block: {
            // let workerCauseFatal = WorkerBusiness()
            let worker = WorkerBusiness(name: "work3")
            worker.run().success({ (percent) in
                print("success \(percent)")
            }).failure({ (error, isCancelled) in
                print("cancelled:\(isCancelled) error:\(error) ")
            })
            worker.report()
            }))

        tasks?.append(TestTask(name: "work4", block: {
            // let workerCauseFatal = WorkerBusiness()
            let worker = WorkerBusiness(name: "work4")
            worker.runWithKeepTask().success({ (percent) in
                print("success \(percent)")
            }).failure({ (error, isCancelled) in
                print("cancelled:\(isCancelled) error:\(error) ")
            })
            worker.report()
            }))
        tasks?.append(TestTask(name: "work5", block: {
            // let workerCauseFatal = WorkerBusiness()
            let worker = WorkerBusiness(name: "work5")
            worker.runWithNestTask().success({ (percent) in
                print("success \(percent)")
            }).failure({ (error, isCancelled) in
                print("cancelled:\(isCancelled) error:\(error) ")
            })
            worker.report()
            }))

        tasks?.append(TestTask(name: "work6", block: {
            // let workerCauseFatal = WorkerBusiness()
            let worker = WorkerBusiness(name: "work6")
            worker.runWithNestTask2().success({ (percent) in
                print("success \(percent)")
            }).failure({ (error, isCancelled) in
                print("cancelled:\(isCancelled) error:\(error) ")
            })
            worker.report()
            }))
    }

    var somethingIsDone = false
    override func viewDidLoad() {
        super.viewDidLoad()
        doSomething()
        return;
        print("viewDidLoad begin")

        print("before dispatch_async 1")
        dispatch_async(dispatch_get_main_queue()) {
            print("in dispatch_async 1")
            self.somethingIsDone = true
        }

        dispatch_async(dispatch_get_main_queue()) {
            print("in dispatch_async 1 2")
        }

        dispatch_async(dispatch_get_main_queue()) {
            print("in dispatch_async 1 3")
        }

        print("after dispatch_async 1")

        print("before dispatch_async 2")
        Dispatch.async_on_ui {
            print("in dispatch_async 2")
        }
        print("after dispatch_async 2")

        print("viewDidLoad end")
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        return;
        print("viewWillAppear begin")

        print("before dispatch_async 3")
        dispatch_async(dispatch_get_main_queue()) {
            print("in dispatch_async 3")
        }
        print("after dispatch_async 3")

        print("before dispatch_async 4")
        Dispatch.async_on_ui {
            print("in dispatch_async 4")
        }
        print("after dispatch_async 4")

        print("viewWillAppear end")

        if somethingIsDone {
            print("somethingIsDone")
        } else {
            print("do something first")
        }
    }

    var count = 0
    func doSomething() {
        count += 1

        #if false
            // 确保当前函数执行完成之后,somethingDelegateMethod才会被调用
            dispatch_async(dispatch_get_main_queue()) {
                self.somethingDelegateMethod()
            }
        #else
            /// 直接调用somethingDelegateMethod, 调用后的函数行为无法确定
            somethingDelegateMethod()
        #endif
        if count == 1 {
            print("except")
        } else {
            print ("who change me")
        }
    }

    func somethingDelegateMethod() {
        count += 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks?.count ?? 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "Task Cell"
        if let cell = tableView.dequeueReusableCellWithIdentifier(identifier) {
            return cell
        } else {
            return UITableViewCell(style: .Default, reuseIdentifier: identifier)
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        guard let tasks = tasks else { return }
        let task = tasks[indexPath.row]
        cell.textLabel?.text = task.name
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let tasks = tasks else { return }
        let task = tasks[indexPath.row]
        task.block()
    }
}

