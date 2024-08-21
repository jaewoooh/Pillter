import UIKit
import ImageIO

extension UIImage {
    public class func gif(name: String) -> UIImage? {
        guard let bundleURL = Bundle.main.url(forResource: name, withExtension: "gif") else {
            print("Gif 파일 \(name)을 찾을 수 없습니다.")
            return nil
        }
        
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            return nil
        }
        
        return UIImage.gif(data: imageData)
    }
    
    public class func gif(data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("Gif 데이터를 가져오지 못했습니다.")
            return nil
        }
        
        return UIImage.animatedImage(with: source)
    }
    
    private class func animatedImage(with source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [UIImage]()
        var duration: TimeInterval = 0.0
        
        for i in 0..<count {
            if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                let image = UIImage(cgImage: cgImage)
                images.append(image)
            }
            
            if let properties = CGImageSourceCopyPropertiesAtIndex(source, i, nil) as? [String: Any],
               let gifProperties = properties[kCGImagePropertyGIFDictionary as String] as? [String: Any],
               let delayTime = gifProperties[kCGImagePropertyGIFUnclampedDelayTime as String] as? Double {
                duration += delayTime
            }
        }
        
        return UIImage.animatedImage(with: images, duration: duration)
    }
}
