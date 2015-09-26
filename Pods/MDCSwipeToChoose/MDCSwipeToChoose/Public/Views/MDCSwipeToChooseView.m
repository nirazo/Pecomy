//
// MDCSwipeToChooseView.m
//
// Copyright (c) 2014 to present, Brian Gesiak @modocache
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "MDCSwipeToChooseView.h"
#import "MDCSwipeToChoose.h"
#import "MDCGeometry.h"
#import "UIView+MDCBorderedLabel.h"
#import "UIColor+MDCRGB8Bit.h"
#import <QuartzCore/QuartzCore.h>

 static CGFloat const MDCSwipeToChooseViewHorizontalPadding = 13.f;
 static CGFloat const MDCSwipeToChooseViewTopPadding = 25.f;
 static CGFloat const MDCSwipeToChooseViewLabelWidth = 65.f;

@interface MDCSwipeToChooseView ()
@property (nonatomic, strong) MDCSwipeToChooseViewOptions *options;
@end

@implementation MDCSwipeToChooseView

#pragma mark - Object Lifecycle

- (instancetype)initWithFrame:(CGRect)frame options:(MDCSwipeToChooseViewOptions *)options {
    self = [super initWithFrame:frame];
    if (self) {
        _options = options ? options : [MDCSwipeToChooseViewOptions new];
        [self setupView];
        [self constructImageView];
        [self constructLikedView];
        [self constructNopeImageView];
        [self setupSwipeToChoose];
    }
    return self;
}

#pragma mark - Internal Methods

- (void)setupView {
    self.backgroundColor = [UIColor clearColor];
    self.layer.cornerRadius = 5.f;
    self.layer.masksToBounds = NO;
    
    // ドロップシャドウ
    UIView *shadow = [[UIView alloc] initWithFrame:self.bounds];
    shadow.layer.masksToBounds = NO;
    [self addSubview:shadow];
    shadow.backgroundColor = [UIColor whiteColor];
    shadow.layer.cornerRadius = 5.f;
    shadow.layer.shadowOffset = CGSizeMake(0.5, 1.0);
    shadow.layer.shadowRadius = 0.7;
    shadow.layer.shadowColor = [UIColor grayColor].CGColor;
    shadow.layer.shadowOpacity = 0.9;
    
    // パーツ群を置くビュー
    self.contentView = [[UIView alloc] initWithFrame:self.bounds];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.contentView.layer.cornerRadius = 5.f;
    self.contentView.layer.masksToBounds = YES;
    [self addSubview:self.contentView];
}

- (void)constructImageView {
    _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _imageView.clipsToBounds = YES;
    [self.contentView addSubview:_imageView];
}

- (void)constructLikedView {
    /**
     * Original
     */
    CGRect frame = CGRectMake(MDCSwipeToChooseViewHorizontalPadding,
                              MDCSwipeToChooseViewTopPadding,
                              CGRectGetMidX(_imageView.bounds),
                              MDCSwipeToChooseViewLabelWidth);
    self.likedLabelView = [[UIView alloc] initWithFrame:frame];
    [self.likedLabelView constructBorderedLabelWithText:self.options.likedText
                                             color:self.options.likedColor
                                             angle:self.options.likedRotationAngle];
    self.likedLabelView.alpha = 0.f;
    
    CGRect likedLabelFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.likedView = [[UIView alloc] initWithFrame:likedLabelFrame];
    self.likedView.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:77.0/255.0 blue:74.0/255.0 alpha:1.0];
    self.likedView.alpha = 0.f;
    
//    self.likedLabel = [[UILabel alloc] init];
//    self.likedLabel.bounds = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
//    self.likedLabel.font = [UIFont fontWithName:@"HiraKakuProN-W6"
//                    size:24.f];
//    self.likedLabel.text = self.options.likedText;
//    self.likedLabel.textColor = [UIColor whiteColor];
//    [self.likedLabel sizeToFit];
//    self.likedLabel.center = CGPointMake(self.likedView.center.x, self.likedView.frame.size.height/5);
//    self.likedLabel.alpha = 0.f;
//    
//    self.likedLabelFrame = [[UIView alloc] initWithFrame:
//                           CGRectMake(0, 0, self.likedLabel.frame.size.width+30, self.likedLabel.frame.size.height+30)];
//    self.likedLabelFrame.center = self.likedLabel.center;
//    self.likedLabelFrame.backgroundColor = [UIColor clearColor];
//    self.likedLabelFrame.layer.cornerRadius = 5.f;
//    [self.likedLabelFrame.layer setBorderColor:[[UIColor whiteColor] CGColor]];
//    [self.likedLabelFrame.layer setBorderWidth:MDCSwipeToChooseLabelFrameWidth];
//    self.likedLabelFrame.alpha = 0.f;
    
    [self addSubview:self.likedView];
    [self addSubview:self.likedLabelView];
    //[self addSubview:self.likedLabelFrame];
}

