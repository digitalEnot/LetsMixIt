

import UIKit

final class LMIRangeSlider: UIControl {
    let circleRadius: CGFloat = 30
    var totalSliderWidth: CGFloat = 0
    var widthForMinThumb: CGFloat = 0 {
        didSet {
            updateMinThumb()
            sendActions(for: .valueChanged)
        }
    }
    var widthForMaxThumb: CGFloat = 0 {
        didSet {
            updateMaxThumb()
            sendActions(for: .valueChanged)
        }
    }
    
    let minThumb = UIView()
    let maxThumb = UIView()
    let firstRect = UIView()
    let progressRect = UIView()
    var previousLocationForMin: CGPoint = CGPoint()
    var previousLocationForMax: CGPoint = CGPoint()
    var distanceFromCenterForMin: CGFloat = CGFloat()
    var distanceFromCenterForMax: CGFloat = CGFloat()
    var minimumValue: Int {
        get {
            return getValue(val: widthForMinThumb / (totalSliderWidth - 30))
        }
        set {
            widthForMinThumb = (totalSliderWidth - 30) * (CGFloat(newValue)/50)
        }
    }
    var maximumValue: Int {
        get {
            return getValue(val: (widthForMaxThumb - 30) / (totalSliderWidth - 30))
        }
        set {
            widthForMaxThumb = (CGFloat(newValue)/50) * (totalSliderWidth - 30) + 30
        }
    }
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        totalSliderWidth = frame.width - 30
        widthForMaxThumb = totalSliderWidth
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        isMultipleTouchEnabled = true
        addSubview(firstRect)
        addSubview(progressRect)
        addSubview(minThumb)
        addSubview(maxThumb)
                
        firstRect.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        firstRect.frame = CGRect(x: 0, y: 20, width: totalSliderWidth + circleRadius, height: 3)
        
        progressRect.frame = CGRect(x: widthForMinThumb + 15, y: 20, width: widthForMaxThumb - widthForMinThumb, height: 3)
        progressRect.backgroundColor = UIColor(hex: "#FF7F50")
        
        minThumb.frame = CGRect(x: widthForMinThumb, y: 5, width: circleRadius, height: circleRadius)
        configureThumb(thumb: minThumb)
        
        maxThumb.frame = CGRect(x: widthForMaxThumb, y: 5, width: circleRadius, height: circleRadius)
        configureThumb(thumb: maxThumb)

        setRangeToDefaultFalues()
            
        let gestureOne = UILongPressGestureRecognizer(target: self, action: #selector(gestureOne))
        gestureOne.minimumPressDuration = 0
        minThumb.addGestureRecognizer(gestureOne)
        
        let gestureTwo = UILongPressGestureRecognizer(target: self, action: #selector(gestureTwo))
        gestureTwo.minimumPressDuration = 0
        maxThumb.addGestureRecognizer(gestureTwo)
    }
    
    
    private func configureThumb(thumb: UIView) {
        thumb.backgroundColor = UIColor.white
        thumb.layer.cornerRadius = minThumb.frame.size.width / 2
        
        thumb.layer.shadowColor = UIColor.black.cgColor
        thumb.layer.shadowOpacity = 0.3
        thumb.layer.shadowOffset = CGSize(width: 0, height: 2)
        thumb.layer.shadowRadius = 2
        let shadowPath = UIBezierPath(roundedRect: thumb.bounds, cornerRadius: thumb.layer.cornerRadius)
        thumb.layer.shadowPath = shadowPath.cgPath
    }
    
    
    func setRangeToDefaultFalues() {
        minimumValue = 0
        maximumValue = 50
    }
    
    
    private func updateMinThumb() {
        minThumb.frame.origin.x =  widthForMinThumb
        progressRect.frame.origin.x = 15 + widthForMinThumb
        progressRect.frame.size.width = widthForMaxThumb - widthForMinThumb
    }
    
    
    private func updateMaxThumb() {
        maxThumb.frame.origin.x = widthForMaxThumb
        progressRect.frame.size.width = widthForMaxThumb - widthForMinThumb
    }
    
    
    @objc private func gestureOne(recognizer: UILongPressGestureRecognizer) {
        switch recognizer.state {
        case .began:
            previousLocationForMin = recognizer.location(in: self)
            distanceFromCenterForMin = minThumb.frame.origin.x - recognizer.location(in: self).x
        case .changed:
            let location = recognizer.location(in: self)
            let deltaLocation = CGFloat(location.x - previousLocationForMin.x)
            
            if location.x + distanceFromCenterForMin >= 0  && location.x + distanceFromCenterForMin + 30 <= widthForMaxThumb {
                widthForMinThumb += deltaLocation
            } else if location.x + distanceFromCenterForMin + 30 >= widthForMaxThumb {
                widthForMinThumb = widthForMaxThumb - 30
            } else if location.x + distanceFromCenterForMin <= 0 {
                widthForMinThumb = 0
            }
            previousLocationForMin = location
        default:
            return
        }
    }
    
    
    @objc private func gestureTwo(recognizer: UILongPressGestureRecognizer) {
        switch recognizer.state {
        case .began:
            previousLocationForMax = recognizer.location(in: self)
            distanceFromCenterForMax = maxThumb.frame.origin.x - recognizer.location(in: self).x
        case .changed:
            let location = recognizer.location(in: self)
            let deltaLocation = CGFloat(location.x - previousLocationForMax.x)
            
            if location.x + distanceFromCenterForMax - 30 >= widthForMinThumb && location.x + distanceFromCenterForMax <= totalSliderWidth {
                widthForMaxThumb += deltaLocation
            } else if location.x + distanceFromCenterForMax - 30 <= widthForMinThumb {
                widthForMaxThumb = widthForMinThumb + 30
            } else if location.x + distanceFromCenterForMax >= totalSliderWidth {
                widthForMaxThumb = totalSliderWidth
            }
            previousLocationForMax = location
        default:
            return
        }
    }
    
    private func getValue(val: CGFloat) -> Int {
        return Int((val * 50).rounded())
    }
}
