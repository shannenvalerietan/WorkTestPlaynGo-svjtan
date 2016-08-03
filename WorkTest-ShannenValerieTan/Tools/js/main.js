
$(document).ready(function () {
    generateTable();
});
$('.dtp').datepicker({
    format: 'mm/dd/yyyy'
});
function generateTable() {
    try {
        $('#txtTableId').trigger("click");
        getTableId();
        $('table').dataTable().fnDestroy();
        var oTable = $('table').dataTable({
            "bProcessing": true,
            "bServerSide": true,
            "bSortClasses": true,
            "sAjaxSource": tableId,
            "aoColumnDefs": [{
                'bSortable': false,
                'bSort': false,
                'aTargets': [-1]
            }]
        });
    }
    catch (e) {

    }
}
function getTableId() {
    try {
        var t = this.parentNode;
        tagName = "table";
        while (t) {
            if (t.tagName && t.tagName.toLowerCase() == tagName) {
                tableId = t.id;
                return;
            }
            else {
                t = t.parentNode;
            }
        }
        return tableId;
    }
    catch (e) {
    }
}

