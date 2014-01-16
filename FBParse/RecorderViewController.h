//
//  RecorderViewController.h
//  AudioSample
//
//  Created by Sameh Aly on 11/12/13.
//
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "F3BarGauge.h"

@class CMOpenALSoundManager;

@interface RecorderViewController : UIViewController<AVAudioPlayerDelegate, AVAudioRecorderDelegate, CommsDelegate>
{
    BOOL isRecording;
    CustomButton* _btnUpload;
    
    float Pitch;
    NSData *audioData;
    NSTimer *timerForPitch;
    CMOpenALSoundManager *soundMgr;
    AVAudioPlayer *audioPlayerRecord;
    AVAudioRecorder *audioRecorder;
    AVAudioPlayer *audioPlayer;
    
    int recordEncoding;
    
    enum
    {
        ENC_AAC = 1,
        ENC_ALAC = 2,
        ENC_IMA4 = 3,
        ENC_ILBC = 4,
        ENC_ULAW = 5,
        ENC_PCM = 6,
    } encodingTypes;
}

@property (nonatomic) NSUInteger loopCount;
@property (strong, nonatomic) IBOutlet UIView *viewForWave;
@property (strong, nonatomic) IBOutlet UIView *viewForWave2;
@property (nonatomic) CFTimeInterval firstTimestamp;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) CADisplayLink *displayLink;

@property (strong, nonatomic) IBOutlet F3BarGauge *customRangeBar;
@property (nonatomic, strong) NSString *songPath;
@property (nonatomic, strong) NSString *songName;
@property (nonatomic, strong) IBOutlet UIButton *playButton;
@property (nonatomic, strong) IBOutlet UILabel *lblSongName;

@property (nonatomic, strong) IBOutlet UIView *vProgressUpload;
@property (nonatomic, strong) IBOutlet UIProgressView *progressUpload;

- (IBAction)startRecording:(id)sender;
- (IBAction)stopRecording:(id)sender;
- (IBAction)playRecorded:(id)sender;

@end
