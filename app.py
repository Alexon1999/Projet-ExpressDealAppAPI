import os
import json
from pathlib import Path
from flask import Flask, render_template, request, Response, jsonify
from werkzeug.exceptions import HTTPException
from dotenv import load_dotenv
from models import Categorie, Client, Inventaire, Location, Materiel
import utils

# load environment variables
env_path = Path('.') / '.env'
load_dotenv(env_path)

# créer un objet Flask
app = Flask(__name__)

# avoir l'objet connexion pour la base de données
cnx = utils.connect_to_mysql_database(
    app, os.environ['db_host'], os.environ['db_user'], os.environ['db_name'],
    os.environ['db_password'], int(os.environ['db_port']),
    autocommit=True)


@app.route('/', methods=['GET', 'POST'])
def index():
    return Response(json.dumps({"message": "Bienvenue à notre API 🙂"}), status=200)


# se connecter
@app.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    login_employe = data.get('login')
    mdp = data.get('mdp')

    # obtenir un curseur
    cursor = cnx.cursor()

    # se_connecter : sql function retourne true/false si les identifiants sonts correctes
    cursor.execute("SELECT se_connecter(%s , %s)", (login_employe, mdp))

    peut_se_connecter = cursor.fetchone()[0]

    if not peut_se_connecter:
        cursor.close()
        return Response(json.dumps({"autoriser": False, "error": "Vos identifiants sont incorrects"}), mimetype='application/json', status=400)

    # procédure stocké qui retourne l'employé
    cursor.execute('CALL get_employe_par_identifiants(%s , %s)',
                   (login_employe, mdp))
    employe = cursor.fetchone()
    print(employe)

    cursor.close()

    employe_id, nom, prenom, adresse_id, image_url, email, magasin_id, actif, *_ = employe

    return Response(json.dumps({"id": employe_id, "nom": nom, "prenom": prenom, "image_url": image_url, "email": email,  "adresseId":  adresse_id, "magasinId": magasin_id, "actif": actif == 1, "autoriser": True, "error": None}), mimetype='application/json', status=200)


# on envoient une list de materiel dans l'inventaire d'un magasin en particulier
# avec materiel_id ,  nom et la quantite
@app.route('/inventaire_magasin/<int:id_magasin>', methods=['GET'])
def inventaire_magasin(id_magasin):
    cursor = cnx.cursor()
    cursor.execute("""SELECT m.materiel_id , m.nom ,  COUNT(*) as quantite from inventaire i
                        INNER JOIN materiel m ON m.materiel_id = i.materiel_id
                        WHERE i.magasin_id = %s
                        GROUP BY m.materiel_id """, (id_magasin,))
    data = cursor.fetchall()

    cursor.close()

    json_data = [Inventaire(row[0], row[1], row[2]).to_dict() for row in data]

    return Response(json.dumps(json_data), mimetype='application/json', status=200)


# avoir le détail d'un materiel
@app.route('/materiel/<int:id_materiel>', methods=['GET'])
def materiel_detail(id_materiel):
    cursor = cnx.cursor()
    cursor.execute(
        'SELECT * from materiel m inner join categorie c on c.categorie_id= m.categorie_id where materiel_id = %s', (id_materiel,))
    data = list(cursor.fetchone())
    # Object of type datetime is not JSON serializable
    # data[9] = str(data[9])  # (updated_at) convert datetime object to string
    cursor.close()

    print(data)

    materiel = Materiel(data[0], data[2], data[3],
                        data[4], data[5], data[6], data[7], data[8], data[10], data[11])

    return Response(materiel.to_json(), mimetype='application/json', status=200)


# une liste avec tous les noms du matereils
@app.route('/get_nom_materiels', methods=['GET'])
def get_nom_materiels():
    cursor = cnx.cursor()
    cursor.execute('select nom from materiel')

    materiels = [m[0] for m in cursor.fetchall()]
    print(materiels)

    cursor.close()

    return Response(json.dumps(materiels), mimetype='application/json', status=200)


# liste avec id et nom categorie
@app.route('/get_categories', methods=['GET'])
def get_categories():
    cursor = cnx.cursor()
    cursor.execute('select categorie_id , nom from categorie')

    data = cursor.fetchall()
    cursor.close()

    categories = [Categorie(categ[0], categ[1]).to_dict()
                  for categ in data]

    return Response(json.dumps(categories), mimetype='application/json', status=200)


