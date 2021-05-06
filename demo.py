import json
from flaskext.mysql import MySQL
from flask import Flask, render_template, request, Response, jsonify
# doc : https://flask-mysql.readthedocs.io/en/latest

'''
    tuto : https://code.tutsplus.com/tutorials/creating-a-web-app-from-scratch-using-python-flask-and-mysql--cms-22972

'''

# create the Flask app (créer un objet Flask)
app = Flask(__name__)
# import_name : The name of the package or module that this app belongs to

mysql = MySQL(autocommit=True)
# autocommit : appliquer les changement comme insert,update,delete

# MySQL configurations
app.config['MYSQL_DATABASE_USER'] = 'root'
app.config['MYSQL_DATABASE_PASSWORD'] = ''
app.config['MYSQL_DATABASE_DB'] = 'sakila'
app.config['MYSQL_DATABASE_HOST'] = 'localhost'
app.config['MYSQL_DATABASE_PORT'] = 3309
mysql.init_app(app)

# get the database connexion object
cnx = mysql.connect()


@app.route('/<id_user>', methods=['GET', 'POST'])
def demo(id_user):
    # request params
    print(id_user)
    return id_user


@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == "POST":
        # form data
        # request.form.get('nom') # nom c'est par exemple le nom d'un input

        print(request.data)

        # body json ( Content-Type = "application/json" )
        data = request.get_json()  # returns None or the converted json to python
        print(request.json)  # returns None or the converted json to python
        print(data)
        if data:
            print(data.get('username'))
            return Response(json.dumps(data), mimetype='application/json', status=200)

        return "success"

    # querry strings :  /exapmle?id=1&age=5&name=john
    print(request.args, request.args.get('id'))
    print(request.json)

    # obtain a cursor
    # cursor = mysql.get_db().cursor()
    cursor = cnx.cursor()
    print(dir(cursor))

    # execute : query , return: Number of affected rows

    cursor.execute("select * from rental")
    # INSERT INTO category values() : je dois passer id , nom et last update ,  c'est mieux de spécifier le column car id est auto increment et last update a un valeur par défaut
    cursor.execute(
        "INSERT INTO category( name) values(%s )", ("ihi", ))
    # "INSERT INTO category(category_id , name) values(%s , %s)", (89, "ihi"))

    # multiline string ,
    query = """UPDATE category 
                set name=%s , category_id=200
                where category_id = %s
            """
    tup1 = ("alexon", 100)
    cursor.execute(query, tup1)

    delete_query = """DELETE FROM category where name = %s"""
    tup2 = ("ihi", )
    cursor.execute(delete_query, tup2)

    # apply the changes
    # cursor.connection.commit()
    # cnx.commit() # don't need , if we put autocommit=True

    # each row is a tuple
    # + -> fetchone() : first row
    # + -> fetchall() : all the rows (tuple inside tuples)

    # ? insert,update,delet returns no row , samething for select, functions/procedures , if there are no row
    # so fetchone() -> None
    # fetchall() -> () empty tuple

    # data = cursor.fetchone()
    # print(data)  # tuple
    data = cursor.fetchall()
    print(type(data))  # tuple
    print(data)

    # Procédures
    # en sql : CALL film_in_stock(1,1,@count); après SELECT @count;
    # passer 3 arguments , 3ème paramètre est un OUT value (on peut mettre n'importe mais pas pour INOUT values),
    cursor.callproc('film_in_stock', (1, 1, 0))
    # print(cursor.fetchall())  # ((1,), (2,), (3,), (4,))
    print(cursor.fetchone())  # (1,)
    # 2 : est la position de la paremtre (index à 0)
    cursor.execute('SELECT @_film_in_stock_2')
    print(cursor.fetchall())  # ((4,),)
    # print(cursor.fetchone())  # (4,)

    cursor.execute('CALL test()')
    # print(cursor.fetchall())  # (('yes',),)
    print(cursor.fetchone())  # ('yes',)

    cursor.execute('CALL film_in_stock(%s , %s , @count)', (1, 1))
    cursor.execute('select @count')
    print(cursor.fetchone())  # (4,)

    # Fonctions
    cursor.execute('select inventory_in_stock(10)')  # call a function
    print(cursor.fetchone())  # (0,)
    # print(cursor.fetchall())  # ((0,),)

    cursor.close()

    return 'ok'


if __name__ == '__main__':
    app.run(debug=True)  # par defaut le port c'est 5000
