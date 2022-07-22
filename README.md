# JohanChallenge

## The Challenge

### Context

In this exercise we will develop the building blocks of a **remote abnormality and fall detection system** to assist older persons.

One of the main problems facing the public health is the injury that happens due to older persons falling. Fast and proper medical interventions are crucial to reduce the serious consequences on their health. 

To help with this issue, we build a prototype system where health centers can provide their patients with a device that continuously monitor vital signs and motion to automatically detect abnormal vital signs and fall of unattended older person. On detection, the device sends an alert to our system. Upon receiving the alert, the system notifies one of the caregivers attached to the center.


### Level 1: Base Data Layer

Add Database and application layer to manage patients, caregivers and devices. No WEB endpoints are expected. 


**Minimum requirements:**

- caregivers
  - are attached to a health center
  - have a phone number
- patients
  - are attached to a health center
  - have a first and last name
  - have an address
  - have additional unformatted information (how to access the patient, patient conditions etc...)
- devices
  - are owned by a health center
  - are used by a patient
  - have a sim_sid (uniquely identifies the device sim card)


### Level 2: Alerts - Creation

When an abnormal vital sign or a fall is detected, the patients device sends an alert to our system.
Worried about internet network reliability and coverage, we decide for now, to send formatted SMS using a third party service, Twilio, to carry out alert messages.
Twilio then relays the content of that SMS to our system using a callback url that we provided when setting up our twilio account.

Here is the callback URL and a typical alert JSON payload sent via twilio:

**Callback URL:** `POST api/alerts`
**Payload:**
```json
{
  "status": "received",
  "api_version": "v1",
  "sim_sid": "HSXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
  "content": "ALERT DT=2015-07-30T20:00:00Z T=BPM VAL=200 LAT=52.1544408 LON=4.2934847"
  "direction": "from_sim"
}
```

Due to SMS content size limitation from Twilio, we came up with the following payload formatting:

- allways starts with `ALERT`
- Followed by attribute_key=attribute_value for:
  - `DT` for datetime the incident happened
  - `VAL` used to store an arbitrary value (e.g patient temperature, heart rate etc...)
  - `T` for type of alert:
    - `BPM` for abnormal heart rate bpm
    - `TEMP` for abnormal temperature
    - `FALL` for fall
  - `LAT` last recorded GPS latitude
  - `LON` last recorded GPS longitude

**Minimum Requirements:**

- Implement the callback endpoint
- Store the alert information in the database 
  - Parse relevant info from SMS content if necessary.
  - We would like to store the payload for future reference 
  - associate the alert with producer device


### Level 3: Alerts - Search

**Minimum Requirements:**

- Add an endpoint to list alerts (e.g `Get api/alerts`)
- Alerts should be paginable and filterable by `at_dt` and `type_key`

### Level 4: Alerts - Notifications

Upon receiving an alert, a caregiver must be notified by SMS with relevant information.

**Minimum Requirements:**

- Add the logic to prepare the SMS content:
  - Type of alert
  - date and time of the incident
  - Patient's first and last name 
  - patient's additional information

- Add the logic that call the SMS service with relevant info:
  - recipient phone number
  - SMS content

**Notes:**

- Do not worry about actually sending the SMS. You could use a placeholder module/code.
- We would like to see tests asserting that the relevant SMS information is being prepared/sent upon receiving an alert. 

### Level 6: Ideation

No code is expected. Add a section `level 6` to report.md and give a short description of how you would solve those issues: 

- Caregiver does not receive the SMS or is not near its phone
- How does the care giver enters the patient's house?
- What if our system is down? any ways to limit point of failure?


## The results

- You will be evaluated on several things:
  - Your understanding of the problematic and your capacity to ask the good questions (this test description is not perfect, you are invited to ask questions and we will be pleased to answer them)
  - Your design choices and your reasons behind them
  - The quality and readability of your code, don't focus on finishing all of the levels
  - The stability of the code and your ability to find and resolve potential edge-cases
- Code must be written in elixir using the phoenix framework (one of the latest versions should do)
- Mentioned resources (Event, Exercises tc...) and any others that you find useful should be stored in DB using Ecto.
- This is just a JSON API, no visual interface is required and no authentification
- Add a `report.md` at root, explain your design choices, list potential red flags in the current solution, things that you would do differently, the time you spent working on the project, what issues you had/what took you longer than expected.
- You are free to use whatever libraries that you find usefull
- No need to deploy the project, we just need the code.
- Solve the levels in ascending order
- Create at least one commit per level and include the .git when submitting you test
- Once you are done, please send your results to someone from JOHAN. If you are already in discussion with us, send it directly to the person you are talking to. You can send your Github project link or zip your directory and send it via email. If you do not use Github, don't forget to attach your .git folder.

Good luck!

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
