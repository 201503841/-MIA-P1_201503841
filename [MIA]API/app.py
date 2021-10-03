import simplejson as json
import pandas as pd
from flask import Flask
from flask_cors import CORS
import psycopg2

from modulos.masivo import carga_masiva, carga_modelos, drop_modelo, truncate_temporal
from modulos.consultas import primera_consulta, segunda_consulta, tercera_consulta, \
    cuarta_consulta, quinta_consulta, sexta_consulta, septima_consulta, octava_consulta, \
    novena_consulta, decima_consulta

param_dic = {
    "host": "localhost",
    "database": "blockbuster",
    "user": "postgres",
    "password": "Suseth29"
}


def connect(params_dic):
    conn = None
    try:
        print('Connecting to the PostgreSQL database...')
        conn = psycopg2.connect(**params_dic)
        conn.set_session(autocommit=True)
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    print("Connection successful")
    return conn


conn = connect(param_dic)

df = pd.read_csv('BlockbusterData.csv', encoding='ISO-8859-1',
                 sep=';', engine="python")

cols = ["MONTO_A_PAGAR", "DIAS_RENTA",
        "COSTO_RENTA", "DURACION", "COSTO_POR_DANIO"]
for c in cols:
    df[c].replace(
        to_replace=['-'],
        value=0,
        inplace=True
    )

df.replace(
    to_replace=['-'],
    value='',
    inplace=True
)

app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": "*"}})


@app.route('/')
def hello_world():
    return {'status': 'hello world'}


@app.route('/cargarTemporal')
def cargar_temporal():
    carga_masiva(conn, df, 'temporal')
    return {'status': True}


@app.route('/cargarModelo')
def cargar_modelos():
    carga_modelos(conn)
    return {'status': True}


@app.route('/eliminarModelo')
def eliminar_modelo():
    drop_modelo(conn)
    return {'status': True}


@app.route('/eliminarTemporal')
def eliminar_temporal():
    truncate_temporal(conn)
    return {'status': True}


@app.route('/consulta1')
def consulta1():
    respuesta = primera_consulta(conn)
    return {'respuesta': json.loads(json.dumps(respuesta))}


@app.route('/consulta2')
def consulta2():
    respuesta = segunda_consulta(conn)
    return {'respuesta': json.loads(json.dumps(respuesta))}


@app.route('/consulta3')
def consulta3():
    respuesta = tercera_consulta(conn)
    return {'respuesta': json.loads(json.dumps(respuesta))}


@app.route('/consulta4')
def consulta4():
    respuesta = cuarta_consulta(conn)
    return {'respuesta': json.loads(json.dumps(respuesta))}


@app.route('/consulta5')
def consulta5():
    respuesta = quinta_consulta(conn)
    return {'respuesta': json.loads(json.dumps(respuesta))}


@app.route('/consulta6')
def consulta6():
    respuesta = sexta_consulta(conn)
    return {'respuesta': json.loads(json.dumps(respuesta))}


@app.route('/consulta7')
def consulta7():
    respuesta = septima_consulta(conn)
    return {'respuesta': json.loads(json.dumps(respuesta))}


@app.route('/consulta8')
def consulta8():
    respuesta = octava_consulta(conn)
    return {'respuesta': json.loads(json.dumps(respuesta))}


@app.route('/consulta9')
def consulta9():
    respuesta = novena_consulta(conn)
    return {'respuesta': json.loads(json.dumps(respuesta))}


@app.route('/consulta10')
def consulta10():
    respuesta = decima_consulta(conn)
    return {'respuesta': json.loads(json.dumps(respuesta))}


if __name__ == '__main__':
    app.run(host="localhost", port=3000, debug=False)
