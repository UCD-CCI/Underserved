MISP-Forms: Streamlined Cyber Attack Reporting 


![common.png](assets/misp-forms-icon.png){ align=right width=140 }

MISP-Forms is a service designed to provide users with a set of intuitive forms for reporting various types of cyberattacks. 
These forms ensure that all relevant data is accurately captured and structured in a format that makes it actionable for law enforcement agencies, 
national authorities, and organizations such as CSIRTs (Computer Security Incident Response Teams).  Below is a brief description of each form.

### How to Submit a Cyber Threat Report

1. Select the appropriate form based on the type of attack you are reporting (e.g. phishing, smishing, website defacement).  
2. Choose your organisation from the dropdown menu.  
3. Complete the form fields with as much detail as possible, including any relevant technical indicators.  
4. Provide a full description of the incident in the designated text box, then click **Submit**.  

Once submitted, your report will be sent to **MISP**, and a confirmation screen will appear with a link to the relevant section of the platform’s User Guide. This guide offers advice on how to recover from, or mitigate, the type of attack you reported.

---

In addition to standard text-based forms, **MISP-Forms** supports alternative methods for reporting specific types of cyber incidents, including Phishing, Smishing (scam texts), and Quishing (scam QR codes).

#### Phishing Email Reporting

When reporting phishing emails, special care must be taken to avoid accidentally clicking on malicious links or opening dangerous attachments during the reporting process. To mitigate this risk, MISP-Forms allows users to safely upload the phishing email as a `.eml` file export. This approach preserves the full content and metadata of the email without requiring users to manually copy and paste potentially harmful information.

#### Exporting an Email to `.eml`

**Outlook (Desktop App)**  
1. Open the email you want to export.  
2. Click **File > Save As**.  
3. In the "Save as type" dropdown, select **Outlook Message Format – Unicode**.  
4. Change the file extension from `.msg` to `.eml` (if needed) before saving.  
5. Save the file to your computer.  
*Tip: If Outlook doesn't allow `.eml`, you can drag the email to your desktop—this often saves it in `.eml` format automatically.*

**Outlook (Web)**  
1. Open Outlook on the web and sign in.  
2. Navigate to the email you want to save.  
3. Right-click the email.  
4. Select **Download** from the context menu.  
5. Choose **Download as EML** to save the email.

**Apple Mail (Mac)**  
1. Open the email.  
2. Go to **File > Save As**.  
3. Select format: **Raw Message Source (.eml)**.  
4. Save the file to your desired location.

**Gmail**  
1. Open the email.  
2. Click the three-dot menu in the top-right corner of the email window.  
3. Select **Download Message**.

A text-based form is also available for reporting phishing incidents manually. This option is intended for users who prefer not to upload a .eml file and who are confident in their ability to safely extract and input the relevant information such as sender address, subject line, email body, and any suspicious links without interacting with potentially harmful content.

---
### Smishing (Scam Text Message)

Similar to phishing, care must be taken when reporting smishing messages (scam texts). Copying and pasting website links directly from the message into a form poses a risk, as users may accidentally click the malicious link. 

To mitigate this, **MISP-Forms** allows users to upload a screenshot of the message instead. The platform uses **OCR (Optical Character Recognition)** to automatically extract any URLs from the image. The extracted link can then be safely analysed using **Lookyloo**, one of the platform’s integrated analysis tools.

#### Steps to Report a Smishing Incident

1. Choose the **“Smishing”** form from the reporting menu.  
2. Click **Browse** to upload a screenshot of the text message.  
3. Click **Process Image**. You will be shown a preview of the screenshot and the extracted URL.  
4. Verify that the extracted URL is correct. If necessary, make edits directly in the provided field.  
5. Click **Analyse Website** to send the URL to Lookyloo for analysis.  
6. Allow **30–60 seconds** for Lookyloo to process the site, depending on its size and complexity.  
7. Once processing is complete, click **Actions** on the Lookyloo page.  
8. Select **Prepare to Push to MISP**.  
9. Click **Push to MISP** to submit the analysed data as a structured event.


### Quishing (Scam QR Codes)

**MISP-Forms** also supports the reporting of **quishing**—a form of phishing that uses scam QR codes to direct users to malicious websites. The reporting process is similar to that used for smishing. 

