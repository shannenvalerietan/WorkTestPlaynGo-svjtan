using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using WorkTest.ViewModel.DataTable;
using WorkTest_ShannenValerieTan.Models;
using WorkTest_ShannenValerieTan.Models.ViewModel;

namespace WorkTest_ShannenValerieTan.Controllers
{
    public class PersonnelController : Controller
    {
        WorkTestEntities dbContext = new WorkTestEntities();
        public static int GetUnixTime()
        {
            var unix = (int)(DateTime.UtcNow.Subtract(new DateTime(1970, 1, 1))).TotalSeconds;
            return unix;
        }
        public ActionResult Dashboard()
        {
            return View();
        }
        public ActionResult Index(PersonnelViewModel reference)
        {
            ViewBag.PageTitle = "Personnels";
            return View();
        }
        public JsonResult PersonnelsList(JQueryDataTablesModel param)
        {
            var personnelList = (from p in dbContext.Personnels
                             select new PersonnelViewModel.PersonnelViewModelDT
                             {
                                 PersonnelId = p.PersonnelId,
                                 FullName = p.Surname + ", " + p.FirstName + " " + (p.ExtensionName == null ? "" : p.ExtensionName) + " " + (p.MiddleName == null ? "" : p.MiddleName),
                                 ContactNumber = p.ContactNumber,
                                 EmailAddress = p.EmailAddress,
                                 Active = p.Active,
                                 Add = p.Active == true ? "<i class='fa fa-minus'></i>" + "Disable" : "<i class='fa fa-undo'></i>" + "Enable"
                             }).ToList();

            IEnumerable<PersonnelViewModel.PersonnelViewModelDT> filteredData;
            string searchKey = !string.IsNullOrEmpty(param.sSearch) ? param.sSearch.ToUpper() : string.Empty;
            if (!string.IsNullOrEmpty(param.sSearch))
            {
                filteredData = personnelList.Where(o => o.FullName.ToUpper().Contains(searchKey) || o.ContactNumber.ToUpper().Contains(searchKey) || o.EmailAddress.ToUpper().Contains(searchKey));
            }
            else
            {
                filteredData = personnelList;
            }
            var result = (from f in filteredData select f)
                       .Skip(param.iDisplayStart)
                       .Take(param.iDisplayLength).ToArray();

            var isTaskIDSortable = Convert.ToBoolean(Request["bSortable_0"]);
            var isTaskNameSortable = Convert.ToBoolean(Request["bSortable_1"]);
            var isTaskRoleSortable = Convert.ToBoolean(Request["bSortable_2"]);
            var isTaskEnableSortable = Convert.ToBoolean(Request["bSortable_3"]);
            var sortColumnIndex = Convert.ToInt32(Request["iSortCol_0"]);

            Func<PersonnelViewModel.PersonnelViewModelDT, dynamic> orderingFunction;
            if (sortColumnIndex == 0)
            {
                orderingFunction = (uvm => (sortColumnIndex == 0 && isTaskIDSortable) ? uvm.PersonnelId : 0);
            }
            else
            {
                orderingFunction = (uvm => (sortColumnIndex == 1 && isTaskNameSortable) ? uvm.FullName :
                                            sortColumnIndex == 2 && isTaskRoleSortable ? uvm.FullName :
                                            sortColumnIndex == 3 && isTaskEnableSortable ? uvm.FullName : "");
            }

            var sortDirection = Request["sSortDir_0"]; // asc or desc
            if (sortDirection == "asc")
                filteredData = filteredData.OrderBy(orderingFunction);
            else
                filteredData = filteredData.OrderByDescending(orderingFunction);

            var displayedTasks = filteredData.Skip(param.iDisplayStart).Take(param.iDisplayLength);
            result = (from f in filteredData select f)
                       .Skip(param.iDisplayStart)
                       .Take(param.iDisplayLength).ToArray();

            List<dynamic[]> data = new List<dynamic[]>();
            foreach (var item in result)
            {
                data.Add(new dynamic[] {
                     item.Active == false ? "<i class='fa fa-check-circle-o'></i> " + " " + item.PersonnelId : "<i class='fa fa-check-circle-o text-success'></i> " + " " + item.PersonnelId,
                     item.FullName,
                     item.ContactNumber,
                     item.EmailAddress,
                     @"
                        <center>
                            <div class='btn-group' style='display:none;'>
                                  <button type = 'button' class='btn dropdown-toggle btn-default btn-sm fa fa-bars' data-toggle='dropdown' aria-haspopup='true' aria-expanded='false'></button>
                                  <ul class='dropdown-menu'>
                                      <li><a href='" + Url.Action("PersonnelActiveStatus", "Personnel", new { id = item.PersonnelId, actionStatus = item.Active }) + @"'>"
                                        + item.Add + @"</a></li>
                                  </ul>
                            </div>
                        </center>"

                });
            }

            return Json(new
            {
                sEcho = param.sEcho,
                iTotalRecords = personnelList.Count(),
                iTotalDisplayRecords = filteredData.Count(),
                iSortingCols = personnelList,
                aaData = data
            }, JsonRequestBehavior.AllowGet);
        }

        public ActionResult PersonnelCreate(PersonnelViewModel pTable)
        {
            pTable.personnels.CreatedAt = GetUnixTime();
            pTable.personnels.Active = true;
            dbContext.Personnels.Add(pTable.personnels);
            dbContext.SaveChanges();

            return RedirectToAction("Index");
        }
        public ActionResult PersonnelActiveStatus(int id, bool actionStatus)
        {
            var modelPersonnels = dbContext.Personnels.Find(id);
            if (actionStatus == false)
            {
                try
                {
                    modelPersonnels.Active = true;
                    dbContext.SaveChanges();
                    return RedirectToAction("Index");
                }
                catch
                {
                    return RedirectToAction("Index");
                }
            }
            else
            {
                try
                {
                    modelPersonnels.Active = false;
                    dbContext.SaveChanges();
                    return RedirectToAction("Index");
                }
                catch
                {
                    return RedirectToAction("Index");
                }
            }
        }
    }
}