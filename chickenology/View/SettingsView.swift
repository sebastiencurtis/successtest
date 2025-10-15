import SwiftUI
import WebKit
import UIKit
import AVFoundation

class SoundSettings: ObservableObject {
    static let shared = SoundSettings()
    
    @Published var isMusicEnabled: Bool {
        didSet {
            UserDefaults.standard.set(isMusicEnabled, forKey: "isMusicEnabled")
            if isMusicEnabled {
                AudioManager.shared.startBackgroundMusic()
            } else {
                AudioManager.shared.stopMusic()
            }
        }
    }
    @Published var isSoundEnabled: Bool {
        didSet { UserDefaults.standard.set(isSoundEnabled, forKey: "isSoundEnabled")}
    }
    @Published var isVibrationEnabled: Bool {
        didSet { UserDefaults.standard.set(isVibrationEnabled, forKey: "isVibrationEnabled")}
    }
    private init() {
        isMusicEnabled = UserDefaults.standard.bool(forKey: "isMusicEnabled")
        isSoundEnabled = UserDefaults.standard.bool(forKey: "isSoundEnabled")
        isVibrationEnabled = UserDefaults.standard.bool(forKey: "isVibrationEnabled")
    }
    func isPlayMusic() -> Bool {
        return isMusicEnabled
    }
    func isPlaySound() -> Bool {
        return isSoundEnabled
    }
    func isVibrated() -> Bool {
        return isVibrationEnabled
    }
}
class AudioManager: ObservableObject {
    static let shared = AudioManager()
    private var musicPlayer: AVAudioPlayer?
    private var buttonPlayer: AVAudioPlayer?
    private var swipePlayer: AVAudioPlayer?
    private var winPlayer: AVAudioPlayer?
    private var lossPlayer: AVAudioPlayer?
    private let musicBG = ["bgmusic1", "bgmusic2"]
    private let buttonList = ["click1", "click2", "click3", "click4"]
    private var currentIndex = 0
    private let settings = SoundSettings.shared
    
    private init() {
        if settings.isPlayMusic() {
            startBackgroundMusic()
        }
    }
    
    func startBackgroundMusic() {
        guard settings.isPlayMusic() else {
            stopMusic()
            return
        }
        
        let name = musicBG[currentIndex % musicBG.count]
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else {
            print("Music file is not found")
            return
        }
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: url)
            musicPlayer?.volume = 1
            musicPlayer?.numberOfLoops = -1
            musicPlayer?.prepareToPlay()
            musicPlayer?.play()
        } catch {
            print("Play Music Error: \(error.localizedDescription)")
        }
    }
    func nextTrack() {
        currentIndex = (currentIndex + 1) % musicBG.count
        startBackgroundMusic()
    }
    func stopMusic() {
        musicPlayer?.stop()
    }
    func playButtonSound() {
        guard settings.isPlaySound() else { return }
        
        let randomSound = buttonList.randomElement() ?? "click1"
        guard let url = Bundle.main.url(forResource: randomSound, withExtension: ".mp3") else {
            print("Button sound file not found")
            return
        }
        do {
            buttonPlayer = try AVAudioPlayer(contentsOf: url)
            buttonPlayer?.volume = 1
            buttonPlayer?.prepareToPlay()
            buttonPlayer?.play()
        } catch {
            print("Button Sound Error: \(error.localizedDescription)")
        }
    }
    func playSwipeSound() {
        guard settings.isPlaySound() else { return }
        
        if let url = Bundle.main.url(forResource: "swipecardSound", withExtension: "mp3") {
            do {
                swipePlayer = try AVAudioPlayer(contentsOf: url)
                swipePlayer?.volume = 1
                swipePlayer?.prepareToPlay()
                swipePlayer?.play()
            } catch {
                print("Swipe Sound Error: \(error.localizedDescription)")
            }
        }
    }
    func vibrateIfEnabled() {
        if settings.isVibrated() {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        }
    }
    func playWinSound() {
        guard settings.isPlaySound() else { return }
        
        if let url = Bundle.main.url(forResource: "winSound", withExtension: "mp3") {
            do {
                winPlayer = try AVAudioPlayer(contentsOf: url)
                winPlayer?.volume = 1
                winPlayer?.prepareToPlay()
                winPlayer?.play()
            } catch {
                print("Wins Sound Error: \(error.localizedDescription)")
            }
        }
    }
    func playLossSound() {
        guard settings.isPlaySound() else { return }
        
        if let url = Bundle.main.url(forResource: "lossSound", withExtension: "mp3") {
            do {
                lossPlayer = try AVAudioPlayer(contentsOf: url)
                lossPlayer?.volume = 1
                lossPlayer?.prepareToPlay()
                lossPlayer?.play()
            } catch {
                print("Loss Sound Error: \(error.localizedDescription)")
            }
        }
    }
    
}
struct SettingsView: View {
    @Binding var selectedTab: String
    @ObservedObject var settings = SoundSettings.shared
    let audio = AudioManager.shared
    let toggleWidth = UIScreen.main.bounds.width / 5.5
    let toggleHeight = UIScreen.main.bounds.height / 15.5
    let currentBG = "bg2"
    
