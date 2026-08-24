import json

import requests
from flask import Flask, flash, request, render_template, session
from requests.auth import HTTPBasicAuth

webApp = Flask(__name__)
# Für Flash und Sessions notwendig
webApp.secret_key = 'prototype'  # Für Flash und Sessions notwendig
# URL für ODatav4 Web Services
bc_url = 'http://bcserver/BC/ODataV4/' #URL für ODatav4 Web Services
# Tenant config
tenant = 'tenant=bcserver'
# Verbindung mit Business Central
bc_auth = HTTPBasicAuth('LOGIN', 'PASSWORD') #Anmeldedaten
# Format für den Datenaustausch - JSON
headers = {
    "Content-Type": "application/json"
}
# Abfrage von Studiengängen
def get_study_programs():
    try:
        # Datenabruf vom Webdienst
        response = requests.get(
            bc_url + "Company('CRONUS%20DE')/StudyPrograms?" + tenant,
            headers=headers,
            auth=bc_auth
        )
        # Wenn Daten empfangen wurden, werden die Werte zurückgegeben.
        if response.status_code == 200:
            return response.json().get('value', [])
        else:
            # Andernfalls wird ein Fehler zurückgegeben.
            return Exception("Study programs are not available")
    except Exception as e:
        return Exception("Couldn't reach the server")

# Abfrage von Modulkategorien
def get_module_categories():
    try:
        # Datenabruf vom Webdienst
        response = requests.get(
            bc_url + "Company('CRONUS%20DE')/ModuleCategories?" + tenant,
            headers=headers,
            auth=bc_auth
        )
        # Wenn Daten empfangen wurden, werden die Werte zurückgegeben.
        if response.status_code == 200:
            return response.json().get('value', [])
        else:
            # Andernfalls wird ein Fehler zurückgegeben.
            return Exception("No module categories available")
    except Exception as e:
        return Exception("Couldn't reach the server")

# Abfrage von IT-Kategorien
def get_it_categories():
    try:
        # Datenabruf vom Webdienst
        response = requests.get(
            bc_url + "Company('CRONUS%20DE')/ITCategories?" + tenant,
            headers=headers,
            auth=bc_auth
        )
        # Wenn Daten empfangen wurden, werden die Werte zurückgegeben.
        if response.status_code == 200:
            return response.json().get('value', [])
        else:
            # Andernfalls wird ein Fehler zurückgegeben.
            return Exception("No module categories available")
    except Exception as e:
        return Exception("Couldn't reach the server")

# Sammeln von persönlichen und bildungsbezogenen Daten
def collect_data():
    # Persönliche Daten sammeln
    firstname = request.form.get('firstname')
    lastname = request.form.get('lastname')
    email = request.form.get('email')
    phone = request.form.get('phone')
    birthdate = request.form.get('birthdate')
    nationality = request.form.get('nationality')

    # Universitätsdaten sammeln
    country = request.form.get('country')
    eu = request.form.get('eu')
    university = request.form.get('university')
    programname = request.form.get('programname')
    degree = request.form.get('degree')
    finalgrade = request.form.get('finalgrade')

    # Studiengang speichern
    program = request.form.get('program')

    # Alles im Dictionary speichern
    data_personal = {
        "FirstName": firstname,
        "LastName": lastname,
        "Email": email,
        "Phone": phone,
        "BirthDate": birthdate,
        "Nationality": nationality,
        "EduCountry": country,
        "EduUniversity": university,
        "EduProgramName": programname,
        "EduDegree": degree,
        "EduFinalGrade": float(finalgrade),
        "StudyProgram": program
    }

    # Dictionary mit Daten zurückgeben
    return data_personal

# Sammeln der eingegebenen Module
def collect_modules():
    # Module sammeln
    module_name_zip = request.form.getlist('module_name')
    module_cp_zip = request.form.getlist('module_cp')
    module_category_zip = request.form.getlist('module_category')
    module_it_zip = request.form.getlist('module_it')

    #List erstellen
    data_modules = []

    #Dictionaries erstellen und zu der Liste hinzufügen
    for mn, mcp, mca, mi in zip(module_name_zip, module_cp_zip, module_category_zip, module_it_zip):
        data_modules.append({
            "Name": mn,
            "CP": float(mcp),
            "Category": mca,
            "IT": int(mi)
        })
    # List of Dictionaries mit Daten zurückgeben
    return data_modules

# Rendering des Templates
@webApp.route('/', methods=['GET', 'POST'])
def index():
    checked = False # Schaltflächenfreigabe

    # Wenn nicht alle Daten empfangen werden, wird unavailable gerendert.
    study_programs = get_study_programs()
    if isinstance(study_programs, Exception):
        flash(f"Request failed: {study_programs}")
        return render_template('unavailable.html')

    module_categories = get_module_categories()
    if isinstance(module_categories, Exception):
        flash(f"Request failed: {module_categories}")
        return render_template('unavailable.html')

    it_categories = get_it_categories()
    if isinstance(it_categories, Exception):
        flash(f"Request failed: {it_categories}")
        return render_template('unavailable.html')

    if request.method == 'POST':
        # wenn die Senden-Taste gedrückt wird
        if 'send_btn' in request.form:
            # Sammlung von Daten
            data = json.dumps(collect_data())
            modules = json.dumps(collect_modules())

            data_json = {
                "data": data,
                "modules": modules
            }
            # Anfrage an Business Central
            response = requests.post(
                bc_url + "externalApplication_submitApplication?company='CRONUS%20DE'&" + tenant,
                json=data_json,
                headers=headers,
                auth=bc_auth
            )
            # Antwort als Meldung anzeigen
            result = response.json()
            if response.status_code == 200:
                value = f'{result.get('value', None)}'
                flash(value, 'success')
            else:
                # Beim Fehler
                flash(f'Failed: {response.content}', 'danger')

        elif 'count_modules_btn' in request.form:
            # Daten in sessions speichern
            session['data_personal'] = collect_data()
            session['data_modules'] = collect_modules()
            #Daten sammeln
            program = request.form.get('program')
            modules_json = json.dumps(collect_modules())
            data_json = {
                "data": modules_json,
                "program": program
            }
            # Anfrage an Business Central
            response = requests.post(
                bc_url + "externalApplication_countModulesFromJson?company='CRONUS%20DE'&" + tenant,
                json=data_json,
                headers=headers,
                auth=bc_auth
            )
            # Antwort als Meldung anzeigen
            result_a = response.json()
            if response.status_code == 200:
                value = f'{result_a.get('value', None)}'
                # Positive Antwort
                if value.startswith('You can'):
                    # Freigabe der Schaltfläche
                    checked = True
                    flash('Please check your application details carefully again. '
                          'If the data changes, you need to re-check the application.', 'danger')
                    flash(value, 'success')
                else:
                    # Negative antwort
                    flash(value, 'danger')

            else:
                # Beim Fehler
                flash(f'Failed: {response.status_code}', 'danger')

    # Rückgabe des gerenderten Templates mit allen gesammelten Daten, die angezeigt werden sollen
    return render_template('index.html',
                           study_programs=study_programs,
                           module_categories=module_categories,
                           it_categories=it_categories,
                           data_modules=session.get('data_modules', []),
                           data_personal=session.get('data_personal', []),
                           checked=checked
                           )

if __name__ == '__main__':
    webApp.run(debug=True)
