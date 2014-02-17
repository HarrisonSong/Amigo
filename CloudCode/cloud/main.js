
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
    response.success("Hello world from Inian!");
});

Parse.Cloud.define("sendMail", function(request, response) {
    var Mailgun = require('mailgun');
    var toAddress = request.params.toMail;
    Mailgun.initialize('memoriz.mailgun.org', 'key-098t8sr-uwk0t7m-j7fvmfspksm-f4k9');
    Mailgun.sendEmail({
        to: toAddress,
        from: "memoriz.co@gmail.com",
        subject: "Hello from Memoriz!",
        text: "Welcome from Memoriz!!! Check out our app which promotes interaction between close friends!"
    }, {
        success: function(httpResponse) {
            console.log(httpResponse);
            response.success("Email sent!");
        },
        error: function(httpResponse) {
            console.error(httpResponse);
            response.error("Uh oh, something went wrong");
        }
    });
});

Parse.Cloud.define("updatePoints", function(request, response){
    Parse.initialize("gGjGCPb30DYQCUgDhrcJDfYVWy34iMbtuNblKHMl", "tCNBAXP7STQNOoZhVZiYYGZjsKQk30vAb32572G2");

    var Points = Parse.Object.extend("PFPoints");
    var query = new Parse.Query(Points);
    query.find({
        success: function(results) {
            console.log("Successfully retrieved " + results.length + " rows.");
            for (var i = 0; i < results.length; i++){
                console.log(results[i].get("points"));
                //increase the points
                var points = results[i].get("points");
                if (points >= 10) {
                    results[i].set("points", points - 10);
                    results[i].save(null, null);
                }
            }
        },
        error: function(error) {
            console.log("Error: " + error.code + " " + error.message);
        }
    });
});