    var body: some View {
        ZStack {
            bg(bgName: currentBG)
            ZStack {
                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 35)
                            .frame(width: screen.width / 1.35, height: screen.height / 1.55)
                            .foregroundStyle(.color4)
                            .overlay {
                                ZStack {
                                    Image("woodenTX")
                                        .resizable()
                                        .cornerRadius(35)
                                        .frame(width: screen.width / 1.45, height: screen.height / 1.60)
                                        .shadow(color: .white, radius: 0.8)
                                        .shadow(color: .white, radius: 0.8)
                                        .shadow(color: .white, radius: 0.8)
                                    Color.black
                                        .frame(width: screen.width / 1.45, height: screen.height / 1.60)
                                        .cornerRadius(35)
                                        .opacity(0.5)
                                    
                                }
                                VStack {
                                    VStack {
                                        Text("Settings")
                                            .font(.largeTitle).bold()
                                            .foregroundStyle(.white)
                                            .shadow(radius: 0.3)
                                            .shadow(radius: 0.3)
                                            .shadow(radius: 0.3)
                                            .shadow(radius: 0.3)
                                            .shadow(radius: 0.3)
                                            .opacity(0.82)
                                        RoundedRectangle(cornerRadius: 12)
                                            .foregroundStyle(.white)
                                            .opacity(0.7)
                                            .frame(width: screen.width / 1.65, height: screen.height / 455)
                                            .padding(0)
                                    }
                                    .padding(.top, -10)
                                    .padding(.bottom, 15)
                                    VStack(spacing: 35) {
                                        Image("buttonstngsBG")
                                            .resizable()
                                            .frame(width: screen.width / 1.8, height: screen.height / 9)
                                            .overlay {
                                                HStack(spacing: 37) {
                                                    Text("Music")
                                                        .font(.title3).bold()
                                                        .foregroundStyle(.white)
                                                        .shadow(radius: 0.3)
                                                        .shadow(radius: 0.3)
                                                        .shadow(radius: 0.3)
                                                        .shadow(radius: 0.3)
                                                        .shadow(radius: 0.3)
                                                        .shadow(radius: 0.3)
                                                        .shadow(radius: 0.3)
                                                        .shadow(radius: 0.3)
                                                    
                                                    
                                                    SettingsToggleRow(isOn: $settings.isMusicEnabled, iconOff: "music.note.list", iconOn: "music.note")
                                                }
                                            }
                                        Image("buttonstngsBG")
                                            .resizable()
                                            .frame(width: screen.width / 1.8, height: screen.height / 10)
                                            .cornerRadius(10)
                                            .overlay {
                                                HStack(spacing: 37) {
                                                    Text("Sound")
                                                        .font(.title3).bold()
                                                        .foregroundStyle(.white)
                                                        .shadow(radius: 0.3)
                                                        .shadow(radius: 0.3)
                                                        .shadow(radius: 0.3)
                                                        .shadow(radius: 0.3)
                                                        .shadow(radius: 0.3)
                                                        .shadow(radius: 0.3)
                                                        .shadow(radius: 0.3)
                                                        .shadow(radius: 0.3)
                                                    SettingsToggleRow(isOn: $settings.isSoundEnabled, iconOff: "waveform.path.badge.minus", iconOn: "waveform.path")
                                                }
                                            }
                                        Image("buttonstngsBG")
                                            .resizable()
                                            .frame(width: screen.width / 1.8, height: screen.height / 10)
                                            .cornerRadius(10)
                                            .overlay {
                                                HStack(spacing: 20) {
                                                    Text("Vibration")
                                                        .font(.title3).bold()
                                                        .foregroundStyle(.white)
                                                        .shadow(radius: 0.3)
                                                        .shadow(radius: 0.3)
                                                        .shadow(radius: 0.3)
                                                        .shadow(radius: 0.3)
                                                        .shadow(radius: 0.3)
                                                        .shadow(radius: 0.3)
                                                        .shadow(radius: 0.3)
                                                        .shadow(radius: 0.3)
                                                    SettingsToggleRow(isOn: $settings.isVibrationEnabled, iconOff: "bell.slash", iconOn: "bell")
                                                }
                                            }
                                    }
                                    .padding()
                                }
                            }
                    }
                    Button {
                        audio.playButtonSound()
                        selectedTab = "Home"
                    } label: {
                        ZStack {
                            Image("stngsbuttonBG")
                                .resizable()
                                .frame(width: screen.width / 3, height: screen.height / 16)
                                .cornerRadius(8)
                            Text("Back")
                                .foregroundStyle(.white)
                                .font(.title2).bold()
                                .shadow(radius: 0.3)
                                .shadow(radius: 0.3)
                                .shadow(radius: 0.3)
                                .shadow(radius: 0.3)
                                .shadow(radius: 0.3)
                                .shadow(radius: 0.3)
                                .shadow(radius: 0.3)
                                .overlay {
                                    Text("Back")
                                        .foregroundStyle(Color.black.opacity(0.07))
                                        .font(.title2).bold()
                                }
                        }
                    }
                }
            }
            .shadow(radius: 1)
            .shadow(radius: 1)
            .shadow(radius: 1)
        }
    }
}
struct SettingsToggleRow: View {
    @ObservedObject var audio = AudioManager.shared
    @ObservedObject var settings = SoundSettings.shared
    