# recupere toutes les location d'un magasin en particulier
@app.route('/get_locations/<int:id_magasin>', methods=['GET'])
def get_locations(id_magasin):
    cursor = cnx.cursor()
    cursor.execute('SELECT location_id , date_location , i.inventaire_id , m.nom , c.nom , c.prenom from location l INNER JOIN inventaire i ON i.inventaire_id = l.inventaire_id INNER JOIN client c ON c.client_id = l.client_id INNER JOIN materiel m ON m.materiel_id=i.materiel_id INNER JOIN employe e ON e.employe_id=l.employe_id WHERE e.magasin_id = %s', (id_magasin))

    data = cursor.fetchall()
    cursor.close()

    # loc est un tuple, *loc : spreading tuple
    locations = [Location(*loc).to_dict() for loc in data]
    print(locations)

    return Response(json.dumps(locations), mimetype='application/json', status=200)


# recupere toutes les location non rendus d'un magasin en particulier
@app.route('/get_locations_non_rendus/<int:id_magasin>', methods=['GET'])
def get_locations_non_rendus(id_magasin):
    cursor = cnx.cursor()
    cursor.execute('SELECT location_id , date_location , i.inventaire_id , m.nom , c.nom , c.prenom from location l INNER JOIN inventaire i ON i.inventaire_id = l.inventaire_id INNER JOIN client c ON c.client_id = l.client_id INNER JOIN materiel m ON m.materiel_id=i.materiel_id INNER JOIN employe e ON e.employe_id=l.employe_id WHERE e.magasin_id = %s AND l.date_retour IS NULL', (id_magasin))

    data = cursor.fetchall()
    cursor.close()

    locations = [Location(*loc).to_dict() for loc in data]
    print(locations)

    return Response(json.dumps(locations), mimetype='application/json', status=200)


# recupere les clients d'un magasin
@app.route('/get_clients/<int:id_magasin>', methods=['GET'])
def get_clients_magasin(id_magasin):
    cursor = cnx.cursor()
    cursor.execute(
        'select client_id , nom , prenom from client where magasin_id=%s', (id_magasin,))
    data = cursor.fetchall()
    cursor.close()

    clients = [Client(*row).to_dict() for row in data]

    return Response(json.dumps(clients), mimetype='application/json', status=200)


# Avoir les matereils disponible dans inventaire (inventaire_id n'est pas dans location or date_retour IS NOT NULL) d'un magasin
@app.route('/get_materiels_dispo/<int:id_magasin>', methods=['GET'])
def get_materiels_dispo(id_magasin):
    cursor = cnx.cursor()
    cursor.execute(
        'select  m.nom , i.inventaire_id from inventaire i INNER JOIN materiel m ON m.materiel_id = i.materiel_id WHERE i.inventaire_id NOT IN (select inventaire_id from location) OR EXISTS( select * from location l INNER JOIN employe e ON e.employe_id=l.employe_id WHERE e.magasin_id = %s AND l.date_retour IS NOT NULL AND i.inventaire_id = l.inventaire_id) ORDER BY i.inventaire_id', (id_magasin,))
    data = cursor.fetchall()
    cursor.close()

    inventaire = [{"NomMateriel": row[0], "IdInventaire": row[1]}
                  for row in data]

    return Response(json.dumps(inventaire), mimetype='application/json', status=200)


# + Insertion

@app.route('/create_materiel', methods=['POST'])
def create_materiel():
    data = request.get_json()
    nom = data.get('nom')
    description = data.get('description')
    marque = data.get('marque')
    duree_location = data.get('dureeLocation')
    cout_location = data.get('coutLocation')
    cout_remplacement = data.get('coutRemplacement')
    taille = data.get('taille')
    categorie_id = data.get('categorie_id')

    cursor = cnx.cursor()
    cursor.execute('INSERT INTO materiel(nom , description , marque , duree_location , cout_location , cout_remplacement , taille , categorie_id) values(%s , %s , %s , %s , %s , %s , %s , %s)',
                   (nom, description, marque, duree_location, cout_location, cout_remplacement, taille, categorie_id))

    cursor.close()

    return Response(json.dumps({"message": "ok"}), mimetype='application/json', status=201)


