//
//  STPSectionHeaderView.m
//  Stripe
//
//  Created by Ben Guo on 1/3/17.
//  Copyright © 2017 Stripe, Inc. All rights reserved.
//

#import "STPSectionHeaderView.h"

@interface STPSectionHeaderView()
@property(nonatomic, weak)UILabel *label;
@property(nonatomic)UIEdgeInsets buttonInsets;
@end

@implementation STPSectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *label = [UILabel new];
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:label];
        _label = label;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        button.titleLabel.numberOfLines = 0;
        button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 15);
        button.contentEdgeInsets = UIEdgeInsetsZero;
        [self addSubview:button];
        _button = button;
        _theme = [STPTheme defaultTheme];
        _buttonInsets = UIEdgeInsetsMake(5, 5, 5, 15);
        self.backgroundColor = [UIColor clearColor];
        [self updateAppearance];
    }
    return self;
}

- (void)setTheme:(STPTheme *)theme {
    _theme = theme;
    [self updateAppearance];
}

- (void)updateAppearance {
    self.label.font = self.theme.smallFont;
    self.label.textColor = self.theme.secondaryForegroundColor;
    self.button.titleLabel.font = self.theme.smallFont;
    self.button.tintColor = self.theme.accentColor;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    if (title != nil) {
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.firstLineHeadIndent = 15;
        style.headIndent = style.firstLineHeadIndent;
        NSDictionary *attributes = @{NSParagraphStyleAttributeName: style};
        self.label.attributedText = [[NSAttributedString alloc] initWithString:title
                                                                    attributes:attributes];
    } else {
        self.label.attributedText = nil;
    }
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.button.alpha == 0.f) {
        self.label.frame = self.bounds;
    } else {
        CGFloat halfWidth = self.bounds.size.width/2;
        CGFloat heightThatFits = [self heightThatFits:self.bounds.size];
        self.label.frame = CGRectMake(0, 0, halfWidth, heightThatFits);
        self.button.frame = CGRectMake(halfWidth, 0, halfWidth, heightThatFits);
    }
}

- (CGFloat)heightThatFits:(CGSize)size {
    CGFloat labelPadding = 16;
    if (self.button.alpha == 0.f) {
        CGFloat labelHeight = [self.label sizeThatFits:size].height;
        return labelHeight + labelPadding;
    } else {
        CGSize halfSize = CGSizeMake(size.width/2, size.height);
        CGFloat labelHeight = [self.label sizeThatFits:halfSize].height + labelPadding;
        NSDictionary *attributes = @{NSFontAttributeName: self.button.titleLabel.font};
        UIEdgeInsets insets = self.buttonInsets;
        CGSize buttonTextSize = CGSizeMake(halfSize.width - (insets.left + insets.right),
                                           halfSize.height - (insets.top + insets.bottom));
        CGSize buttonSize = [self.button.titleLabel.text boundingRectWithSize:buttonTextSize
                                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                                   attributes:attributes
                                                                      context:nil].size;
        CGFloat buttonHeight = buttonSize.height + insets.top + insets.bottom;
        return MAX(buttonHeight, labelHeight);
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake(size.width, [self heightThatFits:size]);
}

@end
