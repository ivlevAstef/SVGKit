//
//  UIImage+SVG.swift
//  SVGKit
//
//  Created by Sergey Iskhakov on 13.06.2023.
//

import Foundation
import UIKit

/// Расширение для получения UIImage из svg данных
/// Нативный приватный фреймворк корректно парсит SVG только начиная с iOS 15
/// В iOS более ранних версий он работает некорректно, поэтому
/// используем сторонний, с перспективой однажды отказаться
extension UIImage {
    /// Получить UIImage из строки с svg
    ///  - Parameter path: Строка, содержащая svg
    ///  - Returns: UIImage, если удалось распарсить
    public static func svgImage(with path: String) -> UIImage? {
        guard let data = path.data(using: .utf8) else {
            return nil
        }
        
        return svgImage(with: data)
    }
    
    /// Получить UIImage
    ///  - Parameter data: Data, содержащая svg
    ///  - Returns: UIImage, если удалось распарсить
    public static func svgImage(with data: Data) -> UIImage? {

        guard #available(iOS 15, *) else {
            guard let svg = SVG(data: data) else {
                return nil
            }
            
            let image = svg.rasterize()
            return image
        }
        
        guard let svg = NativeSVG(data),
              let image = svg.image() else {
            return nil
        }
        
        return image
    }
}
