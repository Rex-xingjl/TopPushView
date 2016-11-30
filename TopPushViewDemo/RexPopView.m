//
//  RexPopView.m
//  TopPushViewDemo
//
//  Created by Rex@JJS on 2016/11/22.
//  Copyright © 2016年 Rex@JJSRex. All rights reserved.
//

#import "RexPopView.h"

#define r_screen_width    ([UIScreen mainScreen].bounds.size.width)
#define r_screen_height   ([UIScreen mainScreen].bounds.size.height)

#define r_zero_float      0.f
#define r_zero_int        0
#define r_one             1.f
#define r_two             2.f

#define r_edge_vertical   11.f
#define r_edge_horizontal 14.f

#define r_btn_bottom      24.f
#define r_btn_height      28.f
#define r_btn_top         40.f
#define r_btn_width       74.f

#define r_pop_s_duration  0.3f
#define r_pop_h_duration  0.6f
#define r_pop_transfrom   1.2f
#define r_pop_v_duration  3.0f
#define r_pop_height      84.f

#define r_btm_alpha       0.8f
#define r_btm_color       ([UIColor blackColor])

#define r_lbl_info        @"无消息内容"
#define r_lbl_bg_color    ([UIColor clearColor])
#define r_lbl_text_color  ([UIColor whiteColor])
#define r_lbl_font        ([UIFont systemFontOfSize:14.f])
#define r_lbl_height      (r_pop_height - 3*r_edge_vertical)
#define r_lbl_width       (r_screen_width - 3*r_edge_horizontal - r_btn_width)

#define r_btn_font        ([UIFont systemFontOfSize:14.f])
#define r_btn_title_color ([UIColor whiteColor])
#define r_btn_bg_color    ([UIColor clearColor])
#define r_btn_bd_color    ([UIColor whiteColor])
#define r_btn_title       @"点击进入"
#define r_btn_bd_width    0.5f
#define r_btn_radius      3.f

#define r_img_name        @"time"
#define r_clk_text_color  ([UIColor whiteColor])
#define r_clk_font        ([UIFont systemFontOfSize:12.f])
#define r_clk_text_count  ([NSString stringWithFormat:@"%d", (int)(self.popView_view_duration+1 - self.rex_second)])
#define r_clk_text_init   ([NSString stringWithFormat:@"%d", (int)_popView_view_duration])

#define r_img_frame       (CGRectMake(CGRectGetMinX(self.clockLabel.frame)-5-12, CGRectGetMinY(self.clockLabel.frame), 12, 12))
#define r_clk_frame       (CGRectMake(CGRectGetMaxX(self.entryButton.frame)-10, CGRectGetMinY(self.entryButton.frame)-18, 10, 12))
#define r_pop_frame_show  (CGRectMake(r_zero_float, r_zero_float, r_screen_width, r_pop_height))
#define r_pop_frame_hide  (CGRectMake(r_zero_float, - r_pop_height, r_screen_width, r_pop_height))
#define r_btm_frame       r_pop_frame_show
#define r_lbl_frame       ((CGRect){r_edge_horizontal, 2 *r_edge_vertical, r_lbl_width, r_lbl_height})
#define r_btn_frame       ((CGRect){CGRectGetMaxX(_infoLabel.frame)+r_edge_horizontal, r_btn_top, r_btn_width, r_btn_height})

@interface RexPopView()

@property (atomic, assign) __block BOOL isAnimating_show;
@property (atomic, assign) __block BOOL isAnimating_hide;
@property (nonatomic, strong) UIPanGestureRecognizer * rex_panGesture;
@property (nonatomic, weak)   RexPopViewButtonBlock rex_btnblock;
@property (nonatomic, strong) NSTimer * rex_timer;
@property (nonatomic, assign) int rex_second;

@end

@implementation RexPopView

#pragma ///////////////////////////////////////////////////////////////////////////////

#pragma mark - # MainMethod #

+ (void)showInfo:(NSString *)info btnTitle:(NSString *)title btnAction:(RexPopViewButtonBlock)block {
    [[RexPopView shared] showPopViewWith:info btnTitle:title btnAction:block];
}

+ (void)dimiss {
    [[RexPopView shared] popViewHide];
}

