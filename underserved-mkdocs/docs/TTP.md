

#### What are TTPs?
In cybersecurity, Tactics, Techniques, and Procedures TTPs describe the methods used by cyber threat actors to conduct attacks. Understanding TTPs helps organizations detect, prevent, and respond to cyber threats effectively.

TTPs are commonly used in threat intelligence frameworks like MITRE ATT&CK to classify and track attacker behavior.

#### Tactics
Tactics refer to the high-level objectives that a threat actor aims to achieve during an attack. These represent what the attacker is trying to do, rather than how they do it.

Examples of Common Tactics:  
- Initial Access – Gaining a foothold in the target network e.g., phishing, exploiting vulnerabilities.  
- Execution – Running malicious code on a victim’s system.  
- Persistence – Maintaining access after initial compromise.  
- Privilege Escalation – Gaining higher-level access to carry out more damaging actions.  
- Credential Access – Stealing usernames, passwords, or authentication tokens.  
- Exfiltration – Stealing sensitive data.  
- Impact – Destroying, disrupting, or manipulating data e.g., ransomware, data wiping.  

#### Techniques
Techniques describe the specific methods used to achieve a tactic. Different threat actors may use similar tactics but rely on different techniques.

Examples of Techniques:  
- Phishing Initial Access – Sending deceptive emails to trick users into clicking malicious links or attachments.  
- Brute Force Credential Access – Attempting multiple password combinations to break into accounts.  
- DLL Sideloading Execution – Using a legitimate application to load a malicious file.  
- Living off the Land Privilege Escalation – Using built-in system tools like PowerShell to evade detection.  
- DNS Tunneling Command and Control – Hiding malicious communication within normal internet traffic.  

MITRE ATT&CK provides a comprehensive list of techniques mapped to each tactic, helping defenders understand how attacks are carried out.

#### Procedures
Procedures are the specific implementations of a technique used by a threat actor or a malware strain. This level of detail shows how attackers apply a technique in real-world scenarios.

Example:
- Tactic: Credential Access  
- Technique: Phishing for Credentials  
- Procedure: An attacker sends a fake Microsoft login page to employees via email, prompting them to enter their credentials, which are then stolen.

Procedures can vary between threat actors based on their resources, sophistication, and targets.

#### How to Defend Against TTPs  
To protect against attacks using known TTPs, organizations should:  
- Monitor Threat Intelligence – Stay updated on emerging TTPs from security platforms like [MITRE ATT&CK]https://attack.mitre.org/.  
- Implement Security Controls – Use firewalls, endpoint detection, and behavior-based security tools.  
- Conduct Regular Security Training – Educate staff on recognizing phishing, social engineering, and credential attacks.  
- Harden Systems – Apply patches, enforce multi-factor authentication MFA, and limit user privileges.  
- Perform Threat Hunting – Actively search for signs of intrusion by analyzing network and system logs.  

By leveraging TTP-based intelligence, organizations can enhance their security posture and better protect mission-critical operations.
