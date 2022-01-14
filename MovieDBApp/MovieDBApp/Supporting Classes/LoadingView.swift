

import Foundation
import UIKit

open class LoadingView {
    
    var backGroundView : UIView!
    var overlayView : UIImageView!
    var activityIndicator : UIActivityIndicatorView!
    
    class var shared: LoadingView {
        struct Static {
            static let instance: LoadingView = LoadingView()
        }
        return Static.instance
    }
    
    init() { 
        let window = UIWindow.key
        guard let frame = window?.rootViewController?.view.bounds else { return }
        self.backGroundView = UIView()
        self.backGroundView.frame = CGRect(x:0, y:0, width:(frame.width), height:(frame.height))
        self.backGroundView.backgroundColor = UIColor.clear
        self.overlayView = UIImageView()//UIView()
        self.activityIndicator = UIActivityIndicatorView()

        let imgView = UIImageView()
        imgView.frame = CGRect(x:0, y:0, width:(frame.width), height:(frame.height))
        imgView.alpha = 0.4
        imgView.backgroundColor = UIColor.white
        self.backGroundView.addSubview(imgView)

        overlayView.frame = CGRect(x:0, y:0, width:80, height:80)
        overlayView.backgroundColor = UIColor.init(hex: "6300F0")
        overlayView.clipsToBounds = true
        overlayView.layer.cornerRadius = 10
        overlayView.layer.zPosition = 1

        self.backGroundView.addSubview(overlayView)
        activityIndicator.frame = CGRect(x:0, y:0, width:40, height:40)
        activityIndicator.center = CGPoint(x:overlayView.bounds.width / 2,y: overlayView.bounds.height / 2)
        if #available(iOS 13.0, *) {
            activityIndicator.style = .large
        } else {
            // Fallback on earlier versions
            activityIndicator.style = .whiteLarge
        }
        overlayView.addSubview(activityIndicator)
    }
    
    open func showOverlay(_ view: UIView?) {
       DispatchQueue.main.async {
        guard let window = UIWindow.key else { return }
        self.overlayView.center = (window.center)
        view?.addSubview(self.overlayView)
        window.addSubview(self.backGroundView)
        self.activityIndicator.startAnimating()
        }
    }
    
    open func hideOverlayView() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.backGroundView.removeFromSuperview()
        }
    }
}


extension UIView {

  func addShadow(shadowColor: UIColor, offSet: CGSize, opacity: Float, shadowRadius:
  CGFloat, cornerRadius: CGFloat, corners: UIRectCorner, fillColor: UIColor = .white) {

    let shadowLayer = CAShapeLayer()
    let size = CGSize(width: cornerRadius, height: cornerRadius)
    let cgPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: size).cgPath //1
    shadowLayer.path = cgPath //2
    shadowLayer.fillColor = fillColor.cgColor //3
    shadowLayer.shadowColor = shadowColor.cgColor //4
    shadowLayer.shadowPath = cgPath
    shadowLayer.shadowOffset = offSet //5
    shadowLayer.shadowOpacity = opacity
    shadowLayer.shadowRadius = shadowRadius
    self.layer.addSublayer(shadowLayer)
  }
}
