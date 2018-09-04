//
// Created by Alexander Fedosov on 03/09/2018.
//

#import "CMProgressiveImageView.h"
#import "CCBufferedImageDecoder.h"

@interface CMProgressiveImageView() <NSURLSessionDelegate>

@property(nonatomic, strong) NSURLSessionDataTask *connection;
@property(nonatomic) long long int defaultContentLength;
@property(nonatomic, strong) NSData *data;
@property(nonatomic, strong) dispatch_queue_t queue;

@end

@implementation CMProgressiveImageView {

}


- (instancetype)init {
    self = [super init];
    if (self) {
        self.defaultContentLength = 5 * 1024 * 1024;
        self.data = [NSData new];
        self.queue = dispatch_queue_create("tv.camment.progressive_image_decoding", NULL);
    }

    return self;
}

- (void)dealloc {
    [self.connection cancel];
}

- (void)load:(NSURL *)URL {
    [self.connection cancel];

    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
            delegate:self
                                                     delegateQueue:[NSOperationQueue mainQueue]];
    self.connection = [session dataTaskWithURL:URL];
    [self.connection resume];
}

- (void)setURL:(NSURL *)URL {
    _URL = URL;
    [self load:URL];
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    completionHandler(NSURLSessionResponseAllow);
    if (response.expectedContentLength != 0) {
        self.defaultContentLength = response.expectedContentLength;
    }
}

- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(nullable NSError *)error {

}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
    NSMutableData *mutableData = [[NSMutableData alloc] initWithData:self.data];
    [mutableData appendData:data];
    self.data = mutableData;
    
    dispatch_sync(self.queue, ^{
        CCBufferedImageDecoder *decoder = [[CCBufferedImageDecoder alloc] initWithData:self.data];
        [decoder decompress];

        UIImage *image = [decoder toImage];
        if (!image) {
            if (self.data.length == self.defaultContentLength) {
                UIImage *image = [[UIImage alloc] initWithData:self.data];
                if (image) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.image = image;
                        if (self.loadingHandler) { self.loadingHandler(); }
                    });
                }
            }
            return;
            
        }

        UIGraphicsBeginImageContext(CGSizeMake(1, 1));
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextDrawImage(context, CGRectMake(0, 0, 1, 1), image.CGImage);
        UIGraphicsEndImageContext();

        dispatch_async(dispatch_get_main_queue(), ^{
            self.image = image;
            if (self.loadingHandler) { self.loadingHandler(); }
        });
    });
}

@end
