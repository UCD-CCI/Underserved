Webform for MISP.

cp template.env .env

Update .env with misp url and authkey

docker compose up -d


Updates (07-01-2025)

- Refactored code to use flask blueprints

- Re-deigned UI to ensure compatibility with mobile devices

- Added forms for ddos, xss, malware, ransomware

- Switched from API to PyMisp on some forms (undecided on which best)

- Added OCR for SMS screenshots (Smishing Form)

- Added URL extraction from QR code (Quishing Form)

- Added Typo-Squatting form

- Added Scam Website form 

- Added Lookyloo API integration

- Added Custom Report Form 

- Added Recent Events (Displays latest Events from MISP)

- Added Traffic Light Protocol (TLP) option to forms
