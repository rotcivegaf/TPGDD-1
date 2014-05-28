﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using FrbaCommerce.Common;

namespace FrbaCommerce.Clases
{
    class ListadoMayorFact
    {
        public string username { get; set; }
        public float facturacionTotal { get; set; }
        public int anio { get; set; }
        public int mesMinimo { get; set; }
        public int mesMaximo { get; set; }

        public ListadoMayorFact(int trimestreMinimo, int anio)
        {
            this.anio = anio;
            this.mesMinimo = trimestreMinimo;
            this.mesMaximo = trimestreMinimo + 2;
        }

        public ListadoMayorFact(string username, float facturacionTotal)
        {
            this.username = username;
            this.facturacionTotal = facturacionTotal;
        }


        public DataTable obtenerListado()
        {
            List<SqlParameter> listaParametros = new List<SqlParameter>();
            BDSQL.agregarParametro(listaParametros, "@Año", this.anio);
            BDSQL.agregarParametro(listaParametros, "@mesMinimo", this.mesMinimo);
            BDSQL.agregarParametro(listaParametros, "@mesMaximo", this.mesMaximo);
            

            String commandtext = "SELECT TOP(5) Vendedor, SUM([Facturacion_Total]) AS [Facturacion Total] "+
	                                                            "FROM MERCADONEGRO.MayorFacturacionView "+
		                                                        "WHERE Mes BETWEEN @mesMinimo AND @mesMaximo AND Año = @año "+
			                                                    "GROUP BY Vendedor "+
				                                                "ORDER BY [Facturacion Total] DESC";

            return BDSQL.obtenerDataTable(commandtext, "T", listaParametros);
            
            /*SqlDataReader lectorListado = BDSQL.ejecutarReader("SELECT TOP(5) Vendedor, SUM([Facturacion_Total]) AS [Facturacion Total] "+
	                                                            "FROM MERCADONEGRO.MayorFacturacionView "+
		                                                        "WHERE Mes BETWEEN @mesMinimo AND @mesMaximo AND Año = @año "+
			                                                    "GROUP BY Vendedor "+
				                                                "ORDER BY [Facturacion Total] DESC", listaParametros, conexion);
            if (lectorListado.HasRows)
            {
                while (lectorListado.Read())
                {
                    ListadoMayorFact vendedor = new ListadoMayorFact(Convert.ToString(lectorListado["Vendedor"]),(float) Convert.ToInt32(lectorListado["Facturacion Total"]));
                    listado.Add(vendedor);
                }
            }
            BDSQL.cerrarConexion();
            return listado;*/
        }
        


    }
}
