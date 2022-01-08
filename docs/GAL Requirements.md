# Abstract
General Aviation or "GA" designates non commercial civil aviation ([definition](https://en.wikipedia.org/wiki/General_aviation)). It is an ecosystem of well known participants and record keeping requirements. 
General Aviation Ledger ("GAL"), the open source solution set forth herein, is a decentralized system of records for GA leveraging blockchain capabilities. The intended user base is the entire GA population. GAL primary purpose is to serve as a shared backend component to third party services / user interfaces. 
# Use cases
Use cases listed below, we will be using the following personas:
* Steve is a student pilot going through flight training. 
* Ines is a flight instructors. She is a pilot and a Certified Flight Instructor ("CFI").

Each participant (Steve, Ines) is represented on GAL by a **globally unique identity** used to represent ownership, enforce access control, and perform various operations. GAL does not issue identities. Participants should either use a self managed identity (such as [Metamask](https://metamask.io/)) or trust the presentation layer to manage it for them.

## Tracking flight time with Pilot Log Books
A Pilot Log Book ("PLB") registers detailed information about every flight for a given pilot. Each PLB belongs to a single pilot and is not transferable. 

### Creation and Access Rights
Upon joining GAL **Steve creates his Pilot Log Book** which automatically belongs to him. PLB creation is optional. Some participants may use GAL for other purposes. Steve may also transition from paper to GAL PLB, which means **Steve is able to import/create old records in his PLB**.
By default, Steve PLB is only accessible to him, but in the early days of his training, Ines may create entries in Steve's PLB. Pilots can grant one of four access rights : *None*, *Read*, *Write* and *Grant*. 
**Steve grants Read access to Ines**. Ines is now able to read all records in Steve's PLB.
**Steve grants Write access to Ines**. Ines is now able to create records. 

During his flight training journey, Steve may interact with multiple Instructors or part ways with instructors. 
**Steve grants access to {another instructor}**. This would not impact Ines access. Access rights are given individually.
**Steve updates Ines access to None** . Ines can neither Read or Write entries in Steve's PLB.
We [recommend](#plb-access-right-abstraction) to abstract the access right in the presentation layers for ease of use. 
For the remainder of the use case, we will assume Ines has *Write* access.
In order to verify recent changes or checking current status **Steve can see a list of access rights to his PLB**.
To check whether she can create a flight on behalf of a student, **Ines can see the access right on Steve's PLB**.

### Record New Flights
New entries in the PLB can be created by the pilot or the instructor.
**Ines create a record of Steve flight** by providing [flight data fields](#flight-data-fields). If Ines does not have Write access to Steve PLB, the creation should fail. 
**Steve creates a record of his flight** by providing [flight data fields](#flight-data-fields). Steve may not put himself as the CFI.
Note: Private Pilot flying solo will create flights without CFI reference.

### CFI Flight Signature
When Steve creates a flight record, he may want Ines to sign it a CFI. **Steve creates a PLB flight signature request** by designating Ines as the CFI. 
* Ines may accept: **Ines accepts the flight signature request** from Steve. This action updates the flight record with "CFI Signature" and marks the signature request as accepted.
* Ines may refuse: **Ines rejects the flight signature request** from Steve. This action marks the signature request as rejected but does not update the PLB flight record.
When Ines creates a flight record in Steve PLB, she can create the record with a CFI signature.

### Accessing PLB records
**Steve has instantaneous access to his total flight time**. Even after thousands of flights. This data should be readily available. This number should be 0 if no record exist in the Pilot Log Book.
** Steve sees a list off all records in his PLB**
**Ines sees a list of all record in Steve PLB**

# Recommendations
## PLB Access Right Abstraction
We recommend presentation layers to simplify PLB access rights by implementing a "Designated CFI". The following scenarios should be possible:
* Steve designated Ines as his CFI. Ines is now able to create records in Steve Pilot Log book. Ines cannot grant access to Steve PLB.
* Provided Ingrid is a pilot signed up on GAL. Steve changes his CFI to Ingrid. Ingrid now has access to Steve PLB and Ines looses all access.
* Steve designates Pierre as a friend. Pierre is now able to read Steve's PLB. Pierre cannot create records in Steve's PLB.

# References
## Data Format
### Airport Code
Airport codes are four characters long. See [ICAO](https://en.wikipedia.org/wiki/ICAO_airport_code)
### Duration
Duration is a number of minutes. 
Note: Flight time are currently recorded in hours and 1/10th of an hour. They need to be translated. For example: 1.9h => 114min (1h + 9x6min)

## Aircraft Categories
This temporary list will be extended
*	ASEL : Airplane Single Engine Land
*	AMEL : Airplane Multiple Engine Lang
*	GT : Ground Trainer is not a category but flight can be recorded for simulation
*	
## Flight data fields
* Date : Flight date
* Aircraft Make and Model : Free form text
* Aircraft Identification : 6 Characters starting with 'N'
* Point of Departure and Arrival : Two distinct fields  **From** {Airport Code} and **To** {Airport Code}
* Aircraft Category: (4 characters) Flight time gets allocated to a single category ([list](#aircraft-categories))
* Type of Piloting Time : (3 characters) What was the pilot role during that flight?
	* DR : Dual Received
	* PIC : Pilot in Command
	* CFI : Instructor
* Conditions of Flight
	* Day : ([duration](#duration))
	* Night : ([duration](#duration))
	* Cross Country : ([duration](#duration))
	* Actual Instrument : ([duration](#duration))
	* Simulated Instrument : 
* Number of Instrument Approaches : (Number)
* Number of Day Landings : (Number)
* Number of Night Landings : (Number)
* Total Flight Duration : ([duration](#duration))
* CFI Identity : Identity of the flight instructor as claimed by the pilot.
* CFI Signature : Actual CFI that signed this flight.
* Remarks: Free form text
