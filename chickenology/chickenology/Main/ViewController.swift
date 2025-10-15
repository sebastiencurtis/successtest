
import UIKit
import SwiftUI

var screen = UIScreen.main.bounds

struct ContentView: View {
    @StateObject var loadingManager = LoadingManager()
    
    var body: some View {
        ZStack {
            HomeView()
                .environmentObject(loadingManager)
                .onAppear{
                    loadingManager.isLoading = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                        loadingManager.isLoading = false
                    }
                }
                .overlay {
                    if loadingManager.isLoading{
                        loadingView()
                    }
                }
        }
    }
}
class LoadingManager: ObservableObject {
    @Published var isLoading: Bool = false
}
class ViewController: UIViewController, URLSessionDelegate {
    
    @IBOutlet weak var fill: UIImageView!
    @IBOutlet weak var bg: UIImageView!
    
    var window: UIWindow?
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    let bundleIdentifier = Bundle.main.bundleIdentifier
    var pathIdentifier = ""
    var idUserNumber = ""
    
    let animatedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        let animatedImage = UIImage(named: "loading")
        imageView.image = animatedImage
        return imageView
    }()
    
    var progressValue : Float = 0
//    var animationView = Lottie.LottieAnimationView()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setImages()
        self.window = UIWindow(frame: UIScreen.main.bounds)
//        view.addSubview(animatedImageView)
//        view.bringSubviewToFront(animatedImageView)
//        animatedImageView.snp.makeConstraints{make in
//            make.centerX.equalTo(view.snp.centerX)
//            make.centerY.equalTo(view.snp.centerY)
//            make.height.equalTo(100)
//            make.width.equalTo(50)
//        }
//        animationView.animation = .named("loading")
//        animationView.contentMode = .scaleAspectFit
//        animationView.frame = CGRect(x: 60 , y: view.bounds.height / 2 - 150, width: 300, height: 300 )
//        animationView.loopMode = .loop
//        animationView.contentMode = .scaleToFill
//        animationView.animationSpeed = 1
//        view.addSubview(animationView)
//        animationView.play()
        /*startAnimation*/()
    }
    
    func setImages() {
//        BgFill.backgroundColor = .black
//        view.addSubview(BgFill)
//        BgImage.image = UIImage(named: "bg1")
//        BgImage.alpha = 0.4
//        view.addSubview(BgImage)
    }
    
//    func startAnimation() {
//        guard let animatedImage = animatedImageView.image else { return }
//        animatedImageView.animationImages = animatedImage.images
//        animatedImageView.animationDuration = animatedImage.duration
//        animatedImageView.animationRepeatCount = 0
//        animatedImageView.startAnimating()
//    }
    func startLoading() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            if self.pathIdentifier == ""{
                self.sendToRequest()
            }
        }
    }
    
    func Apps() {
        let preland = Helper()
        preland.sourceData = self.pathIdentifier
        
        addChild(preland)
        preland.view.alpha = 0
        self.view.addSubview(preland.view)
        
        preland.view.translatesAutoresizingMaskIntoConstraints = false
        preland.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        preland.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        preland.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        preland.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            AppUtility.lockOrientation(.all)
//            self.animationView.isHidden = true
            self.bg.alpha = 0
            self.fill.alpha = 1
            preland.view.alpha = 1
//            self.animationView.stop()
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        completionHandler(nil)
    }
    override var shouldAutorotate: Bool {
        return true
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    func openMenu(){
        bg.alpha = 1
        fill.alpha = 0
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        
        let vc = UIHostingController(rootView: ContentView())
            view.window?.rootViewController = vc
    }
    
    func sendToRequest() {
        let url = URL(string: "https://chickstrike.site/starting")
        let dictionariData: [String: Any?] = [
            "facebook-deeplink" : appDelegate?.deepLinkParameterFB,
            "push-token" : appDelegate?.tokenPushNotification,
            "appsflyer" : appDelegate?.oldAndNotWorkingNames,
            "deep_link_sub2" : appDelegate?.subject2,
            "deepLinkStr": appDelegate?.oneLinkDeepLink,
            "timezone-geo": appDelegate?.geographicalNameTimeZone,
            "timezome-gmt" : appDelegate?.abbreviationTimeZone,
            "apps-flyer-id": appDelegate!.uniqueIdentifierAppsFlyer,
            "attribution-data" : appDelegate?.dataAttribution,
            "deep_link_sub1" : appDelegate?.subject1,
            "deep_link_sub3" : appDelegate?.subject3,
            "deep_link_sub4" : appDelegate?.subject4,
            "deep_link_sub5" : appDelegate?.subject5]
        
        print(dictionariData)
        var request = URLRequest(url: url!)
        let json = try? JSONSerialization.data(withJSONObject: dictionariData)
        request.httpBody = json
        request.httpMethod = "POST"
        request.addValue(appDelegate!.identifierAdvertising, forHTTPHeaderField: "GID")
        request.addValue(bundleIdentifier!, forHTTPHeaderField: "PackageName")
        request.addValue(appDelegate!.uniqueIdentifierAppsFlyer, forHTTPHeaderField: "ID")
        let configuration = URLSessionConfiguration.ephemeral
        configuration.waitsForConnectivity = false
        configuration.timeoutIntervalForResource = 60
        configuration.timeoutIntervalForRequest = 60
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { [self] (data, response, error) in
            
            guard let data = data, error == nil else {
                DispatchQueue.main.async { [self] in
                    openMenu()
                }
                return
            }
            print(data)
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            print(responseJSON)
            if let responseJSON = responseJSON as? [String: Any] {
                
                if let result = responseJSON["result"] as? String {
                    self.pathIdentifier = result
                } else {
                    self.pathIdentifier = ""
                }
                let user = responseJSON["userID"] as? String
                self.idUserNumber = "\(user)"
                print(responseJSON)
            }
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    openMenu()
                } else if response.statusCode == 302 {
                    if self.pathIdentifier != "" {
                        self.Apps()
                    }
                } else {
                }
            }
            return
        }
        task.resume()
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
extension UIWindow {
    
    func switchRootViewController(_ viewController: UIViewController,
                                  animated: Bool = true,
                                  duration: TimeInterval = 0.5,
                                  options: AnimationOptions = .transitionFlipFromRight,
                                  completion: (() -> Void)? = nil) {
        guard animated else {
            rootViewController = viewController
            return
        }
        
        UIView.transition(with: self, duration: duration, options: options, animations: {
            let oldState = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            self.rootViewController = viewController
            UIView.setAnimationsEnabled(oldState)
        }, completion: { _ in
            completion?()
        })
    }
    
}
struct AppUtility {
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
        self.lockOrientation(orientation)
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
    }
}

