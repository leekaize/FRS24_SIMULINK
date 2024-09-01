/*
 * untitled.c
 *
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * Code generation for model "untitled".
 *
 * Model version              : 1.0
 * Simulink Coder version : 24.1 (R2024a) 19-Nov-2023
 * C source code generated on : Wed Aug 28 15:15:29 2024
 *
 * Target selection: ert.tlc
 * Embedded hardware selection: ARM Compatible->ARM Cortex
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */

#include "untitled.h"
#include <math.h>
#include "untitled_private.h"
#include "rtwtypes.h"
#include <string.h>

/* Block states (default storage) */
DW_untitled_T untitled_DW;

/* Real-time model */
static RT_MODEL_untitled_T untitled_M_;
RT_MODEL_untitled_T *const untitled_M = &untitled_M_;
real_T rt_roundd_snf(real_T u)
{
  real_T y;
  if (fabs(u) < 4.503599627370496E+15) {
    if (u >= 0.5) {
      y = floor(u + 0.5);
    } else if (u > -0.5) {
      y = u * 0.0;
    } else {
      y = ceil(u - 0.5);
    }
  } else {
    y = u;
  }

  return y;
}

/* Model step function */
void untitled_step(void)
{
  real_T tmp;
  uint8_T tmp_0;

  /* Switch: '<Root>/Switch' incorporates:
   *  Constant: '<Root>/OFF'
   *  Constant: '<Root>/ON'
   *  Constant: '<S1>/Constant'
   *  RelationalOperator: '<S1>/Compare'
   *  Sin: '<Root>/Sine Wave'
   */
  if (sin(((real_T)untitled_DW.counter + untitled_P.SineWave_Offset) * 2.0 *
          3.1415926535897931 / untitled_P.SineWave_NumSamp) *
      untitled_P.SineWave_Amp + untitled_P.SineWave_Bias >=
      untitled_P.CompareToConstant_const) {
    tmp = untitled_P.ON_Value;
  } else {
    tmp = untitled_P.OFF_Value;
  }

  /* MATLABSystem: '<Root>/Digital Output' incorporates:
   *  Switch: '<Root>/Switch'
   */
  tmp = rt_roundd_snf(tmp);
  if (tmp < 256.0) {
    if (tmp >= 0.0) {
      tmp_0 = (uint8_T)tmp;
    } else {
      tmp_0 = 0U;
    }
  } else {
    tmp_0 = MAX_uint8_T;
  }

  writeDigitalPin(2, tmp_0);

  /* End of MATLABSystem: '<Root>/Digital Output' */

  /* Update for Sin: '<Root>/Sine Wave' */
  untitled_DW.counter++;
  if (untitled_DW.counter == untitled_P.SineWave_NumSamp) {
    untitled_DW.counter = 0;
  }

  /* End of Update for Sin: '<Root>/Sine Wave' */
}

/* Model initialize function */
void untitled_initialize(void)
{
  /* Registration code */

  /* initialize error status */
  rtmSetErrorStatus(untitled_M, (NULL));

  /* states (dwork) */
  (void) memset((void *)&untitled_DW, 0,
                sizeof(DW_untitled_T));

  /* Start for MATLABSystem: '<Root>/Digital Output' */
  untitled_DW.obj.matlabCodegenIsDeleted = false;
  untitled_DW.obj.isInitialized = 1;
  digitalIOSetup(2, 1);
  untitled_DW.obj.isSetupComplete = true;

  /* InitializeConditions for Sin: '<Root>/Sine Wave' */
  untitled_DW.counter = 0;
}

/* Model terminate function */
void untitled_terminate(void)
{
  /* Terminate for MATLABSystem: '<Root>/Digital Output' */
  if (!untitled_DW.obj.matlabCodegenIsDeleted) {
    untitled_DW.obj.matlabCodegenIsDeleted = true;
  }

  /* End of Terminate for MATLABSystem: '<Root>/Digital Output' */
}