#pragma ///////////////////////////////////////////////////////////////////////////////

#pragma mark - # initMethod #

+ (RexPopView *)shared {
    static RexPopView * instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        [[UIApplication sharedApplication].keyWindow addSubview:instance];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        [self initialView];
    }
    return self;
}

- (void)initialView {
    [self setFrame:self.popView_frame];
    [self addSubview:self.bottomBgView];
    [self addSubview:self.infoLabel];
    [self addSubview:self.entryButton];
    [self addSubview:self.clockLabel];
    [self addSubview:self.clockImageView];
    [self addGestureRecognizer:self.rex_panGesture];
    [self.layer setMasksToBounds:YES];
    [self setClipsToBounds:YES];
}

- (void)showPopViewWith:(NSString *)info btnTitle:(NSString *)title btnAction:(RexPopViewButtonBlock)block {
    
    [self setRex_btnblock:block];
    [self.infoLabel setText:info ? : r_lbl_info];
    [self.entryButton setTitle:title ? : r_btn_title forState:r_zero_float];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
    
    // re-render the popView's subViews
    [self bottomBgView];
    [self infoLabel];
    [self entryButton];
    [self popViewShow];
}

#pragma ///////////////////////////////////////////////////////////////////////////////

#pragma mark - # show & hide #

- (void)popViewShow {
    if (_isAnimating_show) {
        return;
    }
    [UIView animateWithDuration:self.popView_animate_duration_show animations:^{
        [RexPopView shared].frame = self.popView_frame_show;
        _isAnimating_show = YES;
        _rex_panGesture.enabled = YES;
    } completion:^(BOOL finished) {
        [self.rex_timer fire];
    }];
}

- (void)popViewHide {
    if (_isAnimating_hide || !_isAnimating_show) { // When the View is showing and not hidding, then can hide it
        return;
    }
    [UIView animateWithDuration:self.popView_animate_duration_hide animations:^{
        _isAnimating_hide = YES;
        _rex_panGesture.enabled = NO;
        [RexPopView shared].frame = self.popView_frame_hide;
        [RexPopView shared].alpha = r_zero_float;
        [RexPopView shared].transform = CGAffineTransformMakeScale(self.popView_transform_scale,
                                                                   self.popView_transform_scale);
    } completion:^(BOOL finished) {
        [RexPopView shared].alpha = r_one;
        [RexPopView shared].transform = CGAffineTransformIdentity;
        [self rex_timerInvalidate];
        _isAnimating_show = NO;
        _isAnimating_hide = NO;
        _entryButton.enabled = YES;
    }];
}

- (void)rex_panGestureAction:(UIPanGestureRecognizer *)pan {
    static CGRect movingFrame;
    
    CGFloat lastY = [pan translationInView:self].y;  // final Y
    CGSize  popSize = self.popView_frame.size;
    
    // motion judge
    if (pan.state == UIGestureRecognizerStateChanged &&
        self.frame.origin.y <= r_screen_height &&
        self.frame.origin.y > - popSize.height / r_two) {
        
        [self rex_timerInvalidate];
        movingFrame = CGRectMake(r_zero_float, lastY, popSize.width, popSize.height);
        self.frame = movingFrame;
    }
    
    // motion executed
    if (pan.state == UIGestureRecognizerStateEnded) {
        if (lastY > - popSize.height / r_two && lastY < r_screen_height / r_two) {
            [UIView animateWithDuration:self.popView_animate_duration_show animations:^{
                [self rex_timerValidate];
                self.frame = self.popView_frame_show;
            }];
        }
        if (lastY >= r_screen_height / r_two || lastY <= - popSize.height / r_two) {
            [UIView animateWithDuration:self.popView_animate_duration_hide animations:^{
                [self popViewHide];
            }];
        }
    }
}

- (void)rex_timerValidate {
    [self rex_timer];
    ++ self.rex_second <= self.popView_view_duration ? : [self popViewHide];
    self.clockLabel.text = r_clk_text_count;
}

- (void)rex_timerInvalidate {
    [_rex_timer invalidate];
    _rex_timer = nil;
    _rex_second = r_zero_int;
    self.clockLabel.text = r_clk_text_init;
}

