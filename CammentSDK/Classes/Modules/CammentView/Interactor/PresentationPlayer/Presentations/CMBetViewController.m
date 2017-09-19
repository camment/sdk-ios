//
// Created by Alexander Fedosov on 19.09.17.
//

#import "CMBetViewController.h"
#import "CMStore.h"

@interface CMBetViewController () <UIWebViewDelegate>

@property(nonatomic, strong) UIWebView *webView;
@property(nonatomic, strong) NSDictionary<NSString *, NSArray<id<CMPresentationRunableInterface>> *> * actions;
@property(nonatomic, weak) id <CMPresentationInstructionOutput> output;
@property(nonatomic, strong) NSString *subject;
@end

@implementation CMBetViewController {

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
    NSString* htmlPath = [[NSBundle cammentSDKBundle] pathForResource:@"bettingform" ofType:@"html"];
    NSString *html = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:NULL];
    html = [html stringByReplacingOccurrencesOfString:@"${subject}" withString:self.subject];
    [self.webView loadHTMLString:html baseURL:nil];
    self.webView.delegate = self;
    [self.view addSubview:_webView];
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

    if ([url hasPrefix:@"action://bet"]) {
        NSArray<id <CMPresentationRunableInterface>> *runable= self.actions[@"bet"];
        [self dismissViewControllerAnimated:YES completion:^{
            for (id<CMPresentationRunableInterface> r in runable) {
                [r runWithOutput:self.output];
            }
        }];
        return NO;
    }

    return YES;
}
@end