@app.route('/create_materiels_inventaire', methods=['POST'])
def create_materiels_inventaire():
    data = request.get_json()
    materiel = data.get('materiel')
    quantite = data.get('quantite')
    magasin_id = data.get('magasin_id')

    cursor = cnx.cursor()
    cursor.execute(
        'select materiel_id from materiel where nom = %s', (materiel))
    materiel_id = cursor.fetchone()[0]

    print(materiel_id)

    for _ in range(quantite):
        cursor.execute('INSERT INTO inventaire(materiel_id , magasin_id) values(%s , %s )',
                       (materiel_id, magasin_id))

    cursor.close()

    return Response(json.dumps({"message": "ok"}), mimetype='application/json', status=201)


@app.route('/create_location', methods=['POST'])
def materiels_par_magasin_employe():
    data = request.get_json()
    inventaire_id = data.get('inventaireId')
    client_id = data.get('clientId')
    employe_id = data.get('employeId')

    cursor = cnx.cursor()
    cursor.execute(
        'INSERT INTO location(inventaire_id , client_id, employe_id) VALUES(%s, %s , %s)', (inventaire_id, client_id, employe_id))
    cursor.close()

    return Response(json.dumps({"message": "ok"}), mimetype='application/json', status=201)


# + modification

@app.route('/update_materiel', methods=['POST'])
def update_materiel():
    data = request.get_json()
    id_materiel = data.get('idMateriel')
    nom = data.get('nom')
    description = data.get('description')
    marque = data.get('marque')
    duree_location = data.get('dureeLocation')
    cout_location = data.get('coutLocation')
    cout_remplacement = data.get('coutRemplacement')
    taille = data.get('taille')
    categorie_id = data.get('categorie_id')

    cursor = cnx.cursor()
    cursor.execute('UPDATE materiel set nom = %s , description = %s , marque = %s  , duree_location = %s , cout_location = %s , cout_remplacement = %s, taille =%s , categorie_id = %s where materiel_id=%s',
                   (nom, description, marque, duree_location, cout_location, cout_remplacement, taille, categorie_id, id_materiel))

    cursor.close()

    return Response(json.dumps({"message": "ok"}), mimetype='application/json', status=202)


# + Statistique (fait avec des vues SQL)

# nombre de matériels empruntés sur le jour courant par magasin
@ app.route('/get_nb_locations_aujourdhui', methods=['GET'])
def get_nb_location_aujourdhui():
    cursor = cnx.cursor()
    # utilisation de la vue, recupere id magasin et nombre de locations
    cursor.execute('SELECT * FROM get_nb_locations_aujourdhui_par_magasin;')
    data = cursor.fetchall()

    cursor.close()

    data = [{"magasinId": row[0], "nbLocations": row[1]} for row in data]

    return Response(json.dumps(data), mimetype='application/json', status=200)


# le magasin avec plus de chiffre d'affaire
@ app.route('/get_magasin_plus_CA', methods=['GET'])
def get_magasin_plus_ca():
    cursor = cnx.cursor()
    cursor.execute('SELECT * FROM magain_tries_par_ca')
    data = cursor.fetchone()

    return Response(json.dumps({"magasinId": data[0], 'CA': round(data[1], 2)}), status=200, mimetype='application/json')


# materiel le plus et le moins empruntés par magsin
@app.route('/get_materiel_plus_moins_empruntes', methods=['GET'])
def get_materiel_plus_moins_empruntes():
    cursor = cnx.cursor()
    cursor.execute('SELECT * FROM materiel_tries_par_nbemprunts')
    data = cursor.fetchall()
    cursor.close()
    if len(data) != 0:
        materiel_plus_empruntes = {
            "idMateriel": data[0][0], "nomMateriel": data[0][1], "nbEmprunts": data[0][2]}
        materiel_moins_empruntes = {
            "idMateriel": data[-1][0], "nomMateriel": data[-1][1], "nbEmprunts": data[-1][2]}

        return Response(json.dumps({"materielPlusEmpruntes": materiel_plus_empruntes,
                                    "materielMoinsEmpruntes": materiel_moins_empruntes
                                    }),
                        status=200, mimetype='application/json')

    return Response(json.dumps({"message": "Aucun Elements touvés"}), status=404, mimetype='application/json')


# Error


@ app.errorhandler(HTTPException)
def handle_exception(error):
    """Return JSON instead of HTML for HTTP errors."""
    # start with the correct headers and status code from the error
    response = error.get_response()
    # replace the body with JSON
    response.data = json.dumps({
        "code": error.code,
        "name": error.name,
        "description": error.description,
    })
    response.content_type = "application/json"
    return response


if __name__ == '__main__':
    app.run(debug=True, port=3000)
