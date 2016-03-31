//
//  SWDriverTestBigoDef.h
//  SWDriverTestBingo
//
//  Created by EShi on 1/8/16.
//  Copyright © 2016 Eren. All rights reserved.
//

#ifndef SWDriverTestBigoDef_h
#define SWDriverTestBigoDef_h

typedef enum{
    kTestQuestionViewSequence = 1,
    kTestQuestionViewGlance,
    kTestQuestionViewMark,
    kTestQuestionViewFav,
    kTestQuestionViewWrongQuestions,
    kTestQuestionViewTest,
} TestQuestionViewType;

#define USER_PRESS_SHOW_SIDE_MENU_BTN @"USER_PRESS_SHOW_SIDE_MENU_BTN"
#define USER_PRESS_USER_INFO_MENU_BTN @"USER_PRESS_USER_INFO_MENU_BTN"

//Notification define
#define APP_WILL_RESIGNACTIVE_NOTIFICATION @"APP_WILL_RESIGNACTIVE_NOTIFICATION"
#define USER_SELECTED_TEST_ANSWER_NOTIFICATION @"USER_SELECTED_TEST_ANSWER_NOTIFICATION"
#define SELECTED_ANSWER__USERINFO_IS_RIGHT_KEY @"SELECTED_ANSWER__USERINFO_IS_RIGHT_KEY"

#define DRIVE_TEST_CHOOSE_QUESTION_TYPE 1
#define DRIVE_TEST_ADJUST_QUESTION_TYPE 2
#endif /* SWDriverTestBigoDef_h */
