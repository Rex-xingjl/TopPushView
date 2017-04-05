# TopPushView


A push View like the ios 9&before style

>Show

```objc

    [RexPopView showInfo:@"1111" btnTitle:@"222" btnAction:^{
        NSLog(@"333");
    }];

```

*Easy to show the PopView and catch the action of touch.*

>Hide

```objc

    [RexPopView showInfo:@"1111" btnTitle:@"222" btnAction:^{
        NSLog(@"333");
    }];

```

*Anytime to hide the PopView.*

>Custom

All the parameters is open to change

```objc

    //Example
    [RexPopView shared].bottomView_color = [UIColor blueColor];
    [RexPopView shared].popView_view_duration = 4;
    
```

###Take a chestnut View

![chestnut](chestnut.gif "chestnut")
