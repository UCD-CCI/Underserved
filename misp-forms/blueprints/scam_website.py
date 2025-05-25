from flask import Blueprint, render_template, request, redirect
from pylookyloo import Lookyloo

lookyloo = Lookyloo('https://lookyloo.underserved.org/')
lookyloo.session.verify = False

scam_website_bp = Blueprint('scam_website', __name__, template_folder='../templates')

@scam_website_bp.route('/scam-website', methods=['GET', 'POST'])
def scam_website():
    if request.method == 'POST':
        url = request.form['url']
        if lookyloo.is_up:
            try:
                permaurl = lookyloo.enqueue(url)
                return redirect(permaurl)
            except Exception as e:
                return f"An error occurred: {e}", 500
        else:
            return "Lookyloo instance is not reachable.", 503
    return render_template('scam-website.html')
