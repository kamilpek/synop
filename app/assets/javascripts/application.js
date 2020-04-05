// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require jquery3
//= require popper
//= require bootstrap-sprockets
//= require underscore
//= require_tree .
//= require_self
//= require leaflet

window.onload = activeCollapse();

function activeCollapse() {
    $(".sidebar-sticky ul li").each(function() {
        if($(this).children("a").hasClass("active") && $(this).parent().hasClass("collapse")){
            $(this).parent().toggleClass("collapse");
        }
    });
}

function mapsCollapse() {
    $("#maps").toggleClass("collapse");
};

function alertsCollapse() {
    $("#alerts").toggleClass("collapse");
};

function radarsCollapse() {
    $("#radars").toggleClass("collapse");
};

function calendarsCollapse() {
    $("#calendars").toggleClass("collapse");
};

function modelsCollapse() {
    $("#models").toggleClass("collapse");
};