﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using FrbaCommerce.Common;
using FrbaCommerce.Clases;
using System.Data.SqlClient;

namespace FrbaCommerce.Clases
{
    public class Calificacion
    {
        public int Cod_Calificacion { get; set; }
        public int? Puntaje { get; set; }
        public string Descripcion { get; set; }
        public DateTime? Fecha_Calificacion { get; set; }

        public Calificacion(int? punt, string desc)
        {
            
            Puntaje = punt;
            Descripcion = desc;
        }
        
        public Calificacion(int cod, int? punt, string desc, DateTime? fecha)
        {
            Cod_Calificacion = cod;
            Puntaje = punt;
            Descripcion = desc;
            Fecha_Calificacion = fecha;
        }


        public static List<Calificacion> obtenerCalificaciones(int idUser)
        {
            List<Calificacion> calificaciones = new List<Calificacion>();
            List<SqlParameter> ListaParametros = new List<SqlParameter>();
            ListaParametros.Add(new SqlParameter("@idUser", idUser));

            SqlDataReader lector = BDSQL.ejecutarReader("SELECT c.Cod_Calificacion, c.Puntaje, c.Descripcion, c.Fecha_Calificacion " +
                                                        "FROM MERCADONEGRO.Calificaciones c " +
                                                        "JOIN MERCADONEGRO.Operaciones o ON o.Cod_Calificacion = c.Cod_Calificacion "+
                                                        "WHERE o.ID_Comprador = @idUser", ListaParametros, BDSQL.iniciarConexion());
            if (lector.HasRows)
            {
                while (lector.Read())
                {
                    int? puntaje;
                    string desc;
                    DateTime? fecha;

                    if (Convert.IsDBNull(lector["Puntaje"]))
                    {
                        puntaje = null;
                    }
                    else puntaje = (int)(decimal)lector["Puntaje"];

                    if (Convert.IsDBNull(lector["Descripcion"]))
                    {
                        desc = "";
                    }
                    else desc = (string)lector["Puntaje"];

                    if (Convert.IsDBNull(lector["Fecha_Calificacion"]))
                    {
                        fecha = null;
                    }
                    else fecha = (DateTime)lector["Fecha_Calificacion"];
                    
                    

                    Calificacion unaCalificacion = new Calificacion((int)(decimal)lector["Cod_Calificacion"],
                                                                    puntaje,
                                                                    desc, 
                                                                    fecha);
                    calificaciones.Add(unaCalificacion);
                }
            }
            BDSQL.cerrarConexion();
            return calificaciones;
        }
    }
}
