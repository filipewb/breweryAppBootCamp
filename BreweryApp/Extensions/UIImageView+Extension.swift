import UIKit

extension UIImageView {
    
    func load(_ url: URL, placeholder: UIImage?, cache: URLCache? = nil) {
        let request = URLRequest(url: url)
        let cache = cache ?? URLCache.shared
        if let data = cache.cachedResponse(for: request)?.data,
           let image = UIImage(data: data) {
            self.image = image
        } else {
            self.image = placeholder
            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, response, _ in
                DispatchQueue.main.async {
                    if let data = data, let response = response, ((response as? HTTPURLResponse)?.statusCode ?? 500) < 300, let image = UIImage(data: data) {
                        let cachedData = CachedURLResponse(response: response, data: data)
                        cache.storeCachedResponse(cachedData, for: request)
                        self.image = image
                    }
                }
            }
            task.resume()
        }
    }
}
