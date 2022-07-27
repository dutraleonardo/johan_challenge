
# Johan Sports Code Challenge
##  Remote abnormality and fall detection system: Level 6

### Questions
#### Caregiver does not receive the SMS or is not near its phone:
First, a modification should be made to the database structure and associate emergency contacts (e.g. friends, relatives, etc.), create a phone_number field associated with the health center, and add a table to the database containing emergency numbers that can be used for all users (e.g. firefighters, police, etc).
Once this is done, if there is a suspicion of a fall, problems with heart rate, or temperature change, a notification is generated requiring the user's response. If the user does not respond, the system sends a notification via SMS to a caregiver, if he does not confirm receipt, the pre-specified social contacts will be notified with an informative message via SMS, and a confirmation message is expected. In case of none these notifications are confirmed, the system can notify the health center with which the patient is associated or some emergency agency as a last resort.
I drew a flowchart to illustrate the solution: 
![flowchart](https://github.com/dutraleonardo/johan_challenge/blob/master/docs/johan_challenge_level6.jpg?raw=true)

#### How does the care giver enters the patient's house?
A Caregiver Consent for Emergency Treatment form must be created, which ensures that the caregiver can make medical decisions guided by health professionals in their absence, enter the patient's residence, and stated permission to have the caregiver arrange for emergency medical care.
This document must be signed by the patient and witnesses.
The caregiver must have access to the patient's address through the notification sent by the system. Also, the additional information inserted in the patient's record on the database must be sent on the notification, this is precious information that can speed up the caregiver's access to the home.
#### What if our system is down? any ways to limit point of failure?
Some strategies can be used to prevent or remediate this situation:
- Monitor application (e.g. Grafana, Kibana, New Relic)
- Load balancer to scale the app through multiples nodes and handle high access and data volume (AWS has a good load balancer)
- Damage containment strategy, if the application becomes unavailable, automatically rebuild and deploy.
- Choosing a programming language that supports fault-tolerance is helpful (elixir <3)
- Always guarantee a high code coverage (unit tests and integration tests).
