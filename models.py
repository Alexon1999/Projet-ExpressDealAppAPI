import json


class JsonSerialize:
    # take the dictionnary and transform to json formatted string
    def to_json(self):
        return json.dumps(self.__dict__)

    # get the dictionnary
    def to_dict(self):
        return self.__dict__


class Materiel(JsonSerialize):
    def __init__(self, materielId, nom, description, marque, dureeLocation, coutLocation, coutRemplacement, taille):
        JsonSerialize.__init__(self)
        self.materielId = materielId
        self.nom = nom
        self.description = description
        self.marque = marque
        self.dureeLocation = dureeLocation
        self.coutLocation = coutLocation
        self.coutRemplacement = coutRemplacement
        self.taille = taille


class Inventaire(JsonSerialize):
    def __init__(self, id_materiel, nomMateriel, quantite):
        JsonSerialize.__init__(self)
        self.id = id_materiel
        self.nomMateriel = nomMateriel
        self.quantite = quantite


class Categorie(JsonSerialize):
    def __init__(self, categorie_id, nom):
        JsonSerialize.__init__(self)
        self.Id = categorie_id
        self.Nom = nom


class Adresse:
    pass


class Paiement:
    pass


class Client:
    pass


class location:
    pass


class magasin:
    pass

# https://pythonexamples.org/convert-python-class-object-to-json/
# convert object to dictionnary and json
# class Laptop:
#     def __init__(self):
#         self.name = "my laptop"
#         self.processor = "oll"


# # create object
# laptop1 = Laptop()

# # laptop1.name = 'Dell Alienware'
# # laptop1.processor = 'Intel Core i7'

# # convert to JSON string
# # laptop1.__dict__ ->  dictionnary {"name" : 'Dell Alienware' , "processor" : 'Intel Core i7'}
# jsonStr = json.dumps(laptop1.__dict__, indent=2)

# # print json string
# print(jsonStr)
