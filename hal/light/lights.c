/*
 * Copyright (C) 2017 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * K3-Note light module by daniel_hk (https://github.com/daniel_hk)
 * 2017/01/19: Initial commit
 * 2017/02/7: handle multiple color and multiple blink
 * 2017/02/7: ignore alpha channel (for the time being)
 * 2017/02/8: fix permission and ownership of blink
 * 2017/02/9: use kernel default for charger/battery (for the time being)
 * 2017/02/9: use handle_notification_battery_locked()
 */

#define LOG_TAG "lights"

#include <cutils/log.h>

#include <stdint.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include <fcntl.h>
#include <stdlib.h>
#include <sys/ioctl.h>
#include <sys/types.h>

#include <hardware/lights.h>
#include <hardware/hardware.h>
#include <private/android_filesystem_config.h>


#define RED_LED_PATH "/sys/class/leds/red"


#ifndef GREEN_LED_PATH
#define GREEN_LED_PATH "/sys/class/leds/green"
#endif

#ifndef BLUE_LED_PATH
#define BLUE_LED_PATH "/sys/class/leds/blue"
#endif

enum {
    RED		= 1,
    GREEN	= 2,
    BLUE	= 4
};

#define COLOR_MASK 0x00ffffff

/* LCD BACKLIGHT */
char const*const LCD_BRIGHTNESS = "/sys/class/leds/lcd-backlight/brightness";

static pthread_once_t g_init = PTHREAD_ONCE_INIT;
static pthread_mutex_t g_lock = PTHREAD_MUTEX_INITIALIZER;
static struct light_state_t battery;
static struct light_state_t notification;
static int g_backlight = 255;

int led_wait_delay(int ms) 
{
    struct timespec req = {.tv_sec = 0, .tv_nsec = ms*1000000};
    struct timespec rem;
    int ret = nanosleep(&req, &rem);

    while(ret)
    {
	if(errno == EINTR)
	{
	    req.tv_sec  = rem.tv_sec;
	    req.tv_nsec = rem.tv_nsec;
	    ret = nanosleep(&req, &rem);
	}
	else
	{
	    perror("nanosleep");
	    return errno;
	}
    }
    return 0;
}

/**
 * device methods
 */
void init_globals(void)
{
    // init the mutex
    pthread_mutex_init(&g_lock, NULL);
}

static int write_int(char const *path, int value)
{
    int fd;

    fd = open(path, O_RDWR);
    if (fd >= 0) {
	char buffer[20];
	int bytes = sprintf(buffer, "%d\n", value);
	int amt = write(fd, buffer, bytes);
	close(fd);
	return amt == -1 ? -errno : 0;
    } else
	return -errno;
}

static int write_str(char const* path, char* value)
{
    int fd;

    fd = open(path, O_RDWR);
    if (fd >= 0) {
	char buffer[64];
	int bytes = snprintf(buffer, sizeof(buffer), "%s\n", value);
	ssize_t amt = write(fd, buffer, (size_t)bytes);
	close(fd);
	return amt == -1 ? -errno : 0;
    } else
	return -errno;
}

static int rgb_to_brightness(struct light_state_t const *state)
{
    int color = state->color & COLOR_MASK;
    return ((77 * ((color >> 16) & 0x00ff))
	+ (150 * ((color >> 8) & 0x00ff)) +
	(29 * (color & 0x00ff))) >> 8;
}

