#ifndef RECORDER_H
#define RECORDER_H

#include <atomic>
#include <k4a/k4a.h>

extern std::atomic_bool exiting;

// Default control values
static const int32_t defaultExposureAuto         = -12;
static const int32_t defaultWhitebalance     = 4500;
static const int32_t defaultGainAuto             = -1;
static const int32_t defaultBrightness           = 50;
static const int32_t defaultContrast             = 50;
static const int32_t defaultSaturation           = 50;
static const int32_t defaultSharpness            = 50;

int do_recording(uint8_t device_index,
                 char *recording_filename,
                 int recording_length,
                 k4a_device_configuration_t *device_config,
                 bool record_imu,
                 int32_t absoluteExposureValue,
                 int32_t whitebalance,
                 int32_t gain,
                 int32_t brightness,
                 int32_t contrast,
                 int32_t saturation,
                 int32_t sharpness);

#endif /* RECORDER_H */

