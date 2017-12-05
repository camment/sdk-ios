//
//  CMTontonPizzaHutViewController.m
//  CammentSDK
//
//  Created by Alexander Fedosov on 05.12.2017.
//

#import "CMTontonPizzaHutViewController.h"

@interface CMTontonPizzaHutViewController ()<UIWebViewDelegate>

@property(nonatomic, strong) UIWebView *webView;
@property(nonatomic, strong) NSDictionary<NSString *, NSArray<id<CMPresentationRunableInterface>> *> * actions;
@property(nonatomic, weak) id <CMPresentationInstructionOutput> output;
@property(nonatomic, strong) NSString *subject;
@end

@implementation CMTontonPizzaHutViewController {
    
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
    [self.webView setScalesPageToFit:YES];
    [self.webView setContentMode:UIViewContentModeScaleAspectFit];
    self.webView.delegate = self;
    [self.view addSubview:_webView];
    [self loadPage:@"ph_order"];
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
    [self.webView setScalesPageToFit:YES];
    [self.webView setContentMode:UIViewContentModeScaleAspectFit];
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
    
    if ([url hasPrefix:@"action://order"]) {
        [self loadPage:@"ph_success"];
        return NO;
    }
    
    return YES;
}
@end
