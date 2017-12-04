//
//  CMTontonGilletteRedeemViewController.m
//  CammentSDK
//
//  Created by Alexander Fedosov on 04.12.2017.
//

#import "CMTontonGilletteRedeemViewController.h"

@interface CMTontonGilletteRedeemViewController ()<UIWebViewDelegate>

@property(nonatomic, strong) UIWebView *webView;
@property(nonatomic, strong) NSDictionary<NSString *, NSArray<id<CMPresentationRunableInterface>> *> * actions;
@property(nonatomic, weak) id <CMPresentationInstructionOutput> output;
@property(nonatomic, strong) NSString *subject;
@end

@implementation CMTontonGilletteRedeemViewController {
    
}

- (instancetype)initWithSubject:(NSString *)subject {
    self = [super init];
    if (self) {
        self.subject = subject;
    }
    
    return self;
}

+ (instancetype)controllerWithSubject:(NSString *)subject {
    return [[self alloc] initWithSubject:subject];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView = [[UIWebView alloc] init];
    self.webView.delegate = self;
    [self.view addSubview:_webView];
    [self loadPage:@"gl_redeem"];
}

- (void)loadPage:(NSString*)pageName {
    NSString* htmlPath = [[NSBundle cammentSDKBundle] pathForResource:pageName ofType:@"html"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[[NSURL alloc] initFileURLWithPath:htmlPath isDirectory:NO]]];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.webView.frame = self.view.bounds;
}

- (void)presentWithOutput:(id <CMPresentationInstructionOutput>)output
                  actions:(NSDictionary<NSString *, NSArray<id <CMPresentationRunableInterface>> *> *)actions
{
    self.output = output;
    self.actions = actions;
    [output presentationInstruction:nil
             presentsViewController:[[UINavigationController alloc] initWithRootViewController:self]];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *url = request.URL.absoluteString;
    
    if ([url hasPrefix:@"action://cancel"]) {
        [self dismissViewControllerAnimated:YES completion:^{}];
        return NO;
    }
    
    if ([url hasPrefix:@"action://redeem"]) {
        [self loadPage:@"gl_success"];
        return NO;
    }
    
    return YES;
}
@end
