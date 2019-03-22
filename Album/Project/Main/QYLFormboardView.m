//
//  QYLFormboardView.m
//  Album
//
//  Created by Marshal on 2017/10/12.
//  Copyright © 2017年 Marshal. All rights reserved.
//

#import "QYLFormboardView.h"
#import "QYLKindModel.h"
#import "UIView+S_Extend.h"
#import "QYLEnum.h"

@interface QYLFormboardView ()<UITextViewDelegate>
{
    CGFloat _startX,_startY; //移动的初始点
}

@property (nonatomic, copy) UIImage *formImage;
@property (nonatomic, strong) QYLKindModel *kindModel;
@property (nonatomic, strong) UIImageView *ivBackImage;//样板背景图片
@property (nonatomic, assign) QYLSelectTextType selectTextType; //当前选择的文本框是哪个
@property (nonatomic, copy) QYLKindModel *cpKindModel;//copy的样板模型，用于绘制图片

@end

@implementation QYLFormboardView

- (instancetype)initWithKindModel:(QYLKindModel *)kindModel formImage:(UIImage *)formImage {
    if (self = [super init]) {
        _formImage = formImage?formImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:kindModel.imagePath]];
        _kindModel = kindModel;
        [self initContentView];
    }
    return self;
}

- (instancetype)initWithKindModel:(QYLKindModel *)kindModel {
    if (self = [super init]) {
        _formImage = [UIImage imageWithData:[NSData dataWithContentsOfFile:kindModel.imagePath]];
        _kindModel = [kindModel getRealKindModel];
        [self initContentView];
    }
    return self;
}

- (void)initContentView {
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat imageWidth = _formImage.size.width/scale; //图片在屏幕上自适应的宽度
    CGFloat imageHeight = _formImage.size.height/scale;//图片在屏幕上自适应的高度
    //设置好长宽比
    if (_kindModel.scale <= 0) {
        CGFloat maxWidth = SCREEN_WIDTH - 40;
        CGFloat maxHeigh = SCREEN_HEIGHT-topHeight-bottomHeight-40;
        CGFloat wScale = imageWidth/maxWidth;//宽度比
        CGFloat hScale = imageHeight/maxHeigh;//高度比
        if (wScale > hScale) {
            _kindModel.scale = wScale;//保存真实图片大小和显示图片界面比例，保存图片的时候用于按照比例调整
        }else {
            _kindModel.scale = hScale;
        }
    }
    //设置内部视图
    self.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2+10);
    if (CGRectEqualToRect(_kindModel.bounds, CGRectZero)) {
        _kindModel.bounds = CGRectMake(0, 0, imageWidth/_kindModel.scale, imageHeight/_kindModel.scale);
    }
    self.bounds = _kindModel.bounds;
    _ivBackImage = [[UIImageView alloc] initWithFrame:self.bounds];
    _ivBackImage.userInteractionEnabled = YES;
    _ivBackImage.image = _formImage;
    [self addSubview:_ivBackImage];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTextViewChanged:) name:UITextViewTextDidChangeNotification object:nil];
    [self initTextViewWithTextKindModel:_kindModel.firstKindModel tag:100];
    [self initTextViewWithTextKindModel:_kindModel.lastKindModel tag:101];
}

- (void)initTextViewWithTextKindModel:(QYLTextKindModel *)textKindModel tag:(NSInteger)tag {
    UITextView *textView = [[UITextView alloc] initWithFrame:textKindModel.frame];
    NSString *text = textKindModel.text;
    textView.tag = tag;
    textView.backgroundColor = [UIColor clearColor];
    textView.tintColor = [UIColor whiteColor];
    textView.delegate = self;
    textView.textAlignment = NSTextAlignmentCenter;
    textView.textColor = textKindModel.colorModel.kindValue;
    textView.font = [UIFont fontWithName:textKindModel.fontModel.kindValue size:[textKindModel.sizeModel.kindValue floatValue]];
    [_ivBackImage addSubview:textView];
    if (text && text.length > 0 && [textKindModel.typeModel.kindValue integerValue] == QYLTextKindTypeVertical) {
        text = [text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        text = [self getVerticalText:text];
    }
    textView.text = text;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(textViewMoved:)];
    [textView addGestureRecognizer:pan];
}

