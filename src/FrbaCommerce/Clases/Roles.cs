﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using FrbaCommerce.Common;
using System.Windows.Forms;
using System.Data;
using System.Data.SqlClient;

namespace FrbaCommerce.Clases
{
    class Roles
    {
        public static List<Rol> obtenerRoles()
        {
            List<Rol> roles = new List<Rol>();
            SqlDataReader lector = BDSQL.ejecutarReader("SELECT * FROM MERCADONEGRO.Roles", BDSQL.iniciarConexion());
            if (lector.HasRows)
            {
                while (lector.Read())
                {
                    Rol unRol = new Rol((int)(decimal)lector["ID_Rol"], (string)lector["Nombre"], (bool)lector["Habilitado"]);
                    roles.Add(unRol);
                }
            }
            BDSQL.cerrarConexion();
            return roles;
        }
        public static bool insertarNuevoRol(string nombre , List<Funcionalidad> lista)
        {
            try
            {
                List<SqlParameter> ListaParametros = new List<SqlParameter>();
                ListaParametros.Add(new SqlParameter("@nombreRol", nombre));
                SqlParameter paramRet = new SqlParameter("@ret", System.Data.SqlDbType.Decimal);
                paramRet.Direction = System.Data.ParameterDirection.Output;
                ListaParametros.Add(paramRet);

                //insert, devuelve ret = id rol insertado
                //TODO : Mega fino.. hacer que agregarRolNuevo haga primero select para ver si ya existe luego
                // el insert, como esta ahora NO inserta si ya existe, pero el identity suma +1 y queda "feo"
                // no afecta en nada, pero bueno, belleza. 
                // ej: inserta: id 4, nombre Rol1 SUCCES, inserta Rol1 de nuevo FAIL, no inserta, pero identity+1
                // inserta Rol22 SUCCES, pero queda id 6. 
                int ret = (int)BDSQL.ExecStoredProcedure("MERCADONEGRO.agregarRolNuevo", ListaParametros);
                BDSQL.cerrarConexion();

                if (ret != 0)
                {
                    foreach (Funcionalidad unaFunc in lista)
                    {
                        //insert FUNCIONALIDAD_ROL 
                        Funcionalidades.AgregarFuncionalidadEnRol(nombre, unaFunc);
                    }
                    return true;
                }
                else { return false; }
            }
            catch { return false; }
        }

        public static void updatearRol(string nombre, List<Funcionalidad> listaNuevasFunc, bool estaChecked, int idRol)
        {
            List<SqlParameter> ListaParametros = new List<SqlParameter>();
            ListaParametros.Add(new SqlParameter("@idRol", idRol));
            ListaParametros.Add(new SqlParameter("@nombreRol", nombre));
            ListaParametros.Add(new SqlParameter("@habilitado", estaChecked));

            int ret = BDSQL.ejecutarQuery("UPDATE MERCADONEGRO.Roles SET Nombre = @nombreRol, Habilitado = @habilitado WHERE ID_Rol = @idRol", ListaParametros,BDSQL.iniciarConexion());
            if (ret == -1)
                MessageBox.Show("Falló al actualizar el rol", "Fail!", MessageBoxButtons.OK, MessageBoxIcon.Error);
            BDSQL.cerrarConexion();
        }

        public static void deshabilitarRol(Rol unRol)
        {
            List<SqlParameter> parametros = new List<SqlParameter>();
            BDSQL.agregarParametro(parametros, "@idRol", unRol.ID_Rol);
            int resultado = BDSQL.ejecutarQuery("UPDATE MERCADONEGRO.Roles SET Habilitado = 0 WHERE ID_Rol = @idRol", parametros, BDSQL.iniciarConexion());

            if (resultado == -1)
                MessageBox.Show("Falló al actualizar el rol", "Fail!", MessageBoxButtons.OK, MessageBoxIcon.Error);
            BDSQL.cerrarConexion();
        }

        public static void eliminarUsuariosPorRol(Rol unRol)
        {
            List<SqlParameter> parametros = new List<SqlParameter>();
            BDSQL.agregarParametro(parametros, "@idRol", unRol.ID_Rol);
            int resultado = BDSQL.ejecutarQuery("DELETE FROM MERCADONEGRO.Roles_Usuarios WHERE ID_Rol = @idRol", parametros, BDSQL.iniciarConexion());

            if (resultado == -1)
                MessageBox.Show("Falló al eliminar Usuarios por Rol", "Fail!", MessageBoxButtons.OK, MessageBoxIcon.Error);
            BDSQL.cerrarConexion();
        }

    }
}
