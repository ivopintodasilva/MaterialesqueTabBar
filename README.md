# TabbedController
## UIViewController featuring a customisable Tab Bar and UIPageViewController

Demo:

![alt text](https://media.giphy.com/media/3ohz6qtTfOqVFYVgYw/giphy.gif "Tab bar button selection indicator animation")

## Customisable attributes

- Dynamic child ViewControllers;
- Tabs configured according to TabBarChild objects (-> Tab title + UIViewController);
- Tabs title color;
- Tabs background color;
- Active tab indicator color;
- Tab title font.


## History

###Iteration #1: 
- This is a mini-project to deliver an animated material-like tab bar library that anyone can add to their app;
- It is still a work in progress.

###Iteration #2:
- Tabs are done and selection is animated;
- The next goal is to animate the indicator between the different tabs and not have one indicator on each tab.

###Iteration #3: 
- Tab indicator animating as desired; 
- Next steps involve adding customizability, integrating the ViewControllers and improving the TabBar overall aspect.

###Iteration #4: 
- Added more configurability to the TabBar;
- Added UIPageViewController;
- TabBar and UIPageViewController built from the same TabBarChild array object;
- Each TabBarChild features a title (used to configure the tab) and a UIViewController (Used as a page in the UIPageViewController);
- Both the TabBar and the UIPageViewController getting updated when the other changes state (on tab click or page change).

