from flaskext.mysql import MySQL


def connect_to_mysql_database(app,  db_host, db_user, db_name, db_password, db_port=3306, **kwargs):
    mysql = MySQL(**kwargs)

    # MySQL configurations
    app.config['MYSQL_DATABASE_USER'] = db_user
    app.config['MYSQL_DATABASE_PASSWORD'] = db_password
    app.config['MYSQL_DATABASE_DB'] = db_name
    app.config['MYSQL_DATABASE_HOST'] = db_host
    app.config['MYSQL_DATABASE_PORT'] = db_port

    mysql.init_app(app)

    # return Connection object
    return mysql.connect()


def truncate(string, length):
    return string[0:length] + '...'


def insert_item():
    pass


def delete_item():
    pass


def update_item():
    pass