#pragma ///////////////////////////////////////////////////////////////////////////////

#pragma mark - # property #

- (UIPanGestureRecognizer *)rex_panGesture {
    if (!_rex_panGesture) {
        self.rex_panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(rex_panGestureAction:)];
    }
    return _rex_panGesture;
}

- (NSTimer *)rex_timer {
    if (!_rex_timer) {
        self.rex_timer = [NSTimer scheduledTimerWithTimeInterval:r_one
                                                          target:self
                                                        selector:@selector(rex_timerValidate)
                                                        userInfo:nil
                                                         repeats:YES];
    }
    return _rex_timer;
}

- (int)rex_second {
    if (!_rex_second) {
        self.rex_second = r_zero_int;
    }
    return _rex_second;
}

#pragma mark - # popView #

- (CGRect)popView_frame {
    if (CGRectEqualToRect(_popView_frame, CGRectZero)) {
        self.popView_frame = r_pop_frame_hide;
    }
    return _popView_frame;
}

- (CGRect)popView_frame_show {
    if (CGRectEqualToRect(_popView_frame_show, CGRectZero)) {
        self.popView_frame_show = r_pop_frame_show;
    }
    return _popView_frame_show;
}

- (CGRect)popView_frame_hide {
    if (CGRectEqualToRect(_popView_frame_hide, CGRectZero)) {
        self.popView_frame_hide = r_pop_frame_hide;
    }
    return _popView_frame_hide;
}

- (CGFloat)popView_view_duration {
    if (!_popView_view_duration) {
        self.popView_view_duration = r_pop_v_duration;
    }
    return _popView_view_duration;
}

- (CGFloat)popView_animate_duration_show {
    if (!_popView_animate_duration_show) {
        self.popView_animate_duration_show = r_pop_s_duration;
    }
    return _popView_animate_duration_show;
}

- (CGFloat)popView_animate_duration_hide {
    if (!_popView_animate_duration_hide) {
        self.popView_animate_duration_hide = r_pop_h_duration;
    }
    return _popView_animate_duration_hide;
}

- (CGFloat)popView_transform_scale {
    if (!_popView_transform_scale) {
        self.popView_transform_scale = r_pop_transfrom;
    }
    return _popView_transform_scale;
}

#pragma mark - # bottomBgView #

- (UIView *)bottomBgView {
    if (!_bottomBgView) {
        self.bottomBgView = [[UIView alloc] init];
    }
    _bottomBgView.frame = self.bottomView_frame;
    _bottomBgView.backgroundColor = [self.bottomView_color colorWithAlphaComponent:self.bottomView_alpha];
    return _bottomBgView;
}

- (CGRect)bottomView_frame {
    if (CGRectEqualToRect(_bottomView_frame, CGRectZero)) {
        self.bottomView_frame = r_btm_frame;
    }
    return _bottomView_frame;
}

- (UIColor *)bottomView_color {
    if (!_bottomView_color) {
        self.bottomView_color = r_btm_color;
    }
    return _bottomView_color;
}

- (CGFloat)bottomView_alpha {
    if (!_bottomView_alpha) {
        self.bottomView_alpha = r_btm_alpha;
    }
    return _bottomView_alpha;
}

#pragma mark - # infoLabel #

- (UILabel *)infoLabel {
    if (!_infoLabel) {
        self.infoLabel = [[UILabel alloc] init];
    }
    _infoLabel.frame = self.infoLabel_frame;
    _infoLabel.textAlignment = self.infoLabel_textAlignment;
    _infoLabel.backgroundColor = self.infoLabel_bgColor;
    _infoLabel.textColor = self.infoLabel_textColor;
    _infoLabel.numberOfLines = r_zero_float;
    _infoLabel.font = self.infoLabel_font;
    return _infoLabel;
}

- (CGRect)infoLabel_frame {
    if (CGRectEqualToRect(_infoLabel_frame, CGRectZero)) {
        self.infoLabel_frame = r_lbl_frame;
    }
    return _infoLabel_frame;
}

- (UIColor *)infoLabel_bgColor {
    if (!_infoLabel_bgColor) {
        self.infoLabel_bgColor = r_lbl_bg_color;
    }
    return _infoLabel_bgColor;
}

