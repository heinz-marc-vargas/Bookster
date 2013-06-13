$.validator.addMethod("uniqueEmail", function(value, element) {
    return !$(element).hasClass("duplicate");
  }, "Email address already in use");

$.validator.addMethod("validSubdomain", function(value, element) {
     var reg = new RegExp(/^[a-zA-Z0-9\d-]+$/);
     return this.optional(element) || reg.test(value);
  }, "Enter a valid subdomain");

$.validator.addMethod("validZipCode", function(value, element) {
     var reg = new RegExp(/^[0-9\d=.+-]+$/);
     return this.optional(element) || reg.test(value);
  }, "Enter a valid zipcode");

$.validator.addMethod("validTelno", function(value, element) {
     var reg = new RegExp(/^[0-9\d=.+-]+$/);
     return this.optional(element) || reg.test(value);
  }, "Enter a valid telephone number");
  

var Application = {
  load_content: function(path, params){
    $('#main .main_content').fadeOut("fast");
    $('#main .main_content').load(path, params);
    $('#main .main_content').fadeIn("slow");
  },

  render_content: function(content){
    $('#main .main_content').html(content);
  }
};
