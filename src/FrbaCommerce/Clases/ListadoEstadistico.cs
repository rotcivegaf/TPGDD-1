﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using FrbaCommerce.Common;
using System.Data.SqlClient;
using System.Data;

namespace FrbaCommerce.Clases
{
    class ListadoEstadistico
    {
        public int anio { get; set; }
        public int trimestre { get; set; }
       

        public ListadoEstadistico(int trimestre, int anio){
            this.trimestre = this.obtenerRangoTrimestre(trimestre);
            this.anio = anio;
          
        }

        private int obtenerRangoTrimestre(int trimestre)
        {
            int rangoMinimo;

            switch (trimestre)
            {
                case 1:
                    rangoMinimo = 1;
                    break;
                case 2:
                    rangoMinimo = 4;
                    break;
                case 3:
                    rangoMinimo = 7;
                    break;
                default:
                    rangoMinimo = 10;
                    break;
            }


            return rangoMinimo;
        }

        public DataTable buscar(int opcionElegida)
        {
            if (opcionElegida == 2)
            {
                ListadoMayorFact listadoFacturacion = new ListadoMayorFact(trimestre, anio);
                return listadoFacturacion.obtenerListado();
            }
            else if (opcionElegida == 3)
            {
                ListadoMayorCalific listadoCalificacion = new ListadoMayorCalific(trimestre, anio);
                return listadoCalificacion.obtenerListado();
            }
            else return null;
           
        }


    }
}
