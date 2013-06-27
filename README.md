CasparSystemTime
================

CasparCG System Time display component

Component parameters
-------------------

### TimezoneOffset
A numeric value representing the time offset minutes of the time displayed by the component in relation to the system time. Can be a positive or negative value.

### Format
A string value from the following list:
* 24hh:mm:ss
* hh:mm:ss
* 24hh:mm
* hh:mm

When this parameter is set, the FormatProvider is automatically assigned with a corresponding object instance.

### FormatProvider
An object reference to a class instance implementing the ITimerDisplayFormat interface. This can only be called from script with one of the provided classes or one created by you.

### Text Display Formatting parameters
The text used to display the system time can be formatted using the following parameters:
* Font
* TextColor
* Size
* Align
* Bold
* Italic

Compiling .SWC file
-------------------
* Open CasparSystemTime.fla with Flash CS 4
* Press CTRL+ENTER to publish and test Flash
* Check there are no compilation errors
* In the Library, right-click the CasparSystemTime component
* Select Export SWC File...
* Name and save the SWC file


Using .SWC file
-------------------
* Copy the .SWC file to the Flash components folder:
	* On Windows 7, C:\\Users\\<username>\\AppData\\Local\\Adobe\\Flash CS4\\en\\Configuration\\Components
	* On Windows XP, C:\\Documents and Settings\\<username>\\Local Settings\\Application Data\\Adobe\\Adobe Flash CS4\\en\\Configuration\\Components