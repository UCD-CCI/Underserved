from pymisp import PyMISP

MISP_URL = 'url'
MISP_API_KEY = 'api key'

misp_verifycert = False  #
misp = PyMISP(MISP_URL,MISP_API_KEY, misp_verifycert)

# Add tags for UnderServed, MISP-FORMS, SMS-Spectre
tag1 = {
    "name": "source:UnderServed",
    "colour": "#003397",
    "exportable": True,
}
tag2 = {
    "name": "source:MISP-Forms",
    "colour": "#003397",
    "exportable": True,
}

tag3 = {
    "name": "type:typo-squatting",
    "colour": "#003397",
    "exportable": True,
}

tags = [tag1,tag2,tag3]
for tag in tags:
    result = misp.add_tag(tag)