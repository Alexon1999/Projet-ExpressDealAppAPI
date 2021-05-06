# <center>**Express Deal Api**</center>

#### Cette api est fait avec **Flask** (python web framework)

#### version de python utilisé: **3.9.0**

<br>

## **Etapes à suivre**

- ### Il est conseillé d'utiliser un environement virtuel pour les projet python . Dans votre terminal vous Dans le même dossier que app.py
- ### Créer un environnement virtuel `python -m venv env`

- ### Activez votre environnement

  ```
    - pour activer
   mac: source env/scripts/activate
   windows: env/Scripts/Activate.ps1

   - pour desactiver
   deactivate
  ```

- ### Installez les packages et modules dans votre environnement virtuel `pip install -r requirements.txt`

- ### Importez express_deal.sql dans votre serveur MySql

- ### Modifiez vos informations concernant la base de données dans le fichier `.env`

- ### pour terminer `python app.py`

<br>
<br>

### Pour tester l'API, utilisez **Postman** (Http client)

### Vous pouvez importer la collection

### lien de la colllection : https://www.getpostman.com/collections/f405ac7cc581fba81eec

<br>
<br>

### **make your local webserver public without deploy**

```
tunnelto.dev : https://tunnelto.dev/#download
tunnelto --port 3000 --subdomain express_deal_api

ngrok http 3000
ngrok : https://ngrok.com/

```