By uploading an image of the QR code, the platform extracts the embedded URL and enables safe analysis using **Lookyloo**, reducing the risk of accidentally opening harmful links.

#### Steps to Report a Quishing Incident

1. Choose the **“Quishing”** form from the reporting menu.  
2. Click **Browse** to upload an image of the QR code.  
3. Click **Process Image**. You will be shown a preview of the screenshot and the extracted URL.  
4. Verify that the extracted URL is correct. If necessary, make edits directly in the provided field.  
5. Click **Analyse Website** to send the URL to Lookyloo for analysis.  
6. Allow **30–60 seconds** for Lookyloo to process the site, depending on its size and complexity.  
7. Once processing is complete, click **Actions** on the Lookyloo page.  
8. Select **Prepare to Push to MISP**.  
9. Click **Push to MISP** to submit the analysed data as a structured event.



---

### List of Forms

### Phishing


![common.png](assets/phishing.png){ align=right width=75 }

A phishing email is a deceptive message sent by attackers to trick recipients into revealing sensitive information, 
such as login credentials, credit card numbers, or personal data.


[[More Information]](phishing.md)
[[Report Incident]](https://misp-forms.underserved.org/phishing_choice)



---

### Website Defacement

![common.png](assets/websitedefacement.png){ align=right width=75 }

An attack where an intruder gains unauthorized access to a website and alters its appearance or content. 
Typically, attackers replace the site's content with their own messages, often to display political or 
social statements, spread misinformation, or damage the site's reputation.

[[More Information]](Website%20Defacement.md)
[[Report Incident]](https://misp-forms.underserved.org/web_defacement)



---

### Smishing

![common.png](assets/smishing.png){ align=right width=75 }


Smishing is a type of phishing attack carried out through SMS (text messages). It involves cybercriminals
sending fraudulent messages to trick recipients into revealing sensitive information, such as login credentials, 
financial details, or personal data. 

[[More Information]](smishing.md)
[[Report Incident]](https://misp-forms.underserved.org/smishing)

---

### Denial-of-Service (DoS/DDoS)
![common.png](assets/ddos.png){ align=right width=75 }

A malicious attempt to disrupt the normal functioning of a targeted server, service, or network by overwhelming it 
with a flood of illegitimate requests.

[[More Information]](ddos.md)
[[Report Incident]](https://misp-forms.underserved.org/ddos)

---

### Cross-Site Scripting (XSS)

![common.png](assets/xss.png){ align=right width=75 }

 This attack occurs when an attacker injects malicious scripts into trusted websites or applications, targeting unsuspecting 
 users. Social XSS involves leveraging social engineering tactics to trick victims into interacting with malicious links 
 or payloads.
 
[[More Information]](xss.md)
[[Report Incident]](ttps://misp-forms.underserved.org/xss)
 ---

### Quishing - Scam QR Code

![common.png](assets/quishing.png){ align=right width=75 }

A type of phishing attack that uses QR codes to trick victims into revealing sensitive information or downloading malicious 
content. In these attacks, cybercriminals generate a QR code that, when scanned, redirects the victim to a fraudulent website 
designed to steal credentials, personal information, or payment details. 

 [[More Information]](quishing.md)
[[Report Incident]](https://misp-forms.underserved.org/quishing)

---

### Typo-Squatting

![common.png](assets/typo.png){ align=right width=75 }

 A type of online scam where attackers create fake websites with names that are very similar to real, trusted websites, 
 often by using common typing mistakes. For example, if the real website is "example.com", they might create "exmaple.com" 
 or "examplle.com". When people accidentally visit these fake sites, they might be tricked into sharing personal information, 
 downloading harmful software, or even making payments. 
 
 [[More Information]](typo-squatting.md)
[[Report Incident]](https://misp-forms.underserved.org/typo-squatting)

---

### Invoice Diversion Fraud

![common.png](assets/invoice.png){ align=right width=75 }

Also known as Mandate Fraud or Business Email Compromise, this is a type of financial fraud where a scammer impersonates 
a legitimate supplier, vendor, or business partner and tricks the victim into redirecting payments to a fraudulent bank account.

 [[More Information]](invoice_fraud.md)
[[Report Incident]](https://misp-forms.underserved.org/invoice_diversion)

---

### Scam or Suspicious Website

![common.png](assets/scam-web.png){ align=right width=75 }

a fake site designed to trick people into sharing personal information, such as passwords, credit card numbers, 
or other sensitive data, or to steal money by pretending to offer products, services, or opportunities. 

 [[More Information]](typo-squatting.md)
[[Report Incident]](https://misp-forms.underserved.org/typo-squatting)

---

### SQL Injection Attack

![common.png](assets/sql-injection.png){ align=right width=75 }

A type of cyberattack where a hacker tricks a website into giving them unauthorized access to its database. They do this  by entering special commands (instead of normal input) into a login form or search bar. If the website isn’t properly 
secured, it mistakenly runs those commands, allowing the hacker to steal, change, or even delete important data—like  passwords, credit card details, or private messages.

 [[More Information]](sql-injection.md)
[[Report Incident]](https://misp-forms.underserved.org/sql_injection)

---

### Malware Infection

![common.png](assets/malware.png){ align=right width=75 }

Any software designed to harm, steal, or disrupt a computer, network, or device. Hackers use malware to steal personal 
information, spy on users, damage files, or even take control of entire systems. 

[[More Information]](malware.md)
[[Report Incident]](https://misp-forms.underserved.org/malware)

---

### Ransomware

![common.png](assets/ransomware.png){ align=right width=75 }

A type of malicious software that encrypts files on a computer or network, making them inaccessible to the user. The 
attacker then demands a ransom—usually in cryptocurrency—in exchange for a decryption key. 

[[More Information]](ransomware.md)
[[Report Incident]](https://misp-forms.underserved.org/ransomware)

---

### Disinformation

![common.png](assets/dis-info.png){ align=right width=75 }

the deliberate spread of false or misleading information with the intent to deceive, manipulate public perception, or 
influence behavior. Unlike misinformation, which is false information shared without harmful intent, disinformation is 
intentionally crafted and distributed to achieve specific objectives, such as political influence, social division, 
or economic gain.

[[More Information]](disinformation.md)
[[Report Incident]](https://misp-forms.underserved.org/disinformation)

---

### Man-in-the-Middle

![common.png](assets/mitm.png){ align=right width=75 }

An attack that occurs when an attacker secretly intercepts and possibly alters communication between two parties without them 
knowing. This allows the attacker to steal sensitive data, such as login credentials, financial information, or personal
messages. 


[[More Information]](mitm.md)
[[Report Incident]](https://misp-forms.underserved.org/mitm)


---

### Social Engineering

![common.png](assets/soc-eng.png){ align=right width=75 }

 a type of cyberattack that relies on psychological manipulation rather than technical hacking. Instead of breaking into 
 systems, attackers trick people into giving up confidential information, such as passwords, financial details, or access 
 to sensitive systems.

[[More Information]](soc_eng.md)
[[Report Incident]](https://misp-forms.underserved.org/social_eng)

---

### Vishing (Voice Phishing)

![common.png](assets/vishing.png){ align=right width=75 }

 A type of fraud where attackers use phone calls to manipulate victims into revealing sensitive information, such as login 
 credentials or financial details. Attackers often impersonate trusted entities, such as banks, government agencies, or tech 
 support, to create a sense of urgency and pressure victims into compliance. 
 
[[More Information]](vishing.md)
[[Report Incident]](https://misp-forms.underserved.org/vishing)

---

### Password Attack

![common.png](assets/pass.png){ align=right width=75 }

A type of cyber attack where an attacker tries to gain unauthorized access to a system, account, or network by cracking or 
stealing passwords. Since passwords are often the weakest link in security, attackers use various methods to guess, steal, or bypass them. 

[[More Information]](password_attack.md)
[[Report Incident]](https://misp-forms.underserved.org/password_attack)

---

### Custom Report

![common.png](assets/custom.png){ align=right width=75 }

This form allows you to build a custom event consisting of selected attributes. You can select a category, choose an attribute 
type, and enter a value. You may add multiple attributes. 

[[Report Incident]](https://misp-forms.underserved.org/dynamic_form)

---