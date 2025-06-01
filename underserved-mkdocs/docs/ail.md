AIL (Analysing Information Leaks):

![ail](assets/ail.png){ align=right width=200 }


AIL is an open-source tool developed by the Computer Incident Response
Center Luxembourg (CIRCL). 

<br> <div align="center">
   <img src="https://www.ail-project.org/assets/img/dashboard.jpeg"
height="400" /><br>
</div>

## **Overview**

The AIL Framework can ingest both structured and unstructured data for a range of sources, such as web crawling (including onion), discussion forums, chats, rss feeds, and  large data files.

## **Feeders**

The collection of data from various sources can be a tedious task for
analysts. AIL automates this process by providing a variety of feeders
and utilising the Lacus web crawler. These feeders serve as mechanisms
for AIL to ingest data.

Currently active Crawlers/Feeders on AIL instance:

- **Pystemon** – Collects data from pastebin sites, such as Pastebin .com.
- **LeakFeeder** - Submit large data dumps automatically to AIL for
processing

Other available Crawlers/Feeders on AIL instance:

These feeder are not configured on the Underserved platform, but can be added.  See AIL documention for details. [Github](https://github.com/ail-project/) 

- **Lacus** – Crawls and captures screenshots from .onion sites.
- **Telegram** – Captures chat data, metadata, and media from a set of
subscribed Telegram channels.
- **RSS** – Captures data from RSS feeds.

More Feeders
[here](https://github.com/orgs/ail-project/repositories?type=all)


## **Trackers**

AIL processes the data streams provided by feeders, performing
operations to analyse and extract relevant information. This is achieved
through Trackers, which are functional components designed to search for
specific data. Trackers can identify items such as organisation names,
email addresses, websites, cryptocurrency addresses, IBANs, custom
keywords, and more.

Types of Tracker
- Keyword and Keyword Set
- Regular Expression (regex)
- YARA Rule

**Keyword and Keyword Set**:
This Tracker will detect any occurance of the specified keyword or from
a set of keywords. Unless searching for a highly specific term, this
approach is not recommended, as using vague or common keywords may
generate an excessively large volume of results. Additionally,
non-alphanumeric characters cannot be used with this type of tracker
which further limits usage.


**Regular Expression (regex)**
This Tracker can define more flexible and precise search patterns within
Trackers. Regex allows for advanced pattern matching, making it useful
for detecting variations of keywords, specific formats (e.g., email
addresses, URLs), or complex search criteria.


Sample Regular Expression:

This regular Expression will find any mention of an myngo email
address.

```
[A-Za-z0-9._+-]+@myngo\.com\.ie
```
##### Logic Explained

*[A-Za-z0-9._-]+*  - Matches the local part of the email (before @),
allowing letters, numbers, dots, underscores, and hyphens.

*@ngo\.gov\.ie* - Matches the exact domain @ngo.com




**YARA Rule**
This Tracker combines regex with boolean logic to further refine
searches. For example, a YARA rule can be set to detect instances where
an **organisation** and a specific **software** appear in the same post,
or where a particular **vulnerability** is mentioned within a dark web
forum, chat message, or Pastebin post.

Sample YARA Rule:

```
rule sample {
     meta:
         description = "Detects organisation, software, and vulnerability"
     strings:
         $org_name = "Acme Corporation" nocase
         $software = "Sharepoint" nocase
         $vulnerability = "CVE-2024-21318" nocase

     condition:
         ($org_name and $software) or $vulnerability
}

```
##### Logic Explained

1. Rule looks for the organisation name (Acme Corporation) and Software
(Sharepoint) appearing together in the same data stream.
1. It also separately searches for the mention of a specific
vulnerability (CVE-2024-21318).
1. The condition states that either both $org_name and $username must
appear together, or the $vulnerability must be found.

## **Creating Trackers**

AI can assist in crafting high-quality regular expressions (REGEX) and
YARA rules, helping to identify patterns and indicators of compromise
more efficiently. However, it's essential to review and test these
AI-generated rules to ensure their accuracy and effectiveness, as false
positives or missed detections can occur. These tools may be useful for
testing your Trackers.

- [Regular Expressions (Regex101)](https://regex101.com/)
- [YARA
(Cyberchef)](https://gchq.github.io/CyberChef/#recipe=YARA_Rules('',true,true,true,true,true,true))



## **Retro Hunt**

AIL primarily performs real-time analysis of data streams; however, the
Retro Hunt feature allows you use Trackers to search retrospectively
through a data stream’s history. This can be useful for post-incident
activities and investigations.

## **Typo-Squatting**

AIL's Typo-Squatting feature takes a legitimate website address and uses
fuzzing techniques to generate a list of potential typo-squatting
addresses based on the original domain. For example, it may modify the
TLD, replace dots with underscores or dashes, and introduce other common
misspellings. AIL then actively monitors your chosen data streams to
detect any occurrences of these generated addresses.



## **Some Use Cases**
####  **Monitoring Pastebin and Other Paste Sites for Data Leaks**
    - AIL can automatically collect and analyse pastes from platforms like **Pastebin, CodePage, gist.github** and many other pastebin sites.
    - Create Trackers to Detect and Extracts credentials, API Keys and other leaked sensitive data from public facing pastes.
    


####  **Data Breach Detection and Credential Stuffing Prevention**
    - Create appropriate trackers to detect relevant usernames, email domain.
    - Submit copy of leaked data file to AIL, and allow Tracker to analyse for credential leaks.


#### **OSINT Collection & Investigations**
    - Investigators can **search for specific keywords, usernames, or email addresses** across monitored sources.
    - AIL’s analysis can show **correlation** between **leaked data, aliases, and threat actors**.

#### **Retrospectively Search for IoCs**
    - Use AIL's Retro Hunt feature to search retrospectively for Indicators  of Compromise (IoCs) across AIL's data streams. This allows analysts to  apply Trackers to historical data, helping to uncover previously0  undetected threats, correlate past activities, and support post-incident  investigations
    - By leveraging this feature, security teams can analyse past records  for signs of compromise, track threat actor behavior over time, and  improve detection capabilities.


## **MISP Integration**

AIL is integrated with **MISP (Malware Information Sharing
Platform)** to **automatically send extracted IOCs** (e.g., domains,
IPs, hashes). This helps **cyber threat intelligence (CTI) teams**
enrich their threat data within MISP.

<br>
<div align="center">
   <img
src="https://raw.githubusercontent.com/ail-project/ail-framework/refs/heads/master/doc/screenshots/misp_export.png"
height="300" /><br>(Export to MISP)
</div>


## **Training**

- [AIL
Introduction](https://github.com/ail-project/ail-training/blob/master/1-ail-introduction/ail-training.pdf)
- [Writing
YARA](https://github.com/ail-project/ail-training/blob/master/0.1-an-introduction-to-yara/ail-training.pdf)
- [AIL For
CTI](https://github.com/ail-project/ail-training/blob/master/2-ail-cti-use-cases/ail-training.pdf)
- [Darknet and Social Network
Monitoring](https://github.com/ail-project/ail-training/blob/master/0-darknet-monitoring-introduction/ail-training.pdf)
- [FIRST Workshop](https://www.youtube.com/watch?v=KG1xkmdEbHA)
