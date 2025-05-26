<img src="homepage/images/icon_disc.png" alt="UN Icon" width="250" style="float: right; margin-left: 10px;"><br>
  
The UnderServed project aims to offer NGOs a free self-hosted, cyber threat reporting platform that is simple to 
install and easy to use, enabling them to report cyber threat incidents to law enforcement effectively. 

More Information on Project: https://underserved-project.eu/

---
## Deployment Quick Start 

#### Requirement: Server running Ubuntu Server 22.04

These instructions assume you have already setup Gitlab Key and configured DNS

Connect to platform host server over SSH and run these commands:
```bash
git clone ssh://git@ccilab.ucd.ie:2332/underserved/underserved-nginx.git
cd underserved
bash deploy.sh
```
1. Follow on screen instructions and reboot server when instructed.  
2. Re-connect to platform host server over SSH and run these commands.
3. Use **sudo** to run the script this time

```bash   
tmux
cd underserved
sudo bash deploy.sh  
```

4. Follow on screen instructions and reboot server when instructed.  
5. Take note of login credentials before reboot ⚠️

---

## Full Deployment Guide

## DNS Configuration

To make the platform accessible, configure your organisation’s DNS records. Ideally, the Fully Qualified Domain Name (FQDN) should combine the platform name and your organisation’s domain.

### Wildcard Subdomain (Recommended)

A wildcard DNS record allows all subdomains to automatically resolve to the server's IP address. This simplifies managing multiple Underserved platform services.

**DNS Record Example:**
```
underserved.myngo.com            A     <server_ip>
*.underserved.myngo.com          A     <server_ip>
```

**Note:** The asterisk (*) in the wildcard record ensures that any subdomain (e.g., `misp.underserved.myngo.com`) points to the server.

### CNAME Records (Alternative)

If your organisation does not permit wildcard DNS entries, manually configured CNAME records for each service will suffice.

**DNS Record Example:**
```
underserved.myngo.com                    A     <server_ip>
misp.underserved.myngo.com              CNAME underserved.myngo.com
misp-forms.underserved.myngo.com        CNAME underserved.myngo.com
cerebrate.underserved.myngo.com         CNAME underserved.myngo.com
decider.underserved.myngo.com           CNAME underserved.myngo.com
pandora.underserved.myngo.com           CNAME underserved.myngo.com
lookyloo.underserved.myngo.com          CNAME underserved.myngo.com
ail.underserved.myngo.com               CNAME underserved.myngo.com
typosquatting.underserved.myngo.com     CNAME underserved.myngo.com
portainer.underserved-jan.myngo.com     CNAME underserved.myngo.com
mkdocs.underserved-jan.myngo.com        CNAME underserved.myngo.com
```

**Note:** Replace `<server_ip>` with the actual public IP address of your server.

### Choosing Between Wildcard and CNAME Records
- **Wildcard DNS** is easier to manage and automatically covers all subdomains.
- **CNAME Records** require manual configuration but are necessary in environments that restrict wildcard use.

Ensure DNS changes have propagated before starting the deployment.

---

## Download and Execute Deployment Script

Clone the Underserved Repository

