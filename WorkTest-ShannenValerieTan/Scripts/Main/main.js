function loginFunction()
{
    var iv = calcSHA1($('#userName').val()).substr(0, 16);
    var key = calcSHA1($('#userPassword').val()).substr(0,32);
    var data = ("Authenticate");
    var encryptedData = encrypt(data, iv, key);
    $.ajax({
        url: '/Main/Authenticate',
        data: {
            data: encryptedData,
            userName: $('#userName').val()
        },
        success: function (result) {
            if (result == "true") {
                window.location.href = '/Main/Index';
            }
            else {
                toastr.error("Invalid Username or Password!");
            }
        }

    });
}