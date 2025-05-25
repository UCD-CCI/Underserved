import os
from pymisp import PyMISP, MISPOrganisation, MISPUser

#hard coded for now - will use .env
MISP_URL = ''
MISP_API_KEY = ''

misp_verifycert = False
misp = PyMISP(MISP_URL, MISP_API_KEY, misp_verifycert)

#create file for install check
SETUP_FILE = '.misp_configured.rd'

# Function to add a user
def add_user(email, org_id, role_id, password, change_pw=True, disabled=False):
    user = MISPUser()
    user.email = email
    user.org_id = org_id
    user.role_id = role_id
    user.password = password
    user.change_pw = change_pw
    user.disabled = disabled
    return misp.add_user(user)


# Function to add an organization
def add_organisation(name, org_type="NGO"):
    organisation = MISPOrganisation()
    organisation.name = name
    organisation.type = org_type
    return misp.add_organisation(organisation)


# Function to add multiple tags
def add_tags(tag_names, base_colour="#003397", exportable=True):
    base_tag = {
        "colour": base_colour,
        "exportable": exportable,
    }
    tags = [{**base_tag, "name": name} for name in tag_names]
    for tag in tags:
        misp.add_tag(tag)


# Check if the setup file exists
if os.path.exists(SETUP_FILE):
    print("Setup has already been completed. Exiting script.")
else:
    # Run the setup process
    # Add admin user
    add_user(
        email="admin_un@myorg.ngo",
        org_id=1,
        role_id=1,  #admin
        password="UnderServed_Change_Me"
    )

    # Add regular user
    add_user(
        email="user_un@myorg.ngo",
        org_id=1,
        role_id=3,  #user
        password="UnderServed_Change_Me"
    )

    # Add an organization
    add_organisation(name="UnderServer", org_type="NGO")

    # Add tags for UnderServed, MISP-Forms, SMS-Spectre
    add_tags(["UnderServed", "MISP-Forms"])

    # Create the setup_done.txt file to indicate that the setup is complete
    with open(SETUP_FILE, 'w') as f:
        f.write("Setup completed successfully.")

    print("Setup completed successfully.")
