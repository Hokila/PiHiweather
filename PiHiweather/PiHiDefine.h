#define ViewX(view) view.frame.origin.x
#define ViewY(view) view.frame.origin.y
#define ViewWidth(view) view.bounds.size.width
#define ViewHeight(view) view.bounds.size.height

/**
 * level = 0   is show all message
 * level = 3   is Normal NSLog
 */
#define DEBUG_TRACE_LEVEL 1

#ifdef DEBUG
    #if (DEBUG_TRACE_LEVEL == 0)
        #define PiHiLog(log,...) NSLog((@"[File %s] [Function %s] [Line %d]\n" log), __FILE__,__PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
    #elif (DEBUG_TRACE_LEVEL == 1)
        #define PiHiLog(log,...) NSLog((@"\n[Function %s] [Line %d]\n" log), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
    #elif (DEBUG_TRACE_LEVEL == 2)
        #define PiHiLog(log,...) NSLog((@"%s\n" log), __PRETTY_FUNCTION__, ##__VA_ARGS__)
    #else
        #define PiHiLog(log,...)    NSLog(log, ##__VA_ARGS__)
    #endif
#else
    #define PiHiLog(...) //nothing output for distribution
#endif


#define ShowAlert(msg) { UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:NSLocalizedString(@"確定",nil) otherButtonTitles:nil];[av show];}
#define ShowAlertWithTitle(title,msg) { UIAlertView *av = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:NSLocalizedString(@"確定",nil) otherButtonTitles:nil];[av show]; }
#define ShowMyAlert(msg,btnCancelTitle,btnOKTitle) { UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:btnCancelTitle otherButtonTitles:btnOKTitle, nil];[av show]; }
#define ShowMyAlertWithTag(title,msg,tag,btnCancelTitle,btnOKTitle) { UIAlertView *av = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:btnCancelTitle otherButtonTitles:btnOKTitle, nil]; [av setTag:tag]; [av show];}
