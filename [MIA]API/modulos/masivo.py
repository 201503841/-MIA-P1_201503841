def carga_masiva(conn, df, table):
    tmp_df = "./tmp_dataframe.csv"
    df.to_csv(tmp_df, header=False, index=False, sep=';')
    f = open(tmp_df, 'r')
    cursor = conn.cursor()
    try:
        cursor.execute(open("./scripts/cargar_temporal.sql", "r").read())
        conn.commit()
        cursor.copy_from(f, table, sep=";")
        conn.commit()
    except:
        pass
    cursor.close()


def carga_modelos(conn):
    cursor = conn.cursor()
    try:
        cursor.execute(open("./scripts/cargar_modelo.sql", "r").read())
        conn.commit()
    except:
        pass
    cursor.close()


def drop_modelo(conn):
    cursor = conn.cursor()
    try:
        cursor.execute(open("./scripts/eliminar_modelo.sql", "r").read())
        conn.commit()
    except:
        pass
    cursor.close()


def truncate_temporal(conn):
    cursor = conn.cursor()
    try:
        cursor.execute('truncate table temporal')
        conn.commit()
    except:
        pass
    cursor.close()
