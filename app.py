import os
import json
from flask import Flask, render_template, request, Response, jsonify
from werkzeug.exceptions import HTTPException
import utils
from models import Categorie, Inventaire, Materiel
from dotenv import load_dotenv
from pathlib import Path

# load envirnment variables
env_path = Path('.') / '.env'
load_dotenv(env_path)

# créer un objet Flask
app = Flask(__name__)

# avoir l'objet connexion pour la base de données , à mettre dans un fichier .env (variable d'environnement)
cnx = utils.connect_to_mysql_database(
    app, os.environ['db_host'], os.environ['db_user'], os.environ['db_name'], os.environ['db_password'], int(os.environ['db_port']),  autocommit=True)


@ app.route('/', methods=['GET', 'POST'])
def index():
    # obtenir un curseur
    cursor = cnx.cursor()

    cursor.close()

    return 'ok'


@ app.route('/login', methods=['POST'])
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

    cursor.execute('CALL get_employe_par_identifiants(%s , %s)',
                   (login_employe, mdp))
    employe = cursor.fetchone()
    print(employe)

    cursor.close()

    employe_id, nom, prenom, adresse_id, image_url, email, magasin_id, actif, *_ = employe

    return Response(json.dumps({"id": employe_id, "nom": nom, "prenom": prenom, "image_url": image_url, "email": email,  "adresseId":  adresse_id, "magasinId": magasin_id, actif: actif == 1, "autoriser": True, "error": None}), mimetype='application/json', status=200)


@ app.route('/inventaire_magasin/<int:id_magasin>', methods=['GET'])
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


@ app.route('/materiel/<int:id_materiel>', methods=['GET'])
def materiel_detail(id_materiel):
    cursor = cnx.cursor()
    cursor.execute(
        'SELECT * from materiel where materiel_id = %s', (id_materiel,))
    data = list(cursor.fetchone())
    # data[9] = str(data[9])  # (updated_at) convert datetime object to string
    cursor.close()

    print(data)

    materiel = Materiel(data[0], data[2], data[3],
                        data[4], data[5], data[6], data[7], data[8])
    return Response(materiel.to_json(), mimetype='application/json', status=200)


@ app.route('/get_nom_materiels', methods=['GET'])
def get_nom_materiels():
    cursor = cnx.cursor()
    cursor.execute('select nom from materiel')

    materiels = [m[0] for m in cursor.fetchall()]
    print(materiels)

    cursor.close()

    return Response(json.dumps(materiels), mimetype='application/json', status=200)


@ app.route('/get_categories', methods=['GET'])
def get_categories():
    cursor = cnx.cursor()
    cursor.execute('select categorie_id , nom from categorie')

    categories = [Categorie(categ[0], categ[1]).to_dict()
                  for categ in cursor.fetchall()]

    cursor.close()

    return Response(json.dumps(categories), mimetype='application/json', status=200)


@ app.route('/create_materiel', methods=['POST'])
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


@ app.route('/create_materiels_inventaire', methods=['POST'])
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

    return Response(json.dumps({"message": "ok"}), mimetype='application/json', status=200)


@ app.route('/materiels_magasin_employe', methods=['GET', 'POST'])
def materiels_par_magasin_employe():
    cursor = cnx.cursor()
    cursor.execute('select * from employe')


@ app.errorhandler(HTTPException)
def handle_exception(e):
    """Return JSON instead of HTML for HTTP errors."""
    # start with the correct headers and status code from the error
    response = e.get_response()
    # replace the body with JSON
    response.data = json.dumps({
        "code": e.code,
        "name": e.name,
        "description": e.description,
    })
    response.content_type = "application/json"
    return response


if __name__ == '__main__':
    app.run(debug=True, port=3000)