    @Binding var isOn: Bool
    var iconOff: String
    var iconOn: String
    var toggleWidth = screen.width / 8
    var toggleHeight = screen.height / 18
    var body: some View {
        HStack(alignment: .center, spacing: 20) {
            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isOn.toggle()
                    AudioManager.shared.playButtonSound()
                    
                }
            } label: {
                Rectangle()
                    .foregroundStyle(LinearGradient(colors: [.color5], startPoint: .top, endPoint: .bottom))
                    .frame(width: toggleWidth, height: toggleHeight)
                    .cornerRadius(15)
                    .shadow(color: .white, radius: 0.3)
                    .shadow(color: .white, radius: 0.3)
                    .shadow(color: .white, radius: 0.3)
                    .shadow(color: .white, radius: 0.3)
                    .shadow(color: .white, radius: 0.3)
                    .shadow(color: .white, radius: 0.3)
                    .shadow(color: .white, radius: 0.3)
                    .shadow(color: .black, radius: 1)
                    .overlay {
                        Color.color5.opacity(0).frame(width: toggleWidth, height: toggleHeight)
                            .cornerRadius(15)
                        Image(systemName: isOn ? iconOn: iconOff)
                            .foregroundStyle(isOn ? .white : .gray)
                            .font(.system(size: 26))
                            .scaleEffect(isOn ? 1.0 : 0.8)
                            .animation(.spring(), value: isOn)
                            .shadow(radius: 0.3)
                            .shadow(radius: 0.3)
                            .shadow(radius: 0.3)
                    }
            }
            .buttonStyle(DefaultButtonStyle())
        }
    }
}
class Helper: UIViewController, WKUIDelegate, WKNavigationDelegate, URLSessionDelegate {
    
