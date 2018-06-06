//
//  HYGUIKit.m
//  DemoConfig
//
//  Created by 胡亚刚 on 2017/9/4.
//  Copyright © 2017年 hu yagang. All rights reserved.
//

#import "HYGUIKit.h"

@implementation HYGUIKit

+ (UILabel *)labelWithFont:(UIFont *)font
                 textColor:(UIColor *)textColor
             textAlignment:(NSTextAlignment)textAlignment
             numberOfLines:(NSInteger)numberOfLines
                      text:(NSString *)text {

    UILabel * label = [UILabel new];
    label.font = font;
    label.textColor = textColor;
    label.textAlignment = textAlignment;
    label.numberOfLines = numberOfLines;
    label.text = text;
    return label;
}

+ (UIButton *)buttonWithBackgroundColor:(UIColor *)backgroundColor
                             titleColor:(UIColor *)titleColor
                            normalImage:(UIImage *)normalImage
                            selectImage:(UIImage *)selectImage
                                  title:(NSString *)title
                              titleFont:(UIFont *)titleFont {

    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = backgroundColor;
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    if (normalImage) {
        [button setImage:normalImage forState:UIControlStateNormal];
    }
    if (selectImage) {
        [button setImage:selectImage forState:UIControlStateSelected];
    }
    button.titleLabel.font = titleFont;

    return button;
}

+ (UIView *)viewWithBackgroundColor:(UIColor *)backgroundColor {

    UIView * view = [UIView new];
    view.backgroundColor = backgroundColor;
    return view;
}

+ (UITextView *)textViewWithBackgroundColor:(UIColor *)backgroundColor
                                       font:(UIFont *)font
                                  textColor:(UIColor *)textColor
                              textAlignment:(NSTextAlignment)textAlignment
                                       text:(NSString *)text {

    UITextView * textView = [UITextView new];
    textView.backgroundColor = backgroundColor;
    textView.font = font;
    textView.textColor = textColor;
    textView.textAlignment = textAlignment;
    textView.text = text;
    return textView;
}

+ (UIImageView *)imageViewWithBackgroundColor:(UIColor *)backgroundColor
                                        image:(UIImage *)image
                                  contentMode:(UIViewContentMode)contentMode {

    UIImageView * imageView = [UIImageView new];
    imageView.backgroundColor = backgroundColor;
    imageView.image = image;
    imageView.contentMode = contentMode;
    return imageView;
}

+ (UITextField *)textFieldWithBackgroundColor:(UIColor *)backgroundColor
                                  borderStyle:(UITextBorderStyle)borderStyle
                                         font:(UIFont *)font
                                    textColor:(UIColor *)textColor
                                textAlignment:(NSTextAlignment)textAlignment
                                  placeholder:(NSString *)placeholder
                              clearButtonMode:(UITextFieldViewMode)clearButtonMode
                                 keyboardType:(UIKeyboardType)keyboardType {

    UITextField * textField = [UITextField new];
    textField.backgroundColor = backgroundColor;
    textField.borderStyle = borderStyle;
    textField.font = font;
    textField.textColor = textColor;
    textField.textAlignment = textAlignment;
    textField.placeholder = placeholder;
    textField.clearButtonMode = clearButtonMode;
    textField.keyboardType = keyboardType;
    return textField;
}

+ (UIWebView *)webViewWithDelegate:(id<UIWebViewDelegate>)delegate {

    UIWebView * webView = [UIWebView new];
    webView.delegate = delegate;
    return webView;
}

@end
