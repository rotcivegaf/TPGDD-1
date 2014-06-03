﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using FrbaCommerce.Common;

namespace FrbaCommerce.Historial_Cliente
{
    public partial class Historial : Form
    {
        public Login.SeleccionFuncionalidades formAnterior { get; set; }
        public SqlConnection conexion { get; set; }

        public List<Clases.Compra> compras = new List<Clases.Compra>();
        public List<Clases.Compra> ofertasGanadas = new List<Clases.Compra>();
        public List<Clases.Oferta> ofertas = new List<Clases.Oferta>();

        public Historial(Login.SeleccionFuncionalidades formAnt)
        {
            this.formAnterior = formAnt;

            InitializeComponent();

            obtenerCompras();
            obtenerOfertasGanadas();
            obtenerOfertas();

            dgCompras.DataSource = compras;
            dgOfertas.DataSource = ofertas;
            dgSubastasGanadas.DataSource = ofertasGanadas;

            dgCompras.AutoSizeRowsMode = DataGridViewAutoSizeRowsMode.AllCells;
            dgOfertas.AutoSizeRowsMode = DataGridViewAutoSizeRowsMode.AllCells;
            dgSubastasGanadas.AutoSizeRowsMode = DataGridViewAutoSizeRowsMode.AllCells;

            dgCompras.RowHeadersVisible = false;
            dgOfertas.RowHeadersVisible = false;
            dgSubastasGanadas.RowHeadersVisible = false;

            DataGridViewColumn compras_cVendedor = dgCompras.Columns[0];
            DataGridViewColumn compras_cPublicacion = dgCompras.Columns[1];
            DataGridViewColumn compras_cFecha = dgCompras.Columns[2];
            DataGridViewColumn compras_cCalificacion = dgCompras.Columns[3];
            DataGridViewColumn compras_cComentarios = dgCompras.Columns[4];

            DataGridViewColumn ofertasGanadas_cVendedor = dgSubastasGanadas.Columns[0];
            DataGridViewColumn ofertasGanadas_cPublicacion = dgSubastasGanadas.Columns[1];
            DataGridViewColumn ofertasGanadas_cFecha = dgSubastasGanadas.Columns[2];
            DataGridViewColumn ofertasGanadas_cCalificacion = dgSubastasGanadas.Columns[3];
            DataGridViewColumn ofertasGanadas_cComentarios = dgSubastasGanadas.Columns[4];

            DataGridViewColumn ofertas_cVendedor = dgOfertas.Columns[0];
            DataGridViewColumn ofertas_cPublicacion = dgOfertas.Columns[1];
            DataGridViewColumn ofertas_cFecha = dgOfertas.Columns[2];
            DataGridViewColumn ofertas_cMonto = dgOfertas.Columns[3];

            DataGridViewColumn compras_cConexion = dgCompras.Columns[5];
            DataGridViewColumn ofertasGanadas_cConexion = dgSubastasGanadas.Columns[5];
            DataGridViewColumn ofertas_cConexion = dgOfertas.Columns[4];

            compras_cConexion.Visible = false;
            ofertasGanadas_cConexion.Visible = false;
            ofertas_cConexion.Visible = false;

            ofertas_cVendedor.Resizable = DataGridViewTriState.False;
            ofertas_cPublicacion.Resizable = DataGridViewTriState.False;
            ofertas_cFecha.Resizable = DataGridViewTriState.False;
            ofertas_cMonto.Resizable = DataGridViewTriState.False;

            compras_cVendedor.Resizable = DataGridViewTriState.False;
            compras_cPublicacion.Resizable = DataGridViewTriState.False;
            compras_cFecha.Resizable = DataGridViewTriState.False;
            compras_cCalificacion.Resizable = DataGridViewTriState.False;
            compras_cComentarios.Resizable = DataGridViewTriState.False;

            ofertasGanadas_cVendedor.Resizable = DataGridViewTriState.False;
            ofertasGanadas_cPublicacion.Resizable = DataGridViewTriState.False;
            ofertasGanadas_cFecha.Resizable = DataGridViewTriState.False;
            ofertasGanadas_cCalificacion.Resizable = DataGridViewTriState.False;
            ofertasGanadas_cComentarios.Resizable = DataGridViewTriState.False;

            compras_cVendedor.DefaultCellStyle.WrapMode = DataGridViewTriState.True;
            compras_cPublicacion.DefaultCellStyle.WrapMode = DataGridViewTriState.True;
            compras_cFecha.DefaultCellStyle.WrapMode = DataGridViewTriState.True;
            compras_cCalificacion.DefaultCellStyle.WrapMode = DataGridViewTriState.True;
            compras_cComentarios.DefaultCellStyle.WrapMode = DataGridViewTriState.True;

            ofertasGanadas_cVendedor.DefaultCellStyle.WrapMode = DataGridViewTriState.True;
            ofertasGanadas_cPublicacion.DefaultCellStyle.WrapMode = DataGridViewTriState.True;
            ofertasGanadas_cFecha.DefaultCellStyle.WrapMode = DataGridViewTriState.True;
            ofertasGanadas_cCalificacion.DefaultCellStyle.WrapMode = DataGridViewTriState.True;
            ofertasGanadas_cComentarios.DefaultCellStyle.WrapMode = DataGridViewTriState.True;

            ofertas_cVendedor.DefaultCellStyle.WrapMode = DataGridViewTriState.True;
            ofertas_cPublicacion.DefaultCellStyle.WrapMode = DataGridViewTriState.True;
            ofertas_cFecha.DefaultCellStyle.WrapMode = DataGridViewTriState.True;
            ofertas_cMonto.DefaultCellStyle.WrapMode = DataGridViewTriState.True;

            compras_cVendedor.Width = 110;
            compras_cPublicacion.Width = 195;
            compras_cFecha.Width = 70;
            compras_cCalificacion.Width = 70;
            compras_cComentarios.Width = 165;

            ofertasGanadas_cVendedor.Width = compras_cVendedor.Width;
            ofertasGanadas_cPublicacion.Width = compras_cPublicacion.Width;
            ofertasGanadas_cFecha.Width = compras_cFecha.Width;
            ofertasGanadas_cCalificacion.Width = compras_cCalificacion.Width;
            ofertasGanadas_cComentarios.Width = compras_cComentarios.Width;

            ofertas_cVendedor.Width = 110;
            ofertas_cPublicacion.Width = 265;
            ofertas_cFecha.Width = 125;
            ofertas_cMonto.Width = 110;
        }

