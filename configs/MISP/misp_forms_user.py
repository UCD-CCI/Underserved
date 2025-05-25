from pymisp import PyMISP
import requests
import os
import secrets
import string

misp_url = 'https://misp.underserved.org'
misp_key = 'misp-api-key'  
misp_verifycert = False

user_email = "misp_forms@local.org"
org_id = 1
role_id = 3  # user

output_file = f"{user_email.split('@')[0]}_authkey.txt"
env_file = "misp-forms/.env" 

alphabet = string.ascii_letters + string.digits + string.punctuation
user_password = ''.join(secrets.choice(alphabet) for _ in range(24))
print(f"Generated password: {user_password}")

misp = PyMISP(misp_url, misp_key, misp_verifycert)

new_user = {
    "email": user_email,
    "org_id": org_id,
    "role_id": role_id,
    "password": user_password,
    "external_auth_required": False,
    "change_pw": True,
    "termsaccepted": True
}

create_response = misp.add_user(new_user)
print(f"DEBUG: create_response = {create_response}")
if 'User' not in create_response:
    print(" Failed to create user:", create_response)
    exit(1)

user_id = create_response['User']['id']
print(f"User created with ID: {user_id}")

user_details = misp.get_user(user_id)
#print(f"DEBUG: user_details = {user_details}")

headers = {
    'Authorization': misp_key,
    'Accept': 'application/json',
    'Content-Type': 'application/json'
}

key_url = f"{misp_url}/users/resetAuthKey/{user_id}"
print(f"DEBUG: Requesting URL = {key_url}")
response = requests.post(key_url, headers=headers, verify=misp_verifycert)
print(f"DEBUG: status_code = {response.status_code}, response = {response.text}")

if response.status_code == 200:
    data = response.json()
    try:
        message = data.get('message', '')
        if "Authkey updated: " not in message:
            raise ValueError("Unexpected response format: no 'Authkey updated' in message")
        authkey = message.split("Authkey updated: ")[1].strip()
        if not authkey:
            raise ValueError("No authkey found after parsing message")

        print(f"Auth key generated: {authkey}")
        try:
            with open(output_file, 'w') as f:
                f.write(f"Email: \n")
                f.write(f"Password: \n")
                f.write(f"Auth Key: \n")
            print(f"Credentials saved to: {output_file}")

            try:
                with open(env_file, 'r') as f:
                    env_content = f.read()
                updated_content = env_content.replace("misp-key", authkey)
                with open(env_file, 'w') as f:
                    f.write(updated_content)
                print(f" Updated {env_file} with new API key")
            except FileNotFoundError:
                print(f" {env_file} not found, skipping update")
            except IOError as e:
                print(f" Failed to update {env_file}: {e}")

        except IOError as e:
            print(f" Failed to write file: {e}")
    except (KeyError, ValueError, IndexError) as e:
        print(f" Error parsing auth key: {e}, response = {data}")
else:
    print(f" Failed to generate auth key: {response.status_code} - {response.text}")
