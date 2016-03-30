//
//  ViewController.swift
//  TableViewDemo
//
//  Created by wangchaojs02 on 16/3/30.
//  Copyright © 2016年 wangchaojs02. All rights reserved.
//

import UIKit

func SSLogInfo(message: String, fileName: String = __FILE__, lineNumber: Int = __LINE__, functionName: String = __FUNCTION__) {
    print("[\((fileName as NSString).lastPathComponent as String):\(lineNumber) \(functionName)] \(message)")
}

class ViewController: UIViewController {
    @IBOutlet weak var feedListView: UITableView!
    var feedViewModels: [FeedViewModel] = []
    var templeteCells: [String: UITableViewCell] = [:]
}

// MARK: -
extension ViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFeedListView()
        loadFeedList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// MARK: - IBAction
extension ViewController {
    @IBAction func add1Item(sender: AnyObject) {
    }
    @IBAction func add10Items(sender: AnyObject) {
    }
    @IBAction func add100Items(sender: AnyObject) {
    }
}

// MARK: - Data
extension ViewController {
    func loadFeedList() {
        SSLogInfo("")
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            var feedViewModels = [FeedViewModel]()
            for _ in 0 ... 10 {
                let title = self.randomText(min: 3, max: 20) // "Title"
                let summary = self.randomText(min: 3, max: 200) // "Summary"
                feedViewModels.append(FeedViewModel(title: title, summary: summary))
            }

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.2 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { [weak self] in
                guard let context = self else { return }
                context.feedViewModels = feedViewModels
                context.feedListView.reloadData()
            }
        }
    }

    private func randomText(min min: Int, max: Int) -> String {
        let characters = "静心之余，坐在笔记本前，敲下这些文字，心无杂念，亦无所缠绕。然难的往往是开头，头开了，便可行云流水，无所顾忌地倾流直下，因为，对面是另一个自己。起初只愿怀揣一颗赤子之心，亦如所走过的每一个城市，随心所欲，随行所顾，拍我想拍的风景、说我想说的故事、写我想写的文字、交志同道合的朋友，机缘巧合之下也许就会收获一份意外的事业。然而终究是高估了自己，2014年，号尚未开通，第一次的创业尝试，便将我打入人生低谷，本以为灰暗的世界再无一点光彩。庆幸转念回头的刹那，便是一个新的开始，在互联网发展最为鼎盛的时期，意外闯了进来。人生有的时候，说不出是幸还是不幸，相信好的事情，总会发生也许就发生了，塞翁失马，焉知非福？感念过，感怀过，终究是路过，只是经历已然成了财富，有过一次冒险的尝试，显然不再是初生的牛犊。看似是一个“我的哈欠就是全世界的疲惫”的自我世界，可终究不是黄色的典范，成不了帝王，也从不以结果为导向。我们的存在不是为了改变任何人任何事，这样太累太纠结，何必？委屈了自己也刺痛了别人，只是希望在软化的世界里收获同样的结果，走一段不同的路，将沿途的风光尽收眼底，最终的目的地亦可达到。怀揣着二次的梦想，从过去走向现在，一步，似乎从未回过头。然而，却在那天一次测验中，面对这样一个问题，你认为最大的缺点是？我蹙眉写下这四个字，没有坚持。期待做自己喜欢的事，把它变成吃饭的本领。然漫天的世界声讨毒疫苗时，我没发声；诗隆大婚占据各大媒体头条时，我依旧没发声；朋友把电话本里老公的名字改为太阳的后裔，我只觉得好玩；同学来家里玩，才知道是部韩剧，还特意让我在电脑里安装了爱奇艺视频软件，宋仲基是当下的国民老公······身处这样的行业，无法后知后觉。一个热点可以牵动无数的营销事件，甚至带来巨大的营业额，站在信息潮流的风尖浪口，把握住互联网的风向标，才是生存的手段。只是这里，很少去凑过热闹，借势的人太多，的确，我尚未充足勇气，亦或沉溺在备考的世界，失去了所有可以称为是灵感的东西，而观点是否足够独特，亦成了我的过程挑战，尝试过了，终究不会再有悔意。而今，还记得最初的梦想？梦想是有的，但总是被虚化的玩意，路不同了，最后，也许到达的是同一个殿堂。过尽千帆、风云潮流之后，总希望独自凝望着空无寂寥的世界，亦或对着点点繁星、拼尽全力去细数逝去的流星。亦曾感慨行如流水的思绪，自拟的世界总比命题多一份潇洒，亦可以发挥充分的想象，去描绘最初的模样。可结果却不是所愿的样子！可坚持的已不再是过程，只是最终要到的殿堂罢了！".characters
        let charCount = characters.count
        let length = random() % (max - min) + min
        let stringBuffer = NSMutableString(capacity: length)
        let begin = 0// 0x4E00// 0x20
        let end = charCount// 0x9FA5 // 0x7e
        let range = end - begin

        var text: String = ""

        for _ in 0 ... length {
            let ch = UInt16(begin + random() % range)
            text.append(characters[ch])
            // stringBuffer.appendFormat("%C", characters[ch])
        }

        return text// (stringBuffer as String)
    }
}

// MARK: - FeedListView
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func setupFeedListView() {
        feedListView.dataSource = self
        feedListView.delegate = self
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedViewModels.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        SSLogInfo("")
        guard let cell = tableView.dequeueReusableCellWithIdentifier("FeedListCell") else {
            return UITableViewCell(style: .Default, reuseIdentifier: "FallbackCell")
        }

        return cell
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        SSLogInfo("")
        return 100
    }

    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        SSLogInfo("")
        return 100
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let viewModel = feedViewModels[indexPath.row]
        if var supportViewModelCell = cell as? SupportViewModel {
            supportViewModelCell.viewModel = viewModel
        }
    }

    // MARK: private
    func heightForCellWithIdentifier(identifier: String, viewModel: FeedViewModel) -> CGFloat {
        if templeteCells["identifier"] == nil {
            let templeteCell = feedListView.dequeueReusableCellWithIdentifier(identifier)
            if templeteCell != nil {
                templeteCells["identifier"] = templeteCell
            }
        }

        guard let cell = templeteCells["identifier"] else { return 44 /*Fallback Cell Height*/ }

        let widthConstaint = NSLayoutConstraint(item: cell.contentView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: feedListView.bounds.width)
        if var supportViewModelCell = cell as? SupportViewModel {
            supportViewModelCell.viewModel = viewModel
        }

        cell.contentView.addConstraints([widthConstaint])
        let size = cell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        cell.contentView.removeConstraint(widthConstaint)

        var padding: CGFloat = 0.0
        if feedListView.separatorStyle != .None {
            let scale = UIScreen.mainScreen().scale
            padding = 1.0 / scale
        }

        return size.height + padding
    }
}
