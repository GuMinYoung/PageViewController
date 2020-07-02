
import UIKit

// UIPageViewController를 이용해서 여러 개의 UIViewController가 page control 되도록 하는 class
class PageViewController: UIPageViewController {
    // MARK:- Properties
    lazy var viewControllerArray = [UIViewController]()
    lazy var storyboardIDArray = [String]()
    
    // MARK:- Initializer
    // 여기부터
    override init(transitionStyle style:
        UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: options)
    }
    
    required init?(coder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    // 여기까지는
    // 페이지 넘길 때 효과를 page curl(default)에서 scroll로 변경하는 코드이다
    // storyboard에서도 설정 가능! Page View Controller - Transition Style
    
    // MARK:- Methods
    // MARK: Custom Method
    // 뷰 컨트롤러에 적합한 데이터를 찾기 위해 storyboardID를 식별자로 사용해 뷰 컨트롤러 객체 생성
    // storyboardID는 인터페이스 빌더에서 설정했다
    public func createVCInstance(name: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: name)
    }
    
    // 페이지 컨트롤러 인디케이터에 표시될 점 개수를 리턴
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return viewControllerArray.count
    }
    
    // 페이지 컨트롤러 인디케이터의 초기 값을 리턴
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        // 페이지 뷰 컨트롤러에 의해 표시되는 첫 번째 뷰 컨트롤러(firstViewController)가 nil이거나
        // viewControllerArray.firstIndex 함수로 그 firstViewController에 해당하는 요소를 찾지 못해 인덱스로 nil이 반환되면 0을 리턴
        guard let firstViewController = viewControllers?.first,
            let firstViewControllerIndex = viewControllerArray.firstIndex(of: firstViewController) else { return 0 }
        
        // 둘 다 nil 아니고 인덱스까지 찾았으면 그 값을 초기 값으로 리턴
        return firstViewControllerIndex
    }
}

// MARK:- UIPageViewControllerDataSource
extension PageViewController: UIPageViewControllerDataSource {
    // 현재 페이지의 이전 view controller(페이지)를 리턴하는 함수
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = viewControllerArray.firstIndex(of: viewController) else {
            return nil
        }
        
        let prevIndex = viewControllerIndex - 1
        
        // 첫번째 페이지에서는 더이상 앞으로 가지 못함
        // 인덱스가 전체 페이지 수 범위 안에 들어가야 리턴
        guard prevIndex >= 0, viewControllerArray.count > prevIndex else {
            return nil
            // 원형큐처럼 첫 페이지와 마지막 페이지를 연결하고 싶다면 아래처럼 쓰자
            // return ViewControllers.last
        }
        
        return viewControllerArray[prevIndex]
    }
    
    // 현재 페이지의 다음 view controller를 리턴하는 함수
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = viewControllerArray.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        // 마지막 페이지에서는 더이상 뒤로 가지 못함
        guard nextIndex < viewControllerArray.count, viewControllerArray.count > nextIndex else {
            return nil
            // 마지막 페이지 다음에 첫 페이지로 돌아가고 싶으면 아래처럼 쓰자
            // return ViewControllers.first
        }
        
        return viewControllerArray[nextIndex]
    }
}
