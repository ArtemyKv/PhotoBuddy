# Photo Buddy
Photo Buddy is a photo-searching app powered by Unsplash

## Features
- Searching for photos in Unsplash Base
- Adding photos to favorites and download them on device
- Two tabs: first is for search results, second is for list of favorite user photos and photo details screen
- Pagination for searching results with bottom activity indicator
- Photo details with "Photos app-like" zoom
- Photo persistence between launches with Core Data
- Concurrent code with CGD for loading data from API, using semaphore to limit the number of simultaneously loading photos to keep UI fast and resposive


 
 ## Screenshots
| Empty Search Screen | Search screen with photos | Favorites Screen | Photo details screen |
:---:|:---:|:---:|:---:|
![Simulator Screen Shot - iPhone 14 Pro - 2023-02-10 at 23 42 33](https://user-images.githubusercontent.com/90643294/218172377-3e870c7d-72eb-4290-a541-9d4870aa2d70.png)| ![Simulator Screen Shot - iPhone 14 Pro - 2023-02-10 at 23 44 17](https://user-images.githubusercontent.com/90643294/218172556-6ef581e4-821f-4334-a487-8adbf93994a0.png) |![Simulator Screen Shot - iPhone 14 Pro - 2023-02-10 at 23 44 37](https://user-images.githubusercontent.com/90643294/218172617-7af2eb55-4aeb-4315-ba38-db596a1c75b0.png) |![Simulator Screen Shot - iPhone 14 Pro - 2023-02-10 at 23 47 05](https://user-images.githubusercontent.com/90643294/218173012-4f0a2222-8033-4eed-a580-2de540e7af7d.png)




 ## Technologies stack
 - UIKit
 - CoreData
 - MVVM with boxing
 
 ## Description
 - Programmatically-built UI (no storyboard)
 - Network layer based on URLSession
 - UITableView and UICollectionView for screens with photos lists
 - CoreData for saving favorite photos
 - CoreAnimation for custom animations including layer animation with CABasicAnimation and CAGradientLayer
 - 
 
 ## Requirements
 - iOS 14+
 - XCode 12+