- (UIColor *)infoLabel_textColor {
    if (!_infoLabel_textColor) {
        self.infoLabel_textColor = r_lbl_text_color;
    }
    return _infoLabel_textColor;
}

- (UIFont *)infoLabel_font {
    if (!_infoLabel_font) {
        self.infoLabel_font = r_lbl_font;
    }
    return _infoLabel_font;
}

- (NSTextAlignment)infoLabel_textAlignment {
    if (!_infoLabel_textAlignment) {
        self.infoLabel_textAlignment = NSTextAlignmentLeft;
    }
    return _infoLabel_textAlignment;
}

#pragma mark - # entryButton #

- (UIButton *)entryButton {
    if (!_entryButton) {
        self.entryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_entryButton addTarget:self action:@selector(entryButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    [_entryButton setTitleColor:self.entryButton_textColor forState:r_zero_float];
    _entryButton.layer.borderColor = self.entryButton_borderColor.CGColor;
    _entryButton.layer.cornerRadius= self.entryButton_cornerRadius;
    _entryButton.layer.borderWidth = self.entryButton_borderWidth;
    _entryButton.backgroundColor = self.entryButton_bgColor ;
    _entryButton.titleLabel.font = self.entryButton_font;
    _entryButton.frame = self.entryButton_frame;
    _entryButton.layer.masksToBounds = YES;
    _entryButton.clipsToBounds = YES;
    return _entryButton;
}

- (void)entryButtonAction:(UIButton *)button {
    if (self.rex_btnblock) {
        self.rex_btnblock();
    }
    button.enabled = NO;
    [self popViewHide];
}

- (CGRect)entryButton_frame {
    if (CGRectEqualToRect(_entryButton_frame, CGRectZero)) {
        self.entryButton_frame = r_btn_frame;
    }
    return _entryButton_frame;
}

- (UIColor *)entryButton_bgColor {
    if (!_entryButton_bgColor) {
        self.entryButton_bgColor = r_btn_bg_color;
    }
    return _entryButton_bgColor;
}

- (UIColor *)entryButton_borderColor {
    if (!_entryButton_borderColor) {
        self.entryButton_borderColor = r_btn_bd_color;
    }
    return _entryButton_borderColor;
}

- (CGFloat)entryButton_borderWidth {
    if (!_entryButton_borderWidth) {
        self.entryButton_borderWidth = r_btn_bd_width;
    }
    return _entryButton_borderWidth;
}

- (UIColor *)entryButton_textColor {
    if (!_entryButton_textColor) {
        self.entryButton_textColor = r_btn_title_color;
    }
    return _entryButton_textColor;
}

- (UIFont *)entryButton_font {
    if (!_entryButton_font) {
        self.entryButton_font = r_btn_font;
    }
    return _entryButton_font;
}

- (CGFloat)entryButton_cornerRadius {
    if (!_entryButton_cornerRadius) {
        self.entryButton_cornerRadius = r_btn_radius;
    }
    return _entryButton_cornerRadius;
}

#pragma mark - # clockImageView #

- (UIImageView *)clockImageView {
    if (!_clockImageView) {
        self.clockImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.clockImageName]];
        _clockImageView.frame = r_img_frame;
    }
    return _clockImageView;
}

- (NSString *)clockImageName {
    if (!_clockImageName) {
        self.clockImageName = r_img_name;
    }
    return _clockImageName;
}

- (UILabel *)clockLabel {
    if (!_clockLabel) {
        self.clockLabel = [[UILabel alloc] initWithFrame:r_clk_frame];
        _clockLabel.textColor = self.clockLabel_textColor;
        _clockLabel.textAlignment = NSTextAlignmentCenter;
        _clockLabel.font = self.clockLabel_font;
        _clockLabel.text = r_clk_text_init;
    }
    return _clockLabel;
}

- (UIColor *)clockLabel_textColor {
    if (!_clockLabel_textColor) {
        self.clockLabel_textColor = r_clk_text_color;
    }
    return _clockLabel_textColor;
}

- (UIFont *)clockLabel_font {
    if (!_clockLabel_font) {
        self.clockLabel_font = r_clk_font;
    }
    return _clockLabel_font;
}

@end