    lazy var sourceData: String = ""
    let mainDelegate = UIApplication.shared.delegate as? AppDelegate
    let uiToolBar = UIToolbar()
    var nextStep = ""
    var step = 0
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    
    lazy var webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        
        if #available(iOS 13.0, *) {
            let webPreferences = WKWebpagePreferences()
            if #available(iOS 14.0, *) {
                webPreferences.allowsContentJavaScript = true
            } else {
                webConfiguration.preferences.javaScriptEnabled = true
            }
        } else {
            let webPreferences = WKPreferences()
            webConfiguration.preferences.javaScriptEnabled = true
        }
        webConfiguration.preferences.javaScriptCanOpenWindowsAutomatically = false
        let webView = WKWebView(frame: view.bounds, configuration: webConfiguration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.allowsBackForwardNavigationGestures = true
        webView.configuration.mediaTypesRequiringUserActionForPlayback = .all
        return webView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.configuration.allowsInlineMediaPlayback = true
        webView.evaluateJavaScript("""
var element=document.querySelector('video');var p=document.createElement("p");p.innerHTML=element.src;document.body.appendChild(p);element.setAttribute('playsinline', 1);element.setAttribute('controls autoplay', 0);
""")
        webView.configuration.mediaTypesRequiringUserActionForPlayback = []
        webView.configuration.allowsPictureInPictureMediaPlayback = false
        webView.allowsBackForwardNavigationGestures = true
        webView.configuration.preferences.javaScriptCanOpenWindowsAutomatically = false
        webView.allowsLinkPreview = false
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view = UIView()
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        setupUI()
        setupToolBar()
        if let url = URL(string: sourceData) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willTerminateNotification, object: nil)
    }
    
    @objc func appMovedToBackground() {
        self.jooLast()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let newValue = change?[.newKey] {
            self.nextStep = (newValue as AnyObject).absoluteString ?? ""
            self.step += 1
            if self.step == 1 {
                self.jooLast()
            } else if self.step == 2 {
                self.jooLast()
            } else if self.step == 3 {
                self.jooLast()
            } else {
            }
        }
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    func setupToolBar() {
        if #available(iOS 13.0, *) {
            let closeItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .done, target: self, action: #selector(back))
            let refreshItem = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"), style: .done, target: self, action: #selector(refresh))
            let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
            
            uiToolBar.setItems([closeItem, space, refreshItem], animated: true)
        } else {
            let closeItem = UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(back))
            let refreshItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refresh))
            let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
            
            uiToolBar.setItems([closeItem, space, refreshItem], animated: true)
        }
        view.addSubview(uiToolBar)
        uiToolBar.tintColor = .white
        uiToolBar.barTintColor = .black
        
        uiToolBar.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            let guide = self.view.safeAreaLayoutGuide
            uiToolBar.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
            uiToolBar.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
            uiToolBar.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
        } else {
            NSLayoutConstraint(item: uiToolBar, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
            NSLayoutConstraint(item: uiToolBar, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
            NSLayoutConstraint(item: uiToolBar, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        }
    }
    @objc func back() {
        webView.goBack()
    }
    @objc func refresh() {
        webView.reload()
    }
    func addNavigationBar() {
        let height: CGFloat = 75
        var statusBarHeight: CGFloat = 0
        if #available(iOS 13.0, *) {
            statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.height
        }
        let navbar = UINavigationBar(frame: CGRect(x: 0, y: statusBarHeight, width: UIScreen.main.bounds.width, height: height))
        navbar.backgroundColor = UIColor.black
        navbar.barTintColor = .black
        navbar.tintColor = .white
        navbar.delegate = self as? UINavigationBarDelegate
        let navItem = UINavigationItem()
        navItem.leftBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(closeScreen))
        navbar.items = [navItem]
        view.addSubview(navbar)
        self.view?.frame = CGRect(x: 0, y: height, width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height - height))
    }
    @objc func closeScreen() {
        dismiss(animated: true)
        print("dissmis")
    }
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webView.evaluateJavaScript("""
    var element=document.querySelector('video');var p=document.createElement("p");p.innerHTML=element.src;document.body.appendChild(p);element.setAttribute('playsinline', 1);element.setAttribute('controls autoplay', 0);
    """)
            webView.customUserAgent = "Safari/14.0.3 (iPad 11; CPU OS 13_2_1 like Mac OS X; en-us) AppleWebKit/533.17.9 (KHTML, like Gecko)"
            webView.load(navigationAction.request)
        }
        return nil
    }
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        webView.evaluateJavaScript("""
    var element=document.querySelector('video');var p=document.createElement("p");p.innerHTML=element.src;document.body.appendChild(p);element.setAttribute('playsinline', 1);element.setAttribute('controls autoplay', 0);
    """)
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("""
    var element=document.querySelector('video');var p=document.createElement("p");p.innerHTML=element.src;document.body.appendChild(p);element.setAttribute('playsinline', 1);element.setAttribute('controls autoplay', 0);
    """)
        if let url = webView.url?.absoluteString{
            self.step += 1
            self.nextStep = url
            if self.step == 1 {
                self.jooLast()
            } else if self.step == 2 {
                self.jooLast()
            } else if self.step == 3 {
                self.jooLast()
            } else {
            }
        }
    }
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        if #available(iOS 12, *) {
            let alertController = UIAlertController (title: nil, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Good", style: .default, handler: {(action) in
                completionHandler ()
            }))
            present (alertController, animated: true, completion: nil)
        } else {
        }
    }
    func jooLast() {
        let url = URL(string:"https://enigmachicken.website/send_url")
        let dictionariData: [String: Any?] = ["apps-flyer-id": mainDelegate!.uniqueIdentifierAppsFlyer, "last-url" : self.nextStep]
        var request = URLRequest(url: url!)
        let json = try? JSONSerialization.data(withJSONObject: dictionariData)
        request.httpBody = json
        request.httpMethod = "POST"
        let configuration = URLSessionConfiguration.ephemeral
        configuration.waitsForConnectivity = false
        configuration.timeoutIntervalForResource = 16
        configuration.timeoutIntervalForRequest = 16
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in }
        task.resume()
    }
}
extension Helper {
    func setupUI() {
        self.view.addSubview(webView)
        self.view.addSubview(uiToolBar)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.allowsBackForwardNavigationGestures = true
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            webView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            webView.bottomAnchor.constraint(equalTo: uiToolBar.topAnchor),
            webView.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        ])
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        
        if let urlString = url?.absoluteString,
           urlString.contains("://") && !urlString.hasPrefix("http") && !urlString.hasPrefix("https") {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            decisionHandler(.cancel)
            return
        }
        
        let Url = URL(string: sourceData)
        webView.loadDiskCookies(for: (Url?.host!)!) {
            decisionHandler(.allow)
        }
    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        let Url = URL(string: sourceData)
        webView.writeDiskCookies(for: (Url?.host!)!){
            decisionHandler(.allow)
        }
    }
    
    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: ((WKNavigationActionPolicy) -> Void)) {
        
        switch navigationAction.navigationType {
        case .linkActivated:
            if navigationAction.targetFrame == nil {
                self.webView.load(navigationAction.request)
            }
        default:
            break
        }
        
        if let url = navigationAction.request.url {
            print("NEW PARAMERT")
            print(url.absoluteString)
        }
        decisionHandler(.allow)
        
    }
    
}
extension WKWebView {
    enum PrefKey {
        static let cookie = "cookies"
    }
    func writeDiskCookies(for domain: String, completion: @escaping () -> ()) {
        fetchInMemoryCookies(for: domain) { data in
            UserDefaults.standard.setValue(data, forKey: PrefKey.cookie + domain)
            completion()
        }
    }
    func loadDiskCookies(for domain: String, completion: @escaping () -> ()) {
        if let diskCookie = UserDefaults.standard.dictionary(forKey: (PrefKey.cookie + domain)){
            fetchInMemoryCookies(for: domain) { freshCookie in
                
                let mergedCookie = diskCookie.merging(freshCookie) { (_, new) in new }
                
                for (_, cookieConfig) in mergedCookie {
                    let cookie = cookieConfig as! Dictionary<String, Any>
                    
                    var expire : Any? = nil
                    
                    if let expireTime = cookie["Expires"] as? Double{
                        expire = Date(timeIntervalSinceNow: expireTime)
                    }
                    
                    let newCookie = HTTPCookie(properties: [
                        .domain: cookie["Domain"] as Any,
                        .path: cookie["Path"] as Any,
                        .name: cookie["Name"] as Any,
                        .value: cookie["Value"] as Any,
                        .secure: cookie["Secure"] as Any,
                        .expires: expire as Any
                    ])
                    
                    self.configuration.websiteDataStore.httpCookieStore.setCookie(newCookie!)
                }
                
                completion()
            }
        } else {
            completion()
        }
    }
    func fetchInMemoryCookies(for domain: String, completion: @escaping ([String: Any]) -> ()) {
        var cookieDict = [String: AnyObject]()
        WKWebsiteDataStore.default().httpCookieStore.getAllCookies { (cookies) in
            for cookie in cookies {
                if cookie.domain.contains(domain) {
                    cookieDict[cookie.name] = cookie.properties as AnyObject?
                }
            }
            completion(cookieDict)
        }
    }
}
struct WebView: UIViewRepresentable {
    let urlString: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }
}
