# BIZPopupView

*Wait for gif presentation, it's loading...*

![alt tag](https://github.com/bizibizi/BIZPopupView/blob/master/presentation.gif)


BIZPopupView is a custom popup as ContentView of that can be used any content of any UIViewController. Can be used as custom alert.


# Installation

### Manually
- Copy BIZPopupView folder to your project 


# Usage

- ```#import "BIZPopupViewController.h"``` 
- create custom UIViewController that will be used as ContentView for popup
![alt tag](https://github.com/bizibizi/BIZPopupView/blob/master/example1.png)
- create and present popup
```objective-c
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *smallViewController = [storyboard instantiateViewControllerWithIdentifier:@"bigViewController"];
    
    BIZPopupViewController *popupViewController = [[BIZPopupViewController alloc] initWithContentViewController:smallViewController contentSize:CGSizeMake(300, 400)];
    [self presentViewController:popupViewController animated:NO completion:nil];
```


# Contact

Igor Bizi
- https://www.linkedin.com/in/igorbizi
- igorbizi@mail.ru


# License
 
The MIT License (MIT)

Copyright (c) 2015-present Igor Bizi

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
