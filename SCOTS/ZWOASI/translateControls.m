function ControlTranslation=translateControls(ControlType)
%{
Created by Sergio Bonaque-Gonzalez. Optical Engineer. August 2019
sergiob@wooptix.com

This program translate the values obtained by ASIGetControlCaps to the values expected by C to get or set that control
The expected order is:
%}
ASI_CONTROL_TYPE=struct('ASI_GAIN',0,'ASI_EXPOSURE',1,'ASI_GAMMA',2,'ASI_WB_R',3,'ASI_WB_B',4,'ASI_OFFSET',5,'ASI_BANDWIDTHOVERLOAD',6,'ASI_OVERCLOCK',7,'ASI_TEMPERATURE',8,'ASI_FLIP',9,'ASI_AUTO_MAX_GAIN',10,'ASI_AUTO_MAX_EXP',11,'ASI_AUTO_TARGET_BRIGHTNESS',12,'ASI_HARDWARE_BIN',13,'ASI_HIGH_SPEED_MODE',14,'ASI_COOLER_POWER_PERC',15,'ASI_TARGET_TEMP',16,'ASI_COOLER_ON',17,'ASI_MONO_BIN',18,'ASI_FAN_ON',19,'ASI_PATTERN_ADJUST',20,'ASI_ANTI_DEW_HEATER',21);

ControlTranslation=int32(eval(['ASI_CONTROL_TYPE.' char(ControlType)]));