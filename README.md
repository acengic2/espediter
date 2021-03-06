# e-Špediter
e-Špediter is a mobile application that allows interaction between freight companies and others who need services provided by freight companies. Freight comapnies are able to share information about thier companies and routes they take. Other users are able to search routes they need and take contact info of the company they want to interact with.
# Prerequisites
In order to run the application on emulator or on device (so far, it is runnable from IDE only), following is required:<br/>
•	Download Git and run Git Bash<br/>
•	Download Flutter and run flutter_console.bot<br/>
•	Download Andorid Studio for emulator<br/>
•	Copy path of bin folder (from Flutter installation folder) into system paths
# Installing
Get the project files, open the project from the IDE. After the device/emulator is connected, in order to run the application, type in terminal:
		flutter run
After some time, the application will be built on the device/emulator connected and it will be usasble on the device.
# Changes
**•	V1 – Sprint 1<br/>**
        *o	User Story 1 – Log In Screen done, but having a lot of both, functional and UI bugs<br/>*
        *o	User Story 2 – Create Route Screen having many bugs<br/>*
**•	V2 – Sprint 2<br/>**
	*o	User Story 1 – Log In Screen bugs resolved:<br/>*
		-	Checking internet connection and showing No Internet Connection Screen if there is no connection<br/>
		-	Focus and error text color of hint text<br/>
		-	Validating password if e-mail entered is wrong<br/>
		-	Toast error<br/>
		-	Validations of e-mail and password fields<br/>
		-	Redirection after successful log in<br/>
		-	Capital letters and text color of hint texts<br/>
		-	Disabled multiple click on 'PRIJAVA' button<br/>
		-	Scroll on Log In Screen<br/>
		-	Autocomplete in e-mail field<br/>
	*o	User Story 2 – Create Route Screen bugs resolved:<br/>*
		-	Redirect to List of Routes or No Routes Screen when X button in AppBar is clicked<br/>
		-	Addin and removing fileds for interdestinations<br/>
		-	Design and deafult value of dropdown button<br/>
		-	Height of fields in the upper part of the screen<br/>
		-	Disable focus on 'Datum polaska' field<br/>
		-	Make timepicker not return 00:00 when 'Cancel' is clicked on the timepicker<br/>
		-	Validation of all fields<br/>
		-	Numeric keyboard on 'Popunjenost u procentima' and 'Kapacitet u tonama' fields<br/>
		-	Format input on 'Kapacitet u tonama' field<br/>
		-	Format of 'Dimenzije' field as hint text<br/>
		-	Enable/disable 'KREIRAJ RUTU' button<br/>
		-	Scroll on Create Route Screen<br/>
		-	Writing interdestinations into database<br/>
**•	V3 – Sprint 3<br/>**
	*o	User Story 1 – Create Route Screen bugs resolved:<br/>*
	*o	User Story 2 – List of Routes Screen bugs resolved:<br/>*
	*o	User Story 3 – Edit/Finish active route and list finished routes:<br/>*
	*o	User Story 4 – View and edit Company Info:<br/>*
**•	V4 – Sprint 4 <br/>**
	*o	Refactroing:<br/>*
		-	Circles and lines on createRoute and editRoute screen<br/>
		-	Colors<br/>
		-	TextFormFields<br/>
		-	In companyInfo, part below divider is written in new file<br/>
		-	Folders and files are renamed<br/>
	*o	Active Route Screen bugs resolved:<br/>*
		-	Showing finished routes only of the logged user<br/>
		-	Margins of the divider<br/>
		-	Redirect to List of Routes Screen after update<br/>
		-	Matching date and time to finish route automatically<br/>
		-	Change of Arrival Date does not enable button on Edit Route Screen<br/>
	*o	Company Info Screen bugs resolved:<br/>*
		-	Make whole container clickable<br/>
		-	Insert progress indicator where there is communication with database (just not to show blank screen)<br/>
		-	Redirect to List of Routes Screen after updating info<br/>
		-	Showing logo icon of currently logged user<br/>
**•	V4 – Sprint 4 <br/>**
	*o	Bugs for Edit Route Screen:<br/>*
	*o	Bugs for Company Profile Screen:<br/>*
	*o	Pretraga screen:<br/>*
	
**•	V5 – Sprint 5 <br/>**
      *o   As a "Regular User" I want to be able to view all active Routes and Loads posted by all Companies because I am in              need of finding the one that works best for me.
      *o   As a "Regular User", I want to be able to open Route and Load so that I can preview all info about Route, Load and              Company.
**•	V6 – Sprint 6 <br/>**
      *o   As a Regular User, I want to be able to filter the Routes and Loads offered according to my needs, because my goal            is to search all routes more easily.
      *o  As a Regular User, I want to read and update  my profile details so that I can change my info.<br/>
     
	
