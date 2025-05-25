![misp-logo.png](assets/misp-logo.png){ align=right width=160 }

MISP(Malware Information Sharing Platform) A threat intelligence platform for sharing, storing and correlating Indicators of Compromise of targeted attacks, 
threat intelligence, financial fraud information, vulnerability information or even counter-terrorism information. 

Manually creating cyber threat reports can be challenging, requiring specialized training, experience, and time to ensure they are detailed and useful for cybercrime investigations and cybersecurity analysis.

MISP-Forms provides an easy and efficient way to generate high-quality reports, streamlining the process and ensuring consistency. It is recommended for handling the majority of your reporting needs.

However, this section provides a general overview of MISP, covering key concepts and terminology to help users better understand its structure and functionality.

---

### MISP Components

- An "Event" in MISP represents an incident or collection of IoCs related to a specific threat.  
   - Events are structured into attributes, which describe specific details (e.g., IP addresses, email subjects, file hashes).  
   - Creating an Event: Go to `Events > Add Event`. Fill in details like `Event Info`, `Date`, and select the `Threat Level`.  
  
   Attributes and Objects  
  
   - Attributes are individual IoCs (e.g., IP, domain, email address).  
   - Objects group related attributes into a meaningful structure (e.g., email objects include sender, subject, and body attributes).  
  
   Tags  
  
   - Tags allow you to categorise events and attributes, making them easier to search and filter.  
   - Adding Tags: Tags can be added during event creation or by editing an event.  
  
   Taxonomies and Threat Levels  
  
   - Taxonomies are structured tags that follow a consistent format, helping to classify threat information.  
   - Threat Levels: MISP defines four threat levels (High, Medium, Low, Undefined) to quickly convey the severity of an event.
  

## Working with MISP Data  
  
   Creating and Managing Events  
  
   - Create an Event: Fill out event metadata (title, date, distribution) and add attributes or objects.  
   - Edit an Event: Update event details, add more attributes or objects, and assign tags.  
   - Event Actions: Duplicate, delete, or correlate events with existing threat intelligence.  
  
   Adding Attributes  
  
   - Types of Attributes: MISP supports numerous attribute types, including IP addresses, domains, URLs, hashes, emails, and file information.  
   - Best Practices: Ensure attributes are as detailed as possible and accurately tagged.  
   - Publishing Events: Publish the event when it’s ready to share with others, triggering notifications.  
  
   Correlations  
  
   - Correlations: MISP automatically identifies similarities between attributes in different events.  
   - Using Correlations: Use correlations to find connections with known threat data and uncover broader attack campaigns.  

## Event Sharing  
  
When reporting an event in MISP, the following options help categorise and control the intelligence shared:  
  
### Distribution  
  
Defines how widely the event should be shared. Options include:  
- Your organisation only   
- Restricts the event to members of your organisation.  
- This community only – Shares the event within a defined trust group.  
- Connected communities – Distributes the event across trusted partner organisations.  
- All communities – Makes the event available to all MISP users.  
  
### Threat Level  
Indicates the severity of the reported event:  
- High – Represents a significant, immediate threat.  
- Medium – Indicates a moderate risk that requires monitoring.  
- Low – A minor threat that may not require urgent action.  
- Undefined – When the threat level is unknown or unclassified.  
  
### Analysis  
Specifies the level of confidence in the data:  
- Initial – The event has been reported but not yet validated.  
- Ongoing – Further analysis is being conducted.  
- Completed – The event has been fully investigated and confirmed.  
  
Understanding and using these classifications properly enhances the effectiveness of threat intelligence sharing in MISP.  
  
## Traffic Light Protocol

The Traffic Light Protocol (TLP) is a system used to facilitate secure information sharing by defining clear distribution boundaries. It ensures that sensitive information is shared appropriately while protecting sources and affected parties. NGOs often rely on TLP to manage and disseminate threat intelligence responsibly.  
  
### TLP Levels  
  
#### TLP:GREEN  
The information can be shared within the organisation and with trusted partners in the wider community. It is intended for broad but controlled distribution. However, it should not be made publicly available.  
  
#### TLP:AMBER  
The information is restricted to individuals within an organisation and, where necessary, their clients or partner organisations on a need-to-know basis. It should not be shared widely beyond those directly impacted.  
  
#### TLP:RED  
The information is highly sensitive and should only be shared with named individuals directly. It must not be forwarded or shared beyond the original recipients to prevent unintended exposure.  
  
#### TLP:CLEAR  
The information can be shared publicly without restriction. It is suitable for open distribution to a wide audience.  
  
By adhering to TLP guidelines, NGOs can responsibly share intelligence while safeguarding sensitive information and the communities they support.  


### Advanced Features

   Threat Actor Profiles  
  
   - Profiles: Store and manage information about threat actors, including motivation, TTPs (tactics, techniques, and procedures), and associated IoCs.  
  
   Galaxies  
  
   - What are Galaxies? Galaxies are collections of tags that represent high-level threat intelligence concepts (e.g., threat actors, campaigns, tools).  
   - Using Galaxies: Tag events with relevant galaxy clusters to link them to larger threat narratives.  
  
   Sightings  
  
   - Sightings: Record observations of a particular IoC in your environment to track its occurrence.  
   - Adding Sightings: Sightings can be added to an event or individual attributes, helping to monitor IoC prevalence.  

  
### MISP Community and Support  
  
   - Documentation: MISP offers extensive [documentation](https://www.misp-project.org/documentation/) to guide users through advanced features.  
   - Forums and Community Support: Connect with the MISP community through forums, GitHub, and mailing lists for additional support and updates.  
