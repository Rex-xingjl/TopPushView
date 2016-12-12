//
//  RexPopView
//
//
//  Created by Rex on 2016/11/22.
//  Copyright © 2016年 Rex All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RexPopViewButtonBlock)();

@interface RexPopView : UIView

#pragma //////////////////////////////////////////////////////////////////////////

#pragma mark - # Main Method #

/**
 *  RexPopView
 *  应用顶部呼出视图
 *
 *  @param info      显示内容
 *  @param title     按钮标题
 *  @param block     按钮点击事件
 */
+ (void)showInfo:(NSString *)info btnTitle:(NSString *)title btnAction:(RexPopViewButtonBlock)block;

/**
 *  RexPopView
 *  应用顶部呼出视图
 *
 *  隐藏视图
 */
+ (void)dismiss;


#pragma mark - # Options Method #

+ (RexPopView *)shared;

@property (nonatomic, strong) NSString* info;

@property (nonatomic, strong) NSString* btnTitle;


#pragma ///////////////////////////////////////////////////////////////////////////

#pragma mark - # Property Setting #

// Warning : 请勿随意修改带frame的属性，先了解界面层级

/**
 *  RexPopView
 *  呼出视图
 */
@property (nonatomic, assign) CGRect    popView_frame;
@property (nonatomic, assign) CGRect    popView_frame_show;
@property (nonatomic, assign) CGRect    popView_frame_hide;
@property (nonatomic, assign) CGFloat   popView_view_duration;
@property (nonatomic, assign) CGFloat   popView_transform_scale;
@property (nonatomic, assign) CGFloat   popView_animate_duration_show;
@property (nonatomic, assign) CGFloat   popView_animate_duration_hide;

/**
 *  RexPopView
 *  背景底图
 */
@property (nonatomic, strong) UIView  * bottomBgView;
@property (nonatomic, assign) CGRect    bottomView_frame;
@property (nonatomic, strong) UIColor * bottomView_color;
@property (nonatomic, assign) CGFloat   bottomView_alpha;

/**
 *  RexPopView
 *  信息内容标题
 */
@property (nonatomic, strong) UILabel * infoLabel;
@property (nonatomic, assign) CGRect    infoLabel_frame;
@property (nonatomic, strong) UIFont  * infoLabel_font;
@property (nonatomic, strong) UIColor * infoLabel_bgColor;
@property (nonatomic, strong) UIColor * infoLabel_textColor;
@property (nonatomic, assign) NSTextAlignment infoLabel_textAlignment;

/**
 *  RexPopView
 *  点击按钮
 */
@property (nonatomic, strong) UIButton* entryButton;
@property (nonatomic, assign) CGRect    entryButton_frame;
@property (nonatomic, strong) UIFont  * entryButton_font;
@property (nonatomic, strong) UIColor * entryButton_bgColor;
@property (nonatomic, strong) UIColor * entryButton_textColor;
@property (nonatomic, assign) CGFloat   entryButton_borderWidth;
@property (nonatomic, strong) UIColor * entryButton_borderColor;
@property (nonatomic, assign) CGFloat   entryButton_cornerRadius;

/**
 *  RexPopView
 *  时间提示
 */
@property (nonatomic, strong) UIImageView * clockImageView;
@property (nonatomic, strong) NSString    * clockImageName;
@property (nonatomic, strong) UILabel     * clockLabel;
@property (nonatomic, strong) UIColor     * clockLabel_textColor;
@property (nonatomic, assign) UIFont      * clockLabel_font;

@end
