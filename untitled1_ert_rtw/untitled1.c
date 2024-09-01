/*
 * untitled1.c
 *
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * Code generation for model "untitled1".
 *
 * Model version              : 1.0
 * Simulink Coder version : 24.1 (R2024a) 19-Nov-2023
 * C source code generated on : Wed Aug 28 15:23:06 2024
 *
 * Target selection: ert.tlc
 * Embedded hardware selection: ARM Compatible->ARM Cortex
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */

#include "untitled1.h"
#include "rtwtypes.h"
#include "untitled1_private.h"
#include <string.h>
#include "rt_nonfinite.h"

/* Block signals (default storage) */
B_untitled1_T untitled1_B;

/* Block states (default storage) */
DW_untitled1_T untitled1_DW;

/* Real-time model */
static RT_MODEL_untitled1_T untitled1_M_;
RT_MODEL_untitled1_T *const untitled1_M = &untitled1_M_;
static void rate_monotonic_scheduler(void);

/*
 * Set which subrates need to run this base step (base rate always runs).
 * This function must be called prior to calling the model step function
 * in order to remember which rates need to run this base step.  The
 * buffering of events allows for overlapping preemption.
 */
void untitled1_SetEventsForThisBaseStep(boolean_T *eventFlags)
{
  /* Task runs when its counter is zero, computed via rtmStepTask macro */
  eventFlags[1] = ((boolean_T)rtmStepTask(untitled1_M, 1));
}

/*
 *         This function updates active task flag for each subrate
 *         and rate transition flags for tasks that exchange data.
 *         The function assumes rate-monotonic multitasking scheduler.
 *         The function must be called at model base rate so that
 *         the generated code self-manages all its subrates and rate
 *         transition flags.
 */
static void rate_monotonic_scheduler(void)
{
  /* Compute which subrates run during the next base time step.  Subrates
   * are an integer multiple of the base rate counter.  Therefore, the subtask
   * counter is reset when it reaches its limit (zero means run).
   */
  (untitled1_M->Timing.TaskCounters.TID[1])++;
  if ((untitled1_M->Timing.TaskCounters.TID[1]) > 1) {/* Sample time: [0.2s, 0.0s] */
    untitled1_M->Timing.TaskCounters.TID[1] = 0;
  }
}

/* Model step function for TID0 */
void untitled1_step0(void)             /* Sample time: [0.1s, 0.0s] */
{
  {                                    /* Sample time: [0.1s, 0.0s] */
    rate_monotonic_scheduler();
  }

  /* MATLABSystem: '<Root>/PWM' incorporates:
   *  Constant: '<Root>/LED Dimmer'
   */
  untitled1_DW.obj_h.PWMDriverObj.MW_PWM_HANDLE = MW_PWM_GetHandle(2U);
  MW_PWM_SetDutyCycle(untitled1_DW.obj_h.PWMDriverObj.MW_PWM_HANDLE, (real_T)
                      untitled1_P.LEDDimmer_Value);

  /* Update absolute time */
  /* The "clockTick0" counts the number of times the code of this task has
   * been executed. The absolute time is the multiplication of "clockTick0"
   * and "Timing.stepSize0". Size of "clockTick0" ensures timer will not
   * overflow during the application lifespan selected.
   */
  untitled1_M->Timing.taskTime0 =
    ((time_T)(++untitled1_M->Timing.clockTick0)) * untitled1_M->Timing.stepSize0;
}

/* Model step function for TID1 */
void untitled1_step1(void)             /* Sample time: [0.2s, 0.0s] */
{
  /* MATLABSystem: '<Root>/Analog Input' */
  if (untitled1_DW.obj.SampleTime != untitled1_P.AnalogInput_SampleTime) {
    untitled1_DW.obj.SampleTime = untitled1_P.AnalogInput_SampleTime;
  }

  untitled1_DW.obj.AnalogInDriverObj.MW_ANALOGIN_HANDLE = MW_AnalogIn_GetHandle
    (36U);

  /* MATLABSystem: '<Root>/Analog Input' */
  MW_AnalogInSingle_ReadResult
    (untitled1_DW.obj.AnalogInDriverObj.MW_ANALOGIN_HANDLE,
     &untitled1_B.AnalogInput, MW_ANALOGIN_UINT16);

  /* Update absolute time */
  /* The "clockTick1" counts the number of times the code of this task has
   * been executed. The resolution of this integer timer is 0.2, which is the step size
   * of the task. Size of "clockTick1" ensures timer will not overflow during the
   * application lifespan selected.
   */
  untitled1_M->Timing.clockTick1++;
}

/* Use this function only if you need to maintain compatibility with an existing static main program. */
void untitled1_step(int_T tid)
{
  switch (tid) {
   case 0 :
    untitled1_step0();
    break;

   case 1 :
    untitled1_step1();
    break;

   default :
    /* do nothing */
    break;
  }
}