//设置文本排版
- (void)setTextType:(QYLTextKindType)kindType textView:(UITextView *)textView {
    QYLTextKindModel *textKindModel = [self getCurrentTextKindModel];
    CGPoint center = textView.center;
    CGRect frame = textView.frame;
    NSString *text = textView.text;
    switch (kindType) {
        case QYLTextKindTypeVertical:{
            textView.frame = CGRectMake(center.x-frame.size.height/2, frame.origin.y, frame.size.height, frame.size.width);
            text = [text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            textView.text = [self getVerticalText:text];
        }break;
        case QYLTextKindTypeHorizontal:{
            textView.frame = CGRectMake(center.x-frame.size.height/2, frame.origin.y, frame.size.height, frame.size.width);
            textView.text = [text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        }break;
    }
    textKindModel.frame = textView.frame;
    textKindModel.text = textView.text;
}

- (NSString *)getVerticalText:(NSString *)text {
    NSMutableString *newStr = [NSMutableString string];
    for (NSInteger idx = 0; idx < text.length; idx++) {
        unichar c = [text characterAtIndex:idx];
        if (idx > 0) {
            [newStr appendString:[NSString stringWithFormat:@"\n%C",c]];
        }else {
            [newStr appendString:[NSString stringWithFormat:@"%C",c]];
        }
    }
    return newStr;
}

- (void)updateWithSelectType:(QYLSelectTextType)selectType Text:(NSString *)text {
    UITextView *textView = [self viewWithTag:100+selectType];
    _selectTextType = selectType;
    textView.text = text;
    [self updateTextWithTextView:textView];
}

#pragma mark --更新模板上的状态
- (void)updateFormboardWithOperateType:(QYLOperateType)operateType baseKindModel:(QYLBaseKindModel *)baseKindModel {
    QYLTextKindModel *kindModel = [self getCurrentTextKindModel];
    UITextView *textView = [self viewWithTag:100+_selectTextType];
    switch (operateType) {
        case QYLOperateTypeColor:{
            kindModel.colorModel = baseKindModel;
            textView.textColor = baseKindModel.kindValue;
        }break;
        case QYLOperateTypeFont:{
            kindModel.fontModel = baseKindModel;
            //设置字体样式
            textView.font = [UIFont fontWithName:baseKindModel.kindValue size:[kindModel.sizeModel.kindValue floatValue]];
        }break;
        case QYLOperateTypeSize:{
            kindModel.sizeModel = baseKindModel;
            //设置字体大小
            textView.font = [UIFont fontWithName:kindModel.fontModel.kindValue size:[baseKindModel.kindValue floatValue]];
        }break;
        case QYLOperateTypeTextType:{
            kindModel.typeModel = baseKindModel;
            [self setTextType:[baseKindModel.kindValue integerValue] textView:textView];
        }break;
    }
}

#pragma mark --移动的view事件
- (void)textViewMoved:(UIPanGestureRecognizer *)sender {
    UIView *textView = sender.view;
    if (sender.state == UIGestureRecognizerStateChanged) {
        CGPoint position = [sender translationInView:self];//移动的x、y相对初始点击点的偏移量
        textView.s_X = _startX + position.x;
        textView.s_Y = _startY + position.y;
    } else if (sender.state == UIGestureRecognizerStateBegan) {
        CGPoint startPoint = textView.frame.origin;//textView初始位置
        _startX = startPoint.x;
        _startY = startPoint.y;
        [self changedViewWithTextView:textView];
    }else if (sender.state == UIGestureRecognizerStateEnded) {
        [self getCurrentTextKindModel].frame = textView.frame;
    }else if (sender.state == UIGestureRecognizerStateCancelled) {
        sender.view.frame = CGRectMake(_startX, _startY, textView.s_width, textView.s_height);
    }
}

#pragma mark --textView更改的处理
- (void)onTextViewChanged:(NSNotification *)notification {
    UITextView *textView = notification.object;
    [self updateTextWithTextView:textView];
}

#pragma mark --更新textView;
- (void)updateTextWithTextView:(UITextView *)textView {
    QYLTextKindModel *textKindModel;
    if (_selectTextType == QYLSelectTextTypeFirst) {
        textKindModel = _kindModel.firstKindModel;
    }else {
        textKindModel = _kindModel.lastKindModel;
    }
    NSString *text = textView.text;
    if ([textKindModel.typeModel.kindValue integerValue] == QYLTextKindTypeVertical) {
        text = [text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        textView.text = [self getVerticalText:text];
    }
    textKindModel.text = textView.text;
}

#pragma mark --textView
- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self changedViewWithTextView:textView];
}

- (void)changedViewWithTextView:(UIView *)textView {
    QYLSelectTextType selectType = textView.tag-100;
    if (_selectTextType == selectType) return;
    _selectTextType = selectType;
    if (_textViewSwitchBlock) _textViewSwitchBlock([self getCurrentTextKindModel]);
}

#pragma mark --获取当前的文本模型
- (QYLTextKindModel *)getCurrentTextKindModel {
    @synchronized (self) {
        QYLTextKindModel *textKindModel;
        switch (_selectTextType) {
            case QYLSelectTextTypeFirst:
                textKindModel = _kindModel.firstKindModel;
                break;
            case QYLSelectTextTypeLast:
                textKindModel = _kindModel.lastKindModel;
                break;
        }
        return textKindModel;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
    QYLog(nil);
}

@end
