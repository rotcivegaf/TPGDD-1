﻿namespace FrbaCommerce.Comprar_Ofertar
{
    partial class OfertaDlg
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.txtAceptar = new System.Windows.Forms.Button();
            this.btnCancelar = new System.Windows.Forms.Button();
            this.lblOfertaActual = new System.Windows.Forms.Label();
            this.lblOferta = new System.Windows.Forms.Label();
            this.txtOfertaActual = new System.Windows.Forms.TextBox();
            this.txtOferta = new System.Windows.Forms.TextBox();
            this.btnBorrar = new System.Windows.Forms.Button();
            this.groupBox1.SuspendLayout();
            this.SuspendLayout();
            // 
            // groupBox1
            // 
            this.groupBox1.Controls.Add(this.btnBorrar);
            this.groupBox1.Controls.Add(this.txtOferta);
            this.groupBox1.Controls.Add(this.txtOfertaActual);
            this.groupBox1.Controls.Add(this.lblOferta);
            this.groupBox1.Controls.Add(this.lblOfertaActual);
            this.groupBox1.Location = new System.Drawing.Point(12, 12);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new System.Drawing.Size(268, 107);
            this.groupBox1.TabIndex = 0;
            this.groupBox1.TabStop = false;
            this.groupBox1.Text = "Ingrese una oferta entera mayor a la actual";
            // 
            // txtAceptar
            // 
            this.txtAceptar.Location = new System.Drawing.Point(205, 125);
            this.txtAceptar.Name = "txtAceptar";
            this.txtAceptar.Size = new System.Drawing.Size(75, 23);
            this.txtAceptar.TabIndex = 0;
            this.txtAceptar.Text = "Aceptar";
            this.txtAceptar.UseVisualStyleBackColor = true;
            this.txtAceptar.Click += new System.EventHandler(this.txtAceptar_Click);
            // 
            // btnCancelar
            // 
            this.btnCancelar.DialogResult = System.Windows.Forms.DialogResult.Cancel;
            this.btnCancelar.Location = new System.Drawing.Point(124, 125);
            this.btnCancelar.Name = "btnCancelar";
            this.btnCancelar.Size = new System.Drawing.Size(75, 23);
            this.btnCancelar.TabIndex = 1;
            this.btnCancelar.Text = "Cancelar";
            this.btnCancelar.UseVisualStyleBackColor = true;
            // 
            // lblOfertaActual
            // 
            this.lblOfertaActual.AutoSize = true;
            this.lblOfertaActual.Location = new System.Drawing.Point(6, 34);
            this.lblOfertaActual.Name = "lblOfertaActual";
            this.lblOfertaActual.Size = new System.Drawing.Size(71, 13);
            this.lblOfertaActual.TabIndex = 2;
            this.lblOfertaActual.Text = "Oferta actual:";
            // 
            // lblOferta
            // 
            this.lblOferta.AutoSize = true;
            this.lblOferta.Location = new System.Drawing.Point(6, 62);
            this.lblOferta.Name = "lblOferta";
            this.lblOferta.Size = new System.Drawing.Size(39, 13);
            this.lblOferta.TabIndex = 3;
            this.lblOferta.Text = "Oferta:";
            // 
            // txtOfertaActual
            // 
            this.txtOfertaActual.Location = new System.Drawing.Point(87, 31);
            this.txtOfertaActual.Name = "txtOfertaActual";
            this.txtOfertaActual.ReadOnly = true;
            this.txtOfertaActual.Size = new System.Drawing.Size(100, 20);
            this.txtOfertaActual.TabIndex = 4;
            // 
            // txtOferta
            // 
            this.txtOferta.Location = new System.Drawing.Point(87, 59);
            this.txtOferta.Name = "txtOferta";
            this.txtOferta.Size = new System.Drawing.Size(100, 20);
            this.txtOferta.TabIndex = 5;
            // 
            // btnBorrar
            // 
            this.btnBorrar.Location = new System.Drawing.Point(193, 57);
            this.btnBorrar.Name = "btnBorrar";
            this.btnBorrar.Size = new System.Drawing.Size(48, 23);
            this.btnBorrar.TabIndex = 2;
            this.btnBorrar.Text = "Borrar";
            this.btnBorrar.UseVisualStyleBackColor = true;
            this.btnBorrar.Click += new System.EventHandler(this.btnBorrar_Click);
            // 
            // ofertaDlg
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(290, 158);
            this.Controls.Add(this.btnCancelar);
            this.Controls.Add(this.txtAceptar);
            this.Controls.Add(this.groupBox1);
            this.Name = "ofertaDlg";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "ofertaDlg";
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.TextBox txtOferta;
        private System.Windows.Forms.TextBox txtOfertaActual;
        private System.Windows.Forms.Label lblOferta;
        private System.Windows.Forms.Label lblOfertaActual;
        private System.Windows.Forms.Button txtAceptar;
        private System.Windows.Forms.Button btnCancelar;
        private System.Windows.Forms.Button btnBorrar;
    }
}