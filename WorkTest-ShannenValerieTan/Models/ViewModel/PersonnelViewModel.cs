using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WorkTest_ShannenValerieTan.Models.ViewModel
{
    public class PersonnelViewModel
    {
        public Personnel personnels { get; set; }
        public class PersonnelViewModelDT
        {
            public int PersonnelId { get; set; }
            public string FullName { get; set; }
            public string ContactNumber { get; set; }
            public string EmailAddress { get; set; }
            public int CreatedAt { get; set; }
            public bool Active { get; set; }
            public string Add { get; set; }
        }
    }
}