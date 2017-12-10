//
//  ViewController.h
//  extra_recipe
//
//  Created by xerub on 13/06/2017.
//  Copyright © 2017 xerub. All rights reserved.
//  Copyright © 2017 1GamerDev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *bg;
@property (strong, nonatomic) IBOutlet UIButton *jb;
@property (strong, nonatomic) IBOutlet UIView *load;
@property (strong, nonatomic) IBOutlet UILabel *actionLabel;
@end

@interface load : UIViewController
@end

@interface Welcome : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *bg;
@property (strong, nonatomic) IBOutlet UIVisualEffectView *welcome;
@property (strong, nonatomic) IBOutlet UIButton *continueBtn;
@end

@interface Go : UIViewController
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@end