static int blink_led(int color_id, int level, int onMS, int offMS)
{
#define RETRIES 10
    static int redStatus = 0; // 0: off, 1: blink, 2: no blink
#ifdef HAS_GREEN
    static int greenStatus = 0; // 0: off, 1: blink, 2: no blink
#endif
#ifdef HAS_BLUE
    static int blueStatus = 0; // 0: off, 1: blink, 2: no blink
#endif
    int *prevStatus,curStatus;
    int i = 0;
    char brightness[64];
    char delay_off[64];
    char delay_on[64];
    char trigger[64];

    switch (color_id) {
    case RED:
	sprintf(brightness, "%s/brightness", RED_LED_PATH);
	sprintf(delay_off, "%s/delay_off", RED_LED_PATH);
	sprintf(delay_on, "%s/delay_on", RED_LED_PATH);
	sprintf(trigger, "%s/trigger", RED_LED_PATH);
	prevStatus = &redStatus;
	break;
#ifdef HAS_GREEN
    case GREEN:
	sprintf(brightness, "%s/brightness", GREEN_LED_PATH);
	sprintf(delay_off, "%s/delay_off", GREEN_LED_PATH);
	sprintf(delay_on, "%s/delay_on", GREEN_LED_PATH);
	sprintf(trigger, "%s/trigger", GREEN_LED_PATH);
	prevStatus = &greenStatus;
	break;
#endif
#ifdef HAS_BLUE
    case BLUE:
	sprintf(brightness, "%s/brightness", BLUE_LED_PATH);
	sprintf(delay_off, "%s/delay_off", BLUE_LED_PATH);
	sprintf(delay_on, "%s/delay_on", BLUE_LED_PATH);
	sprintf(trigger, "%s/trigger", BLUE_LED_PATH);
	prevStatus = &blueStatus;
	break;
#endif
    default:
	// do nothing and quit
	return -3;	// wrong color
    }

    if (level == 0) {
	curStatus = 0;
    }
    else if ((onMS > 0) && (offMS > 0))
	curStatus = 1;
    else
	curStatus = 2;

    if (*prevStatus == curStatus)
	return -1;

    ALOGV("ledID:%d, curStatus=%d, level=%d, brightness=%s, trigger=%s, onMS=%d, offMS=%d\n",
		color_id, curStatus, level, brightness, trigger, onMS, offMS);
    if (curStatus == 0) {		// clear only
	write_int(brightness, 0);
    }
    else if (curStatus == 1) {		// blink
	write_str(trigger, "timer");
	led_wait_delay(10);
	while (((access(delay_off, F_OK) == -1) || (access(delay_on, F_OK) == -1))
	    && (i < RETRIES))
	{
	    ALOGV("chown, delay_on and delay_off\n");
	    // chown to system permission
	    chown(delay_on, AID_SYSTEM, AID_SYSTEM);
	    chown(delay_off, AID_SYSTEM, AID_SYSTEM);
	    ALOGE("%s or %s doesn't exist!!\n", delay_on, delay_off);
	    // wait 5ms for kernel LED class to create sysfs delay_off/delay_on
	    led_wait_delay(5);
	    i++;
	}
	if (i < RETRIES) {
	    ALOGV("write, onMS and offMS\n");
	    write_int(delay_off, offMS);
	    write_int(delay_on, onMS);
	}
	else return -2;	    // can't create sysfs
    }
    else if (curStatus == 2) {		// set level > 0
	write_str(trigger, "none");
	write_int(brightness, level);	// default full brightness, level??
    }

    *prevStatus = curStatus;

    return 0;
}

static int set_light_backlight(struct light_device_t *dev,
			       struct light_state_t const *state)
{
    int err = 0;
    int brightness = rgb_to_brightness(state);
    if(!dev) {
	return -1;
    }
    ALOGV("*** set_light_backlight, brightness=%d", brightness);
    pthread_mutex_lock(&g_lock);
    err = write_int(LCD_BRIGHTNESS, brightness);
    pthread_mutex_unlock(&g_lock);

    return err;
}

static void set_speaker_light_locked(struct light_device_t* dev,
				     struct light_state_t const* state)
{
    int alpha, red;
#ifdef HAS_GREEN
    int green;
#endif
#ifdef HAS_BLUE
    int blue;
#endif
    int onMS, offMS, ret;
    unsigned int colorRGB;

    if (state == NULL)
        return;

    switch (state->flashMode) {
        case LIGHT_FLASH_TIMED:
            onMS = state->flashOnMS;
            offMS = state->flashOffMS;
            break;
        case LIGHT_FLASH_NONE:
        default:
            onMS = 0;
            offMS = 0;
            break;
    }

    colorRGB = state->color;

    ALOGV("set_speaker_light_locked flashMode %d, colorRGB=%08X, onMS=%d, offMS=%d\n",
		state->flashMode, colorRGB, onMS, offMS);

