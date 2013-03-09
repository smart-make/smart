#include <foo_app_glue.h>

/**
 *  NOTE: This is NOT a valid native application!!
 */

void android_main(struct android_app* app)
{
    int8_t cmd;

    //app_dummy ();

    while (1) {
	cmd = android_app_read_cmd (app);
	switch (cmd) {
	case APP_CMD_INPUT_CHANGED:
	case APP_CMD_INIT_WINDOW:
	case APP_CMD_TERM_WINDOW:
	case APP_CMD_WINDOW_RESIZED:
	case APP_CMD_WINDOW_REDRAW_NEEDED:
	case APP_CMD_CONTENT_RECT_CHANGED:
	case APP_CMD_GAINED_FOCUS:
	case APP_CMD_LOST_FOCUS:
	case APP_CMD_CONFIG_CHANGED:
	case APP_CMD_LOW_MEMORY:
	case APP_CMD_START:
	case APP_CMD_RESUME:
	case APP_CMD_SAVE_STATE:
	case APP_CMD_PAUSE:
	case APP_CMD_STOP:
	case APP_CMD_DESTROY:
	    android_app_post_exec_cmd (app, cmd);
	    break;
	}
    }
}
