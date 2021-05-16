import json
from utils import truncate


class JsonSerialize:
    # take the dictionnary and transform to json formatted string
    def to_json(self):
        return json.dumps(self.__dict__)

    # get the dictionnary
    def to_dict(self):
        return self.__dict__


class Materiel(JsonSerialize):
    def __init__(self, materielId, nom, description, marque, dureeLocation, coutLocation, coutRemplacement, taille, categorie_id, categorie_nom):
        JsonSerialize.__init__(self)
        self.materielId = materielId
        self.nom = nom
        self.description = description
        self.marque = marque
        self.dureeLocation = dureeLocation
        self.coutLocation = coutLocation
        self.coutRemplacement = coutRemplacement
        self.taille = taille
        self.categorie = Categorie(categorie_id, categorie_nom).to_dict()


class Inventaire(JsonSerialize):
    def __init__(self, id_materiel, nomMateriel, quantite=0):
        JsonSerialize.__init__(self)
        self.idMateriel = id_materiel
        self.nomMateriel = nomMateriel
        self.quantite = quantite


class Location(JsonSerialize):
    def __init__(self, location_id, date_location, inventaire_id, nom_materiel, nom_client, prenom_client):
        JsonSerialize.__init__(self)
        self.IdLocation = location_id
        # convert datetime object to string
        self.DateLocation = str(date_location)
        self.InventaireId = inventaire_id
        self.NomMateriel = truncate(nom_materiel, 25)
        self.NomClient = nom_client[0].upper() + '.' + prenom_client


class Categorie(JsonSerialize):
    def __init__(self, categorie_id, nom):
        JsonSerialize.__init__(self)
        self.Id = categorie_id
        self.Nom = nom


class Client(JsonSerialize):
    def __init__(self, client_id, nom, prenom):
        self.IdClient = client_id
        self.NomPrenom = nom + " " + prenom


class Adresse:
    pass


class Paiement:
    pass


class Magasin:
    pass

# https://pythonexamples.org/convert-python-class-object-to-json/
# convert object to dictionnary and json


# class Laptop:
#     detail = "good"

#     def __init__(self):
#         self.name = "my laptop"
#         self.processor = "amd"


# # # create object (Laptop object)
# laptop1 = Laptop()

# laptop1.name = 'Dell Alienware'
# laptop1.processor = 'Intel Core i7'

# print(type(laptop1.__dict__))  # dictionary: <class 'dict'>
# print(laptop1.__dict__)
# # {"name" : 'Dell Alienware' , "processor" : 'Intel Core i7'}

# # # convert to JSON string
# jsonStr = json.dumps(laptop1.__dict__, indent=2)

# # # print json string
# print(jsonStr)


# print(Laptop.__dict__)
# {'__module__': '__main__', 'detail': 'good', '__init__': <function Laptop.__init__ at 0x000001AE004C3160>, '__dict__': <attribute '__dict__' of 'Laptop' objects>, '__weakref__': <attribute '__weakref__' of 'Laptop' objects>, '__doc__': None}

# m = Materiel(1, "drdf", "ihi", " ihi ", 4, 23.46, 316.65, "Petit", 5, "sdvbn")
# print(m.__dict__)
# print(m.to_dict())
# {'materielId': 1, 'nom': 'drdf', 'description': 'ihi', 'marque': ' ihi ', 'dureeLocation': 4,
#  'coutLocation': 23.46, 'coutRemplacement': 316.65, 'taille': 'Petit',
#  'categorie': {'Id': 5, 'Nom': 'sdvbn'}}
