# Threat Actors

### What is a Threat Actor?

A threat actor is an individual, group, or organization that conducts malicious activities in cyberspace with the intent to compromise, disrupt, or exploit digital systems and information. NGOs, governments, and businesses must be aware of threat actors to better protect their sensitive data, operations, and beneficiaries.

#### Types of Threat Actors

Threat actors vary in their motivations, techniques, and targets. The following are some of the most common types:

#### Nation-State Actors
- Sponsored or directly controlled by governments.
- Engage in cyber espionage, sabotage, or influence campaigns.
- Often target political institutions, critical infrastructure, and NGOs involved in human rights and policy advocacy.

#### Cybercriminal Groups
- Organized groups motivated by financial gain.
- Conduct activities such as ransomware attacks, financial fraud, and data theft.
- May target NGOs handling donor funds, sensitive personal data, or valuable digital assets.

#### Hacktivists
- Ideologically driven individuals or groups.
- Use cyberattacks to promote social, political, or environmental causes.
- May target NGOs due to their association with specific policies or affiliations.

#### Insider Threats
- Individuals within an organization (e.g., employees, volunteers, contractors).
- May act maliciously or unintentionally expose sensitive information.
- NGOs are particularly vulnerable due to reliance on volunteers and third-party collaborators.

#### Terrorist Organizations
- Use cyber capabilities to spread propaganda, recruit members, and coordinate attacks.
- May exploit NGO resources, impersonate humanitarian efforts, or launch disinformation campaigns.

---

## Identifying a Threat Actor After a Cyber Attack on an NGO

When an NGO experiences a cyber attack, determining who was responsible can be challenging. However, by analyzing attack patterns, digital evidence, and threat intelligence, organizations can identify the type of threat actor and take appropriate action.

#### 1. Analyze the Attack Tactics, Techniques, and Procedures (TTPs)
- Threat actors have distinct TTPs, which can help attribute an attack.
- The MITRE ATT&CK framework can be used to map observed behaviors to known threat actors.
- Common patterns:
  - Nation-state actors use advanced persistence and stealth tactics.
  - Cybercriminals deploy ransomware or steal donor payment details.
  - Hacktivists deface websites or launch DDoS attacks.

#### 2. Investigate Indicators of Compromise (IOCs)
IOCs are technical clues left behind by attackers. NGOs should check:
- Malicious IP addresses, domains, or URLs used in the attack.
- Hash values of malware files.
- Phishing emails and spoofed accounts targeting employees.

These IOCs can be cross-referenced with threat intelligence platforms such as:
- [MISP (Malware Information Sharing Platform)](https://www.misp-project.org/)
- [VirusTotal](https://www.virustotal.com/)
- [AlienVault OTX](https://otx.alienvault.com/)

#### 3. Examine Digital Forensics Evidence
Conduct a forensic investigation to uncover:
- Log files showing unauthorized access or privilege escalation.
- Malware used in the attack and its origin.
- Methods of initial access (e.g., phishing, software vulnerabilities).

If in-house expertise is lacking, NGOs should engage a digital forensics team.

#### 4. Check for Patterns in Previous Attacks
If the NGO has been targeted before, the attack may be part of a broader campaign. Reviewing past incidents can reveal:
- Whether the attack aligns with a known group’s activity.
- If the NGO is on a watchlist of adversaries due to its work.

#### 5. Monitor Threat Intelligence Feeds
NGOs should subscribe to threat intelligence platforms such as:
- [MISP](https://www.misp-project.org/)
- [CERTs (Computer Emergency Response Teams)](https://www.first.org/members/)
- [ISACs (Information Sharing and Analysis Centers)](https://www.nationalisacs.org/)

Additionally, OSINT (Open Source Intelligence) sources, security blogs, and government advisories may provide updates on similar attacks.

#### 6. Engage with Cybersecurity Experts
NGOs can seek assistance from:
- National CERTs (e.g., [ENISA’s CSIRT network](https://www.enisa.europa.eu/topics/csirts-in-europe)).
- Cybersecurity researchers who specialize in threat attribution.
- Private cybersecurity firms that offer incident response services.

#### 7. Evaluate the Attack’s Motivation
Understanding why the attack occurred can provide insight into who might be responsible:

| Motivation         | Likely Threat Actor       |
|------------------------|-----------------------------|
| Financial gain        | Cybercriminals (ransomware, fraud) |
| Political retaliation | Nation-state actors |
| Disruption/activism   | Hacktivists |
| Internal grievance    | Insider threats |
| Terrorism            | Extremist groups |

#### 8. Assess Attribution Cautiously
- False flags are common—attackers may mimic other groups to mislead investigators.
- Full attribution often requires government-level intelligence.
- Instead of pinpointing an individual, focus on identifying the type of actor and their likely affiliation.
