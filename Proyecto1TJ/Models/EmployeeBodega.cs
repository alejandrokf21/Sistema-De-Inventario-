//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace Proyecto1TJ.Models
{
    using System;
    using System.Collections.Generic;
    
    public partial class EmployeeBodega
    {
        public int id { get; set; }
        public Nullable<int> idUsuario { get; set; }
        public Nullable<int> idBodega { get; set; }
    
        public virtual DataBodega DataBodega { get; set; }
        public virtual Usuarios Usuarios { get; set; }
    }
}