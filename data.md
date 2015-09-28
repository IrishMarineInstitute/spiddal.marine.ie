% Galway Bay Cable Observatory Data Files
% Adam Leadbetter
% 2015-09-28
#Galway Bay Cable Observatory Data Files
## Table of Contents

 1. [General Directory Structure](#general-directory-structure)
 2. [Instruments](#instruments)
	 1. [Conductivity Temperature Depth sensor](#conductivity-temperature-depth-sensor)
	 2. [Fluorometer](#fluorometer)

##General Directory Structure
The data files are arranged in a directory structure by instrument type, specific instrument, and then year, month, day e.g.

	- {InstrumentTypeA}
		| - {InstrumentMakeModelSerialNumberA}
			|- 2015
				|- 10
					|- 01
					|- 02
	- {InstrumentTypeB}
		|- {InstrumentMakeModelSerialNumberB}
			|-2015
				|- 10
					|- 01
					|- 02

During the day, data files are streamed from the sensors to these directories. At the end of the day both a .zip and a .tar.gz compressed archive of the day's files is created in the folder, and for certain instrument types a concatenated version of the day's files is created removing the individual files streamed in during the day. At the end of a month, a .zip and a .tar.gz archive for the full month is also created for ease of data delivery.
## Instruments
### Conductivity Temperature Depth sensor
An [Idronaut Ocean-Seven][1] [304][2] Conductivity-Temperature-Depth probe is installed on the observatory infrastructure. It measures the temperature and conductivity of the seawater (the conductivity is used to calculate an estimate of the salinity); the pressure exert by the seawater above (from which the depth of the sensor is estimated); and these parameters are also used to estimate the speed of sound within the sea. 

The data files produced by the CTD are available [here][3]. The data files contain the following columns:

    Date-time|InstrumentID| {Tab separated data columns}

 - Date-time is a time stamp from a Global Positioning System receiver at the cable observatory shore station in the format YYYY-MM-DDThh:mm:ss.sss where:
	 - YYYY is the year
	 - MM is the month number within the year (e.g. 03 for March)
	 - DD is the day number within the month
	 - T delimits between the date and time
	 - hh is the hour within the day
	 - mm is the minute within the hour
	 - ss.sss is the second.milliseconds within the minute
	 - Z indicates the GPS timestamp is in Co-ordinated Universal Time ([UTC][4])
 - Instrument-ID is a unique identifier for the instrument based on its manufacturer, model number and serial number
 - [Seawater pressure][5] in [decibars][6]
 - [Temperature of the seawater][7] in [degrees Celsius][8]
 - [Electrical conductivity][9] of the seawater in [Siemens per metre][10]
 - [Salinity][11] of the seawater (salinity has [no units][12])
 - [Sound velocity][13] in seawater in [metres per second][14]
 - Instrument [time][15] stamp in the format [hh:mm:ss.ss][16]M
###Fluorometer
A [WetLabs][17] [ECO-FLNTU][18] (serial number #3137) is installed on the observatory infrastructure. It measures the fluorescence of the seawater to give an estimate of the volume of chlorophyll present (indicative of the amount of phytoplankton in the seawater) and it measures turbidity, or the "cloudiness" of the seawater, caused by the presence of particles such as sediment from the seabed suspended in the water.

The data files produced by the fluorometer are available [here][19]. The data files contain the following columns:

    Date-time|InstrumentID| {Tab separated data columns}

 - Date-time is a time stamp from a Global Positioning System receiver at the cable observatory shore station in the format YYYY-MM-DDThh:mm:ss.sss where:
	 - YYYY is the year
	 - MM is the month number within the year (e.g. 03 for March)
	 - DD is the day number within the month
	 - T delimits between the date and time
	 - hh is the hour within the day
	 - mm is the minute within the hour
	 - ss.sss is the second.milliseconds within the minute
	 - Z indicates the GPS timestamp is in Co-ordinated Universal Time ([UTC][4])
 - Instrument-ID is a unique identifier for the instrument based on its manufacturer, model number and serial number
 - Instrument clock date in the format MM/DD/YYYY
 - Instrument clock [time][20] in the format [hh:mm:ss][16]
 - Wavelength of light used to make fluorescence measurements in [nanometres][21]
 - Chlorophyll fluorometer instrument [output (counts)][22] ([no units][12])
 - Wavelength of light used to make turbidity measurements in [nanometres][21]
 - Optical scattering turbidity sensor instrument [output (counts)][23] ([no units][12])
 - Thermistor

[1]: http://www.idronaut.it/cms/view/products/multiparameter-ctds/oceanographic-ctds/ocean-seven-304iplusi/s369
[2]: http://vocab.nerc.ac.uk/collection/L22/current/TOOL0861/
[3]: http://spiddal.marine.ie/data/ctds/I-OCEAN7-304-XXXX/
[4]: https://en.wikipedia.org/wiki/Coordinated_Universal_Time
[5]: http://vocab.nerc.ac.uk/collection/P07/current/CFSN0330/
[6]: http://vocab.nerc.ac.uk/collection/P06/current/UPDB/
[7]: http://vocab.nerc.ac.uk/collection/P01/current/TEMPPR01/
[8]: http://vocab.nerc.ac.uk/collection/P06/current/UPAA/
[9]: http://vocab.nerc.ac.uk/collection/P01/current/CNDCST01/
[10]: http://vocab.nerc.ac.uk/collection/P06/current/UECA/
[11]: http://vocab.nerc.ac.uk/collection/P01/current/PSALCU01/
[12]: http://vocab.nerc.ac.uk/collection/P06/current/UUUU/
[13]: http://vocab.nerc.ac.uk/collection/P01/current/SVELCV01/
[14]: http://vocab.nerc.ac.uk/collection/P06/current/UVAA/
[15]: http://vocab.nerc.ac.uk/collection/P01/current/AHMSDD01/
[16]: http://vocab.nerc.ac.uk/collection/P06/current/UHMS/
[17]: http://wetlabs.com/eco-flntu
[18]: http://vocab.nerc.ac.uk/collection/L22/current/TOOL0215/
[19]: http://spiddal.marine.ie/data/fluorometers/WL-ECO-FLNTU-3137/
[20]: http://vocab.nerc.ac.uk/collection/P01/current/AHMSAA01/
[21]: http://vocab.nerc.ac.uk/collection/P06/current/UXNM/
[22]: http://vocab.nerc.ac.uk/collection/P01/current/FCNTRW01/
[23]: http://vocab.nerc.ac.uk/collection/P01/current/NVLTOBS1/