    alpha = (colorRGB >> 24) & 0xFF;
    red = (colorRGB >> 16) & 0xFF;
#ifdef HAS_GREEN
    green = (colorRGB >> 8) & 0xFF;
#endif
#ifdef HAS_BLUE
    blue = colorRGB & 0xFF;
#endif
    // mix the color here
    if (red) {
	ret = blink_led(RED, red, onMS, offMS);
    }
    else ret = blink_led(RED, 0, 0, 0);
    ALOGV("*** after blink_led(RED=%d), ret=%d", red, ret);
#ifdef HAS_GREEN
    if (green) {
	ret = blink_led(GREEN, green, onMS, offMS);
    }
    else ret = blink_led(GREEN, 0, 0, 0);
    ALOGV("*** after blink_led(GREEN=%d), ret=%d", green, ret);
#endif
#ifdef HAS_BLUE
    if (blue) {
	blink_led(BLUE, blue, onMS, offMS);
    }
    else ret = blink_led(BLUE, 0, 0, 0);
#endif
}

static void handle_charger_battery_locked(struct light_device_t* dev)
{
    ALOGV("*** battery.color=%08X", battery.color);
    if (battery.color & COLOR_MASK) {
        set_speaker_light_locked(dev, &battery);
    } else {
	//workaround: notification and Low battery case, IPO bootup, NLED cannot blink
	set_speaker_light_locked(dev, &battery); 
	set_speaker_light_locked(dev, &notification);
    }
}

static void handle_notification_battery_locked(struct light_device_t* dev)
{
    ALOGV("*** notification.color=%08X", notification.color);
    if (notification.color & COLOR_MASK) {
	set_speaker_light_locked(dev, &notification);
    } else {
	set_speaker_light_locked(dev, &notification);
	set_speaker_light_locked(dev, &battery);       
    }
}

static int set_light_battery(struct light_device_t* dev,
			     struct light_state_t const* state)
{
    pthread_mutex_lock(&g_lock);
    battery = *state;
    handle_notification_battery_locked(dev);
//    handle_charger_battery_locked(dev);
    pthread_mutex_unlock(&g_lock);
    return 0;
}

static int set_light_notifications(struct light_device_t* dev,
	    	   struct light_state_t const* state)
{
    pthread_mutex_lock(&g_lock);
    notification = *state;
    handle_notification_battery_locked(dev);
//    handle_charger_battery_locked(dev);
    pthread_mutex_unlock(&g_lock);
    return 0;
}

/** Close the lights device */
static int close_lights(struct light_device_t *dev)
{
    if (dev) {
	free(dev);
    }
    return 0;
}

/** Open a new instance of a lights device using name */
static int open_lights(const struct hw_module_t *module, char const *name,
	       struct hw_device_t **device)
{
    pthread_t lighting_poll_thread;

    int (*set_light) (struct light_device_t *dev,
	      struct light_state_t const *state);

    ALOGV("%s:name=%s", __func__, name);
    if (0 == strcmp(LIGHT_ID_BACKLIGHT, name))
	set_light = set_light_backlight;
//    else if (0 == strcmp(LIGHT_ID_BATTERY, name))
//        set_light = set_light_battery;
    else if (0 == strcmp(LIGHT_ID_NOTIFICATIONS, name))
	set_light = set_light_notifications;
    else
	return -EINVAL;

    pthread_once(&g_init, init_globals);

    struct light_device_t *dev = malloc(sizeof(struct light_device_t));
    memset(dev, 0, sizeof(*dev));

    dev->common.tag = HARDWARE_DEVICE_TAG;
    dev->common.version = 0;
    dev->common.module = (struct hw_module_t *)module;
    dev->common.close = (int (*)(struct hw_device_t *))close_lights;
    dev->set_light = set_light;

    *device = (struct hw_device_t *)dev;

    return 0;
}

static struct hw_module_methods_t lights_methods =
{
    .open = open_lights,
};

/*
 * The light Module
 */
struct hw_module_t HAL_MODULE_INFO_SYM =
{
    .tag = HARDWARE_MODULE_TAG,
    .version_major = 1,
    .version_minor = 0,
    .id = LIGHTS_HARDWARE_MODULE_ID,
    .name = "K3-Note lights module",
    .author = "daniel_hk",
    .methods = &lights_methods,
};