- (void)constructNopeImageView {
    /**
     * Original
     */
    CGFloat width = CGRectGetMidX(self.imageView.bounds);
    CGFloat xOrigin = CGRectGetMaxX(_imageView.bounds) - width - MDCSwipeToChooseViewHorizontalPadding;
    self.nopeLabelView = [[UIImageView alloc] initWithFrame:CGRectMake(xOrigin,
                                                                  MDCSwipeToChooseViewTopPadding,
                                                                  width,
                                                                  MDCSwipeToChooseViewLabelWidth)];
    [self.nopeLabelView constructBorderedLabelWithText:self.options.nopeText
                                            color:self.options.nopeColor
                                            angle:self.options.nopeRotationAngle];
    self.nopeLabelView.alpha = 0.f;
    
    CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.nopeView = [[UIView alloc] initWithFrame:frame];
    self.nopeView.backgroundColor = [UIColor colorWithRed:75.0/255.0 green:140.0/255.0 blue:231.0/255.0 alpha:1.0];
    self.nopeView.alpha = 0.f;
    
//    self.nopeLabel = [[UILabel alloc] init];
//    self.nopeLabel.textAlignment = NSTextAlignmentCenter;
//    self.nopeLabel.font = [UIFont fontWithName:@"HiraKakuProN-W6"
//                                           size:24.f];
//    self.nopeLabel.text = self.options.nopeText;
//    self.nopeLabel.textColor = [UIColor whiteColor];
//    [self.nopeLabel sizeToFit];
//    self.nopeLabel.center = CGPointMake(self.nopeView.center.x, self.nopeView.frame.size.height/5);
//    self.nopeLabel.alpha = 0.f;
//    
//    self.nopeLabelFrame = [[UIView alloc] initWithFrame:
//                           CGRectMake(0, 0, self.nopeLabel.frame.size.width+30, self.nopeLabel.frame.size.height+30)];
//    self.nopeLabelFrame.center = self.nopeLabel.center;
//    self.nopeLabelFrame.backgroundColor = [UIColor clearColor];
//    self.nopeLabelFrame.layer.cornerRadius = 5.f;
//    [self.nopeLabelFrame.layer setBorderColor:[[UIColor whiteColor] CGColor]];
//    [self.nopeLabelFrame.layer setBorderWidth:MDCSwipeToChooseLabelFrameWidth];
//    self.nopeLabelFrame.alpha = 0.f;
    
    [self addSubview:self.nopeView];
    [self addSubview:self.nopeLabelView];
    //[self addSubview:self.nopeLabel];
}

- (void)setupSwipeToChoose {
    MDCSwipeOptions *options = [MDCSwipeOptions new];
    options.delegate = self.options.delegate;
    options.threshold = self.options.threshold;

    __block UIView *likedImageView = self.likedView;
    __block UIView *nopeImageView = self.nopeView;
    __weak MDCSwipeToChooseView *weakself = self;
    options.onPan = ^(MDCPanState *state) {
        if (state.direction == MDCSwipeDirectionNone) {
            likedImageView.alpha = 0.f;
            self.likedLabelView.alpha = 0.f;
            nopeImageView.alpha = 0.f;
            self.nopeLabelView.alpha = 0.f;
        } else if (state.direction == MDCSwipeDirectionLeft) {
            likedImageView.alpha = 0.f;
            self.likedLabelView.alpha = 0.f;
            nopeImageView.alpha = state.thresholdRatio/2;
            self.nopeLabelView.alpha = state.thresholdRatio;
            self.nopeLabelFrame.alpha = state.thresholdRatio;
        } else if (state.direction == MDCSwipeDirectionRight) {
            likedImageView.alpha = state.thresholdRatio/2;
            self.likedLabelView.alpha = state.thresholdRatio;
            nopeImageView.alpha = 0.f;
            self.nopeLabelView.alpha = 0.f;
        }

        if (weakself.options.onPan) {
            weakself.options.onPan(state);
        }
    };

    [self mdc_swipeToChooseSetup:options];
}

@end