```bash
git clone ssh://git@ccilab.ucd.ie:2332/underserved/underserved.git
cd underserved
bash deploy.sh
````

1. Follow on Screen instructions
2. Docker Dependency check will fail - This is expected behaviour on a first deployment.
3. The script will prompt you for your password and install docker. 
4. After docker installation completes you will be asked to **reboot**,  again password is required.


### After Reboot
Reconnect to the server:

Then re-run these commands: (⚠️ This time run use **sudo** to run command. This will also script to run without repeated requests to enter password)
```bash
tmux
cd underserved
sudo bash deploy.sh
```
Using tmux will protect your deployment process from crashing if connection to the server is lost.

### Script Prompts & Configuration

**Python dependencies**
- You will be prompted for you password to install additonal python dependencies

**Overcommit Memory:**
- Choose `y` to enable on the virtual server

**FQDN Configuration:**
- Enter your platform FQDN (e.g., `underserved.myngo.com`)

**Organisation Details:**
- Use a short name without spaces
- Provide a valid administrative email address

**SSL Certificates:**
- Initially, private SSL certificates are used
- You may receive browser warnings (this is expected)
- See Section 2 for setting up valid SSL certificates

The script will now:
- Clone required repositories
- Build Docker images
- Start containers
- Configure service integration

This may take 25–50 minutes and runs unattended.

---

## Installation Complete

When finished, you will be presented with the platform URL and login credentials. **Be sure to save this information.**

You will be prompted to reboot:
- Type `Y`
- Enter the server password

After reboot, access the platform at the provided URL.

**Note:** Because private SSL certificates are used during initial deployment, your browser may display a warning. It is safe to proceed.

---

## Let's Encrypt SSL Script (Optional)

During deployment private SSL certs are generated.  These can be replaced by certificates provided by your organisation or you can generate certificates using Let's Encrypt.
Let's Encrypt is a free, automated, and open Certificate Authority (CA) provided by the Internet Security Research Group (ISRG). The platform includes a script to automate the generation of SSL certificates.

### Running the Script
1. Connect to the platform host via SSH (see Section 3.1).
2. Run the following commands:
```bash
tmux
cd underserved
bash lets_encrypt_ssl_generate.sh
```

The script will prompt for certificate details.

## Sync with Remote MISP Server

This guide explains how to synchronise events between two MISP instances. You can either pull data from a remote MISP server or push data to it. 
Syncing allows threat intelligence sharing across organisations. This is a guide for syncing MISP server A with MISP Server B

---

### MISP Server A
Login to **MISP Server A** with admin account

Create a Sync User on the MISP A

1. Go to **Administration > Add User**.
    
2. Click **Add Sync User**.
    
3. Fill in the details:
    
    - Email: something like `sync@yourorg.local`
    - Set password:       
    - Role: choose a **sync user**
    - Uncheck all boxes below 

4. Choose **Create User**

5. Log out of MISP server 

6. Login with new sync account
7.  Go to **Sync Actions** > Create Sync config
8.  Make a copy of the json output


### MISP Server B  

Login to **MISP Server B** with admin account

1. Go to **Sync Actions** > **Remote Servers**.
    
2. Click **Import**.
    If import not listed in menu on right, simple add /import to the end of the current address, e.g. https://misp.myorg.com/servers/import
    
3. Paste json file created on MISP Server A
		- Enabled synchronisation methods - check push and pull
		- Allow self signed certificates (unsecure)

4. Click **Submit**.

---

### Utilities Script

To support admin basic functions. like password resets, a utility script is provided.

To run, ssh into the platform servers and

```bash
cd underserved
bash utils.sh
```
Utils Menu
Choose option from menu.

```shell
===============================================
 UnderServed Manager Utility
===============================================
1. Restart all UnderServed Docker containers
2. Stop all UnderServed Docker containers
3. Reboot the server
4. Get Platform Admin Username & Password
5. Reset Portainer Password
6. Reset AIL-Framework Password
7. Exit
===============================================


```

---

### Acknowledgements

This project was made possible thanks to the tools provided by the following organisations and open-source communities:

- [CIRCL (Computer Incident Response Center Luxembourg)](https://www.circl.lu/)
	- [MISP (Malware Information Sharing Platform)](https://www.misp-project.org/)
	- [Lookyloo](https://www.lookyloo.eu/)
	- [Pandora](https://github.com/pandora-analysis/pandora)
	- [TypoSquatting-Finder](https://github.com/typosquatter/ail-typo-website)
	- [Cerebrate](https://github.com/cerebrate-project/cerebrate)
  	- [AIL-Framework](https://www.ail-project.org/)
   
- [Portainer CE](https://www.portainer.io/)  
- [MKDocs](https://www.mkdocs.org/)  
- [Homepage by gethomepage.dev](https://gethomepage.dev/)  
- [Decider by CISA](https://github.com/cisagov/decider)
- [Keycloak](https://www.keycloak.org/)