/* Model initialize function */
void untitled1_initialize(void)
{
  /* Registration code */

  /* initialize non-finites */
  rt_InitInfAndNaN(sizeof(real_T));

  /* initialize real-time model */
  (void) memset((void *)untitled1_M, 0,
                sizeof(RT_MODEL_untitled1_T));
  rtmSetTFinal(untitled1_M, -1);
  untitled1_M->Timing.stepSize0 = 0.1;

  /* External mode info */
  untitled1_M->Sizes.checksums[0] = (2273695434U);
  untitled1_M->Sizes.checksums[1] = (4052082649U);
  untitled1_M->Sizes.checksums[2] = (1889817983U);
  untitled1_M->Sizes.checksums[3] = (73027934U);

  {
    static const sysRanDType rtAlwaysEnabled = SUBSYS_RAN_BC_ENABLE;
    static RTWExtModeInfo rt_ExtModeInfo;
    static const sysRanDType *systemRan[3];
    untitled1_M->extModeInfo = (&rt_ExtModeInfo);
    rteiSetSubSystemActiveVectorAddresses(&rt_ExtModeInfo, systemRan);
    systemRan[0] = &rtAlwaysEnabled;
    systemRan[1] = &rtAlwaysEnabled;
    systemRan[2] = &rtAlwaysEnabled;
    rteiSetModelMappingInfoPtr(untitled1_M->extModeInfo,
      &untitled1_M->SpecialInfo.mappingInfo);
    rteiSetChecksumsPtr(untitled1_M->extModeInfo, untitled1_M->Sizes.checksums);
    rteiSetTPtr(untitled1_M->extModeInfo, rtmGetTPtr(untitled1_M));
  }

  /* block I/O */
  (void) memset(((void *) &untitled1_B), 0,
                sizeof(B_untitled1_T));

  /* states (dwork) */
  (void) memset((void *)&untitled1_DW, 0,
                sizeof(DW_untitled1_T));

  /* Start for MATLABSystem: '<Root>/PWM' */
  untitled1_DW.obj_h.matlabCodegenIsDeleted = false;
  untitled1_DW.obj_h.isInitialized = 1;
  untitled1_DW.obj_h.PWMDriverObj.MW_PWM_HANDLE = MW_PWM_Open(2U, 0.0, 0.0);
  untitled1_DW.obj_h.isSetupComplete = true;

  /* Start for MATLABSystem: '<Root>/Analog Input' */
  untitled1_DW.obj.matlabCodegenIsDeleted = false;
  untitled1_DW.obj.SampleTime = untitled1_P.AnalogInput_SampleTime;
  untitled1_DW.obj.isInitialized = 1;
  untitled1_DW.obj.AnalogInDriverObj.MW_ANALOGIN_HANDLE = MW_AnalogInSingle_Open
    (36U);
  untitled1_DW.obj.isSetupComplete = true;
}

/* Model terminate function */
void untitled1_terminate(void)
{
  /* Terminate for MATLABSystem: '<Root>/PWM' */
  if (!untitled1_DW.obj_h.matlabCodegenIsDeleted) {
    untitled1_DW.obj_h.matlabCodegenIsDeleted = true;
    if ((untitled1_DW.obj_h.isInitialized == 1) &&
        untitled1_DW.obj_h.isSetupComplete) {
      untitled1_DW.obj_h.PWMDriverObj.MW_PWM_HANDLE = MW_PWM_GetHandle(2U);
      MW_PWM_SetDutyCycle(untitled1_DW.obj_h.PWMDriverObj.MW_PWM_HANDLE, 0.0);
      untitled1_DW.obj_h.PWMDriverObj.MW_PWM_HANDLE = MW_PWM_GetHandle(2U);
      MW_PWM_Close(untitled1_DW.obj_h.PWMDriverObj.MW_PWM_HANDLE);
    }
  }

  /* End of Terminate for MATLABSystem: '<Root>/PWM' */

  /* Terminate for MATLABSystem: '<Root>/Analog Input' */
  if (!untitled1_DW.obj.matlabCodegenIsDeleted) {
    untitled1_DW.obj.matlabCodegenIsDeleted = true;
    if ((untitled1_DW.obj.isInitialized == 1) &&
        untitled1_DW.obj.isSetupComplete) {
      untitled1_DW.obj.AnalogInDriverObj.MW_ANALOGIN_HANDLE =
        MW_AnalogIn_GetHandle(36U);
      MW_AnalogIn_Close(untitled1_DW.obj.AnalogInDriverObj.MW_ANALOGIN_HANDLE);
    }
  }

  /* End of Terminate for MATLABSystem: '<Root>/Analog Input' */
}