        public Clases.Calificacion obtenerCalificacion(int codCalificacion)
        {
            List<SqlParameter> listaParametros = new List<SqlParameter>();
            BDSQL.agregarParametro(listaParametros, "@Cod_Calificacion", codCalificacion);
            SqlDataReader lector = BDSQL.ejecutarReader("SELECT * FROM MERCADONEGRO.Calificaciones WHERE Cod_Calificacion = @Cod_Calificacion", listaParametros, this.conexion);
            lector.Read();
            Clases.Calificacion calificacion = new Clases.Calificacion(Convert.ToInt32(lector["Puntaje"]), Convert.ToString(lector["Descripcion"]));
            return calificacion;
        }

        public int obtenerOfertasGanadas()
        {
            int cont = 0;
            List<SqlParameter> listaParametros = new List<SqlParameter>();
            BDSQL.agregarParametro(listaParametros, "@ID_User", Interfaz.usuario.ID_User);
            this.conexion = BDSQL.iniciarConexion();
            SqlDataReader lector = BDSQL.ejecutarReader("EXEC MERCADONEGRO.obtenerOfertasGanadas @ID_User", listaParametros, this.conexion);
            if (lector.HasRows)
            {
                while (lector.Read())
                {
                    cont++;
                    int idVendedor = Convert.ToInt32(lector["ID_Vendedor"]);
                    int codPublicacion = Convert.ToInt32(lector["Cod_Publicacion"]);
                    Clases.Calificacion calificacion;

                    if (lector["Cod_Calificacion"] != DBNull.Value)
                    {
                        calificacion = obtenerCalificacion(Convert.ToInt32(lector["Cod_Calificacion"]));
                    }
                    else
                    {
                        calificacion = null;
                    }

                    DateTime fechaOperacion = Convert.ToDateTime(lector["Fecha_Operacion"].ToString());
                    Clases.Compra ofertaGanada = new Clases.Compra(idVendedor, codPublicacion, calificacion, fechaOperacion, this.conexion);
                    ofertasGanadas.Add(ofertaGanada);
                }
            }
            BDSQL.cerrarConexion();
            return cont;
        }

        public int obtenerCompras()
        {
            int cont = 0;
            List<SqlParameter> listaParametros = new List<SqlParameter>();
            BDSQL.agregarParametro(listaParametros, "@ID_User", Interfaz.usuario.ID_User);
            this.conexion = BDSQL.iniciarConexion();
            SqlDataReader lector = BDSQL.ejecutarReader("EXEC MERCADONEGRO.obtenerCompras @ID_User", listaParametros, conexion);
            if (lector.HasRows)
            {
                while (lector.Read())
                {
                    cont++;
                    int idVendedor = Convert.ToInt32(lector["ID_Vendedor"]);
                    int codPublicacion = Convert.ToInt32(lector["Cod_Publicacion"]);
                    Clases.Calificacion calificacion;

                    if (lector["Cod_Calificacion"] != DBNull.Value)
                    {
                        calificacion = obtenerCalificacion(Convert.ToInt32(lector["Cod_Calificacion"]));
                    }
                    else
                    {
                        calificacion = null;
                    }
                    
                    DateTime fechaOperacion = Convert.ToDateTime(lector["Fecha_Operacion"].ToString());
                    Clases.Compra compra = new Clases.Compra(idVendedor, codPublicacion, calificacion, fechaOperacion, this.conexion);
                    compras.Add(compra);
                }
            }
            BDSQL.cerrarConexion();
            return cont;
        }

        public int obtenerOfertas()
        {
            int cont = 0;
            List<SqlParameter> listaParametros = new List<SqlParameter>();
            BDSQL.agregarParametro(listaParametros, "@ID_User", Interfaz.usuario.ID_User);
            this.conexion = BDSQL.iniciarConexion();
            SqlDataReader lector = BDSQL.ejecutarReader("EXEC MERCADONEGRO.obtenerOfertas @ID_User", listaParametros, this.conexion);
            if (lector.HasRows)
            {
                while (lector.Read())
                {
                    cont++;
                    int idVendedor = Convert.ToInt32(lector["ID_Vendedor"]);
                    int codPublicacion = Convert.ToInt32(lector["Cod_Publicacion"]);
                    DateTime fechaOferta = Convert.ToDateTime(lector["Fecha_Oferta"].ToString());
                    int monto = Convert.ToInt32(lector["Monto_Oferta"]);
                    Clases.Oferta oferta = new Clases.Oferta(idVendedor, codPublicacion, fechaOferta, monto, this.conexion);
                    ofertas.Add(oferta);
                }
            }
            BDSQL.cerrarConexion();
            return cont;
        }

        private void Historial_Load(object sender, EventArgs e)
        {

        }

        private void dgCompras_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }

        private void volver_Click(object sender, EventArgs e)
        {
            this.Hide();
            this.formAnterior.Show();
        }
    }
}
