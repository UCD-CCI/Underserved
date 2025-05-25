from flask import Blueprint, render_template
import requests
import os

recent_events_bp = Blueprint('recent_events', __name__, template_folder='../templates')

@recent_events_bp.route('/recent-events', methods=['GET'])
def recent_events():
    MISP_URL = os.getenv('MISP_URL')
    MISP_API_KEY = os.getenv('MISP_API_KEY')
    MISP_VERIFY_SSL = os.getenv('MISP_VERIFY_SSL', 'False').lower() == 'true'

    headers = {
        'Authorization': MISP_API_KEY,
        'Accept': 'application/json',
        'Content-Type': 'application/json'
    }

    url = f"{MISP_URL}/events/index"

    params = {
        'limit': 15,
        'order': 'desc'
    }

    try:
        response = requests.get(url, headers=headers, params=params, verify=MISP_VERIFY_SSL)
        response.raise_for_status()

        events = response.json()
        event_data = [
            {
                "id": event["id"],
                "info": event["info"],
                "date": event["date"],
                "threat_level": event["threat_level_id"],
                "organization": event.get("Orgc", {}).get("name", "Unknown")
            }
            for event in events
        ][::-1]
    except requests.exceptions.RequestException as e:
        print(f"Error fetching events: {e}")
        event_data = []

    return render_template('recent_events.html', events=event_data)
