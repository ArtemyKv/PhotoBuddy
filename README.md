# Photo Buddy
Photo Buddy is a photo-searching app powered by Unsplash

## Features
- Searching for photos in Unsplash Base
- Adding photos to favorites and download them on device
- Two tabs: first is for search results, second is for list of favorite user photos and photo details screen
- Pagination for searching results with bottom activity indicator
- Photo details with "Photos app-like" zoom
- Photo persistence between launches with Core Data


 
 ## Screenshots
| Locations | Search | Weather Details |
:---:|:---:|:---:


 ## Technologies stack
 - UIKit
 - CoreData
 - MVVM with boxing
 
 ## Description
 - Programmatically-built UI (no storyboard)
 - Network layer based on URLSession
 - Locations and coordinates managed by CLLocation framework
 - Searching for new locations done with MapKit framework
 - Network layer based on URLSession
 - UIPageViewController for switching between weather in different locations
 - UITableView and UICollectionView for different screens
 - CoreData for saving user locations list
 - Custom screen transitions animation
 
 ## Requirements
 - iOS 14+
 - XCode 12+
